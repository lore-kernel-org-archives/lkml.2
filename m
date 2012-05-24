Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab2EXOg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 10:36:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:39686 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233Ab2EXOgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 10:36:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156756997"
Message-ID: <4FBE475F.9080301@intel.com>
Date: Thu, 24 May 2012 22:36:15 +0800
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
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com> <1337782555-8088-3-git-send-email-alex.shi@intel.com> <4FBD157602000078000858F7@nat28.tlf.novell.com> <4FBDD82C.4020003@intel.com> <4FBE09740200007800085B89@nat28.tlf.novell.com> <4FBDF79D.1060805@intel.com> <4FBE1F2A0200007800085C72@nat28.tlf.novell.com>
In-Reply-To: <4FBE1F2A0200007800085C72@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2012 05:44 PM, Jan Beulich wrote:

>>>> On 24.05.12 at 10:55, Alex Shi <alex.shi@intel.com> wrote:
>> On 05/24/2012 04:12 PM, Jan Beulich wrote:
>>
>>>>>> On 24.05.12 at 08:41, Alex Shi <alex.shi@intel.com> wrote:
>>>> So, the following change should be more safe for PV?
>>>>
>>>> -       if (va == TLB_FLUSH_ALL) {
>>>> -               args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
>>>> -       } else {
>>>> -               args->op.cmd = MMUEXT_INVLPG_MULTI;
>>>> -               args->op.arg1.linear_addr = va;
>>>> -       }
>>>> +       args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
>>>
>>> This would be safe ...
>>>
>>>> +       if (start != TLB_FLUSH_ALL)
>>>> +               args->op.arg1.linear_addr = start;
>>>
>>> ... and then this superfluous, but it'd result in an unconditional
>>> full TLB flush. When start and end (or perhaps end-1, assuming
>>> end is not inclusive) are on the same page, MMUEXT_INVLPG_MULTI
>>> should be used; MMUEXT_TLB_FLUSH_MULTI might need to be
>>> used in all other cases, unless you want to split multi-page, non-
>>> global invalidations into multiple MMUEXT_INVLPG_MULTI-s (which
>>> would appear to be what the whole patch aims at).
>>
>>
>>         args->op.cmd = MMUEXT_TLB_FLUSH_MULTI;
>> -       if (start != TLB_FLUSH_ALL)
>> +       if (start != TLB_FLUSH_ALL && (end - start) < PAGE_SIZE) {
> 
> Assuming 'end' is not inclusive (you didn't clarify that),
> 
>        if (start != TLB_FLUSH_ALL && (end - start) <= PAGE_SIZE) {
> 
> (and only if 'start' is guaranteed to be page aligned).


I still a idiot for xen and a newbie for kernel. :)
AFAIK, if system just flush one page, it won't set end there. But anyway
using '<=' has no problem.

> 
>> +               args->op.cmd = MMUEXT_INVLPG_MULTI;
>>                 args->op.arg1.linear_addr = start;
>> +       }
>>
>> So, above it correct code for xen?
>> As to the xen optimisation of flush range, it is may better to be done
>> in a separate patch.
> 
> Agreed.


Thanks for all comments!

> 
> Jan
> 


