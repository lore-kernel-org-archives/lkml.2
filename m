Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665Ab2EWPEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:04:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:37949 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab2EWPEx convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:17:1>);
	Wed, 23 May 2012 11:04:53 -0400
Message-Id: <4FBD18D20200007800085951@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 23 May 2012 16:05:22 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alex Shi" <alex.shi@intel.com>
Cc: <borislav.petkov@amd.com>, <arnd@arndb.de>, <a.p.zijlstra@chello.nl>,
        <akinobu.mita@gmail.com>, <eric.dumazet@gmail.com>,
        <fweisbec@gmail.com>, <rostedt@goodmis.org>, <hughd@google.com>,
        <jeremy@goop.org>, <len.brown@intel.com>, <tony.luck@intel.com>,
        <yongjie.ren@intel.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <seto.hidetoshi@jp.fujitsu.com>, <penberg@kernel.org>,
        <yinghai@kernel.org>, <tglx@linutronix.de>,
        <akpm@linux-foundation.org>, <ak@linux.intel.com>, <luto@mit.edu>,
        <avi@redhat.com>, <dhowells@redhat.com>, <mingo@redhat.com>,
        <riel@redhat.com>, <cpw@sgi.com>, <steiner@sgi.com>,
        <linux-kernel@vger.kernel.org>, <viro@zeniv.linux.org.uk>,
        <hpa@zytor.com>
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of
 siblings of SMT
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
 <1337782555-8088-9-git-send-email-alex.shi@intel.com>
In-Reply-To: <1337782555-8088-9-git-send-email-alex.shi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.05.12 at 16:15, Alex Shi <alex.shi@intel.com> wrote:
> +	/* doing flush on both siblings of SMT is just wasting time */
> +	cpumask_copy(&flush_mask, cpumask);
> +	if (likely(smp_num_siblings > 1)) {
> +		rand = jiffies;
> +		/* See "Numerical Recipes in C", second edition, p. 284 */
> +		rand = rand * 1664525L + 1013904223L;
> +		rand &= 0x1;
> +
> +		for_each_cpu(cpu, &flush_mask) {
> +			sblmask = cpu_sibling_mask(cpu);
> +			if (cpumask_subset(sblmask, &flush_mask)) {
> +				if (rand == 0)
> +					cpu_clear(cpu, flush_mask);
> +				else
> +					cpu_clear(cpumask_next(cpu, sblmask),
> +								flush_mask);
> +			}
> +		}
> +	}
> +

There is no comment or anything else indicating that this is
suitable for dual-thread CPUs only - when there are more than
2 threads per core, the intended effect won't be achieved. I'd
recommend making the logic generic from the beginning, but if
that doesn't seem feasible to you, at least a comment stating
the limitation should be added imo.

Jan

