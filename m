Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933560Ab2EWO7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:59:14 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:53219 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756730Ab2EWO7N convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:17:1>);
	Wed, 23 May 2012 10:59:13 -0400
Message-Id: <4FBD157602000078000858F7@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 23 May 2012 15:51:02 +0100
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
Subject: Re: [PATCH v7 2/8] x86/flush_tlb: try flush_tlb_single one by
 one in flush_tlb_range
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
 <1337782555-8088-3-git-send-email-alex.shi@intel.com>
In-Reply-To: <1337782555-8088-3-git-send-email-alex.shi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 23.05.12 at 16:15, Alex Shi <alex.shi@intel.com> wrote:
> @@ -1269,11 +1270,11 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
>  	cpumask_and(to_cpumask(args->mask), cpus, cpu_online_mask);
>  	cpumask_clear_cpu(smp_processor_id(), to_cpumask(args->mask));
>  
> -	if (va == TLB_FLUSH_ALL) {
> +	if (start == TLB_FLUSH_ALL) {
>  		args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
>  	} else {
>  		args->op.cmd = MMUEXT_INVLPG_MULTI;
> -		args->op.arg1.linear_addr = va;
> +		args->op.arg1.linear_addr = start;
>  	}
>  
>  	MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);

Unless there is an implicit assumption that 'start' and 'end' are on
the same page (which I doubt, as then it would be pointless to
add 'end' here), this one is definitely wrong - you'd either have
to issue multiple MMUEXT_INVLPG_MULTI-s, or you'd have to
also use MMUEXT_TLB_FLUSH_MULTI for the multi-page case.

The same would appear to apply to the UV case, albeit I don't
know enough about that code to be certain.

Jan

