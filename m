Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2EXILk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:11:40 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:47726 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab2EXILg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:17:1>);
	Thu, 24 May 2012 04:11:36 -0400
Message-Id: <4FBE09740200007800085B89@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 24 May 2012 09:12:04 +0100
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
 <4FBD157602000078000858F7@nat28.tlf.novell.com>
 <4FBDD82C.4020003@intel.com>
In-Reply-To: <4FBDD82C.4020003@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 24.05.12 at 08:41, Alex Shi <alex.shi@intel.com> wrote:
> On 05/23/2012 10:51 PM, Jan Beulich wrote:
>> Unless there is an implicit assumption that 'start' and 'end' are on
>> the same page (which I doubt, as then it would be pointless to
>> add 'end' here), this one is definitely wrong - you'd either have
>> to issue multiple MMUEXT_INVLPG_MULTI-s, or you'd have to
>> also use MMUEXT_TLB_FLUSH_MULTI for the multi-page case.
> 
> Thanks comments!
> So, the following change should be more safe for PV?
> 
> -       if (va == TLB_FLUSH_ALL) {
> -               args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
> -       } else {
> -               args->op.cmd = MMUEXT_INVLPG_MULTI;
> -               args->op.arg1.linear_addr = va;
> -       }
> +       args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;

This would be safe ...

> +       if (start != TLB_FLUSH_ALL)
> +               args->op.arg1.linear_addr = start;

... and then this superfluous, but it'd result in an unconditional
full TLB flush. When start and end (or perhaps end-1, assuming
end is not inclusive) are on the same page, MMUEXT_INVLPG_MULTI
should be used; MMUEXT_TLB_FLUSH_MULTI might need to be
used in all other cases, unless you want to split multi-page, non-
global invalidations into multiple MMUEXT_INVLPG_MULTI-s (which
would appear to be what the whole patch aims at).

Perhaps the abstraction layer needs to be changed instead:
Have the low level routines (Xen, UV, native) just deal with
single pages, and do the splitting in common code (using the
TLB size metrics).

But then again these metrics will become stale after a
migration (not only on Xen, but in all virtualization scenarios), so
some additional aspects will need to be taken care of anyway.

> 
>         MULTI_mmuext_op(mcs.mc, &args->op, 1, NULL, DOMID_SELF);
> 
> Do you know why the old patch is past the performance testing of Yongjie? 
> https://lkml.org/lkml/2012/5/4/20 

No - mere luck perhaps (possibly because the invalidation policy
inside the hypervisor is strict enough to paper over the flaw
here)?

Jan

