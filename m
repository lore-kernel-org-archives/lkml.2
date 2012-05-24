Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2EXI5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 04:57:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:37430 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2EXI5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 04:57:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="144107194"
Message-ID: <4FBDF79D.1060805@intel.com>
Date: Thu, 24 May 2012 16:55:57 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: borislav.petkov@amd.com, arnd@arndb.de, a.p.zijlstra@chello.nl,
        akinobu.mita@gmail.com, eric.dumazet@gmail.com, fweisbec@gmail.com,
        rostedt@goodmis.org, hughd@google.com, jeremy@goop.org,
        len.brown@intel.com, tony.luck@intel.com, yongjie.ren@intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, seto.hidetoshi@jp.fujitsu.com,
        penberg@kernel.org, yinghai@kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, ak@linux.intel.com, luto@mit.edu,
        avi@redhat.com, dhowells@redhat.com, mingo@redhat.com, riel@redhat.com,
        cpw@sgi.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hpa@zytor.com
Subject: Re: [PATCH v7 2/8] x86/flush_tlb: try flush_tlb_single one by one
 in flush_tlb_range
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com> <1337782555-8088-3-git-send-email-alex.shi@intel.com> <4FBD157602000078000858F7@nat28.tlf.novell.com> <4FBDD82C.4020003@intel.com> <4FBE09740200007800085B89@nat28.tlf.novell.com>
In-Reply-To: <4FBE09740200007800085B89@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 04:12 PM, Jan Beulich wrote:

>>>> On 24.05.12 at 08:41, Alex Shi <alex.shi@intel.com> wrote:
>> On 05/23/2012 10:51 PM, Jan Beulich wrote:
>>> Unless there is an implicit assumption that 'start' and 'end' are on
>>> the same page (which I doubt, as then it would be pointless to
>>> add 'end' here), this one is definitely wrong - you'd either have
>>> to issue multiple MMUEXT_INVLPG_MULTI-s, or you'd have to
>>> also use MMUEXT_TLB_FLUSH_MULTI for the multi-page case.
>>
>> Thanks comments!
>> So, the following change should be more safe for PV?
>>
>> -       if (va == TLB_FLUSH_ALL) {
>> -               args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
>> -       } else {
>> -               args->op.cmd = MMUEXT_INVLPG_MULTI;
>> -               args->op.arg1.linear_addr = va;
>> -       }
>> +       args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
> 
> This would be safe ...
> 
>> +       if (start != TLB_FLUSH_ALL)
>> +               args->op.arg1.linear_addr = start;
> 
> ... and then this superfluous, but it'd result in an unconditional
> full TLB flush. When start and end (or perhaps end-1, assuming
> end is not inclusive) are on the same page, MMUEXT_INVLPG_MULTI
> should be used; MMUEXT_TLB_FLUSH_MULTI might need to be
> used in all other cases, unless you want to split multi-page, non-
> global invalidations into multiple MMUEXT_INVLPG_MULTI-s (which
> would appear to be what the whole patch aims at).


        args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
-       if (start != TLB_FLUSH_ALL)
+       if (start != TLB_FLUSH_ALL && (end - start) < PAGE_SIZE) {
+               args->op.cmd = MMUEXT_INVLPG_MULTI;
                args->op.arg1.linear_addr = start;
+       }

So, above it correct code for xen?
As to the xen optimisation of flush range, it is may better to be done
in a separate patch.

> 
> Perhaps the abstraction layer needs to be changed instead:
> Have the low level routines (Xen, UV, native) just deal with
> single pages, and do the splitting in common code (using the
> TLB size metrics).
> 
> But then again these metrics will become stale after a
> migration (not only on Xen, but in all virtualization scenarios), so
> some additional aspects will need to be taken care of anyway.


Sure, thanks for your care!
