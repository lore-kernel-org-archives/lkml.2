Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312Ab1GOIgm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 04:36:42 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43519 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965045Ab1GOIgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 04:36:41 -0400
Message-ID: <4E1FFC7B.4000209@gmail.com>
Date: Fri, 15 Jul 2011 16:38:19 +0800
From: MailingLists <haishan.bai@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: benh@kernel.crashing.org, paulus@samba.org, tglx@linutronix.de,
        walken@google.com, dhowells@redhat.com, cmetcalf@tilera.com,
        tony.luck@intel.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] Fixup write permission of TLB on powerpc e500 core
References: <1310717238-13857-1-git-send-email-haishan.bai@gmail.com> <1310718056.2586.275.camel@twins>
In-Reply-To: <1310718056.2586.275.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 04:20 PM, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 16:07 +0800, Shan Hai wrote:
>> The following test case could reveal a bug in the futex_lock_pi()
>>
>> BUG: On FUTEX_LOCK_PI, there is a infinite loop in the futex_lock_pi()
>>          on Powerpc e500 core.
>> Cause: The linux kernel on the e500 core has no write permission on
>>          the COW page, refer the head comment of the following test code.
>>
>> ftrace on test case:
>> [000]   353.990181: futex_lock_pi_atomic<-futex_lock_pi
>> [000]   353.990185: cmpxchg_futex_value_locked<-futex_lock_pi_atomic
>> [snip]
>> [000]   353.990191: do_page_fault<-handle_page_fault
>> [000]   353.990192: bad_page_fault<-handle_page_fault
>> [000]   353.990193: search_exception_tables<-bad_page_fault
>> [snip]
>> [000]   353.990199: get_user_pages<-fault_in_user_writeable
>> [snip]
>> [000]   353.990208: mark_page_accessed<-follow_page
>> [000]   353.990222: futex_lock_pi_atomic<-futex_lock_pi
>> [snip]
>> [000]   353.990230: cmpxchg_futex_value_locked<-futex_lock_pi_atomic
>> [ a loop occures here ]
>>
>
> But but but but, that get_user_pages(.write=1, .force=0) should result
> in a COW break, getting our own writable page.
>
> What is this e500 thing smoking that this doesn't work?

A page could be set to read only by the kernel (supervisor in the powerpc
literature) on the e500, and that's what the kernel do. Set SW(supervisor
write) bit in the TLB entry to grant write permission to the kernel on a
page.

And further the SW bit is set according to the DIRTY flag of the PTE,
PTE.DIRTY is set in the do_page_fault(), the futex_lock_pi() disabled
page fault, the PTE.DIRTY never can be set, so do the SW bit, unbreakable
COW occurred, infinite loop followed.

Thanks
Shan Hai
