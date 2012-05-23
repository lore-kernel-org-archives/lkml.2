Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594Ab2EWRJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:09:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:54388 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab2EWRJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:09:57 -0400
Subject: Re: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings
 of SMT
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jan Beulich <JBeulich@suse.com>
Cc: Alex Shi <alex.shi@intel.com>, borislav.petkov@amd.com, arnd@arndb.de,
        akinobu.mita@gmail.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, hughd@google.com, jeremy@goop.org,
        len.brown@intel.com, tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com
In-Reply-To: <4FBD18D20200007800085951@nat28.tlf.novell.com>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
	 <1337782555-8088-9-git-send-email-alex.shi@intel.com>
	 <4FBD18D20200007800085951@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 19:09:44 +0200
Message-ID: <1337792984.9783.37.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 16:05 +0100, Jan Beulich wrote:
> >>> On 23.05.12 at 16:15, Alex Shi <alex.shi@intel.com> wrote:
> > +	/* doing flush on both siblings of SMT is just wasting time */
> > +	cpumask_copy(&flush_mask, cpumask);
> > +	if (likely(smp_num_siblings > 1)) {
> > +		rand = jiffies;
> > +		/* See "Numerical Recipes in C", second edition, p. 284 */
> > +		rand = rand * 1664525L + 1013904223L;
> > +		rand &= 0x1;
> > +
> > +		for_each_cpu(cpu, &flush_mask) {
> > +			sblmask = cpu_sibling_mask(cpu);
> > +			if (cpumask_subset(sblmask, &flush_mask)) {
> > +				if (rand == 0)
> > +					cpu_clear(cpu, flush_mask);
> > +				else
> > +					cpu_clear(cpumask_next(cpu, sblmask),
> > +								flush_mask);
> > +			}
> > +		}
> > +	}
> > +
> 
> There is no comment or anything else indicating that this is
> suitable for dual-thread CPUs only - when there are more than
> 2 threads per core, the intended effect won't be achieved.

Why would that be? Won't higher thread count still share the same
resources just more so?

>  I'd
> recommend making the logic generic from the beginning, but if
> that doesn't seem feasible to you, at least a comment stating
> the limitation should be added imo.

My objection to the whole lot is that its looks mightily expensive on
large machines, cpumask operations aren't cheap when you've got 4k cpus
etc..

Also, you very much cannot put cpumask_t on stack.

