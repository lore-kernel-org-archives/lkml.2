Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965640Ab0COSUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 14:20:30 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48019 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965596Ab0COSU3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 14:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rsMAG6TBWH+Uh+DcAT8AO07JzHsdcQDrMt0WJDHFMFjwO4upKrYW/yBOY6junpXaU2
         lJj/hXLu102nFkrlxy46fm9UmZyROtChBYGe9pSj8f85nVqQmsvwD6ZKhL37yCuVILHB
         sS/h44zlaZm54CtjZGyRR43ELs47LoV013Q6w=
MIME-Version: 1.0
In-Reply-To: <4B9B812F.3030306@free.fr>
References: <4B9B812F.3030306@free.fr>
Date: Mon, 15 Mar 2010 14:20:24 -0400
Message-ID: <817ecb6f1003151120s3e6f34acl39563fc0dc8fa9db@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: NX protection for kernel data
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: matthieu castet <castet.matthieu@free.fr>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 8:12 AM, matthieu castet
<castet.matthieu@free.fr> wrote:
> Hi,
>
>> > looking for c17ebdb8 in system.map points to a location in pgd_lock:
>> > ============================================
>> > $grep c17ebd System.map
>> > c17ebd68 d bios_check_work
>> > c17ebda8 d highmem_pages
>> > c17ebdac D pgd_lock
>> > c17ebdc8 D pgd_list
>> > c17ebdd0 D show_unhandled_signals
>> > c17ebdd4 d cpa_lock
>> > c17ebdf0 d memtype_lock
>> > ============================================
>> >
>> > I've looked at the lock debugging and could not find any place that
>> > would look like an attempt to execute data. This would lead me to
>> > think that calling set_memory_nx from kernel_init somehow confuses the
>> > lock debugging subsystem, or set_memory_nx does not change page
>> > attributes in a safe manner (for example when a lock is stored inside
>> > the page whose attributes are being changed).
>>
>> I've done some extra debugging and it really does look like the crash
>> happens when we are setting NX on a large page which has pgd_lock
>> inside it.
>>
>> Here is a trace of printk's that I added to troubleshoot this issue:
>> =========================
>> [    3.072003] try_preserve_large_page - enter
>> [    3.073185] try_preserve_large_page - address: 0xc1600000
>> [    3.074513] try_preserve_large_page - 2M page
>> [    3.075606] try_preserve_large_page - about to call static_protections
>> [    3.076000] try_preserve_large_page - back from static_protections
>> [    3.076000] try_preserve_large_page - past loop
>> [    3.076000] try_preserve_large_page - new_prot != old_prot
>> [    3.076000] try_preserve_large_page - the address is aligned and
>> the number of pages covers the full range
>> [    3.076000] try_preserve_large_page - about to call __set_pmd_pte
>> [    3.076000] __set_pmd_pte - enter
>> [    3.076000] __set_pmd_pte - address: 0xc1600000
>> [    3.076000] __set_pmd_pte - about to call
>> set_pte_atomic(*0xc18c0058(low=0x16001e3, high=0x0), (low=0x16001e1,
>> high=0x80000000))
>> [lock-up here]
>> =========================
>>
[...]
> 0xc1600000 2MB page is in 0xc1600000-0xc1800000 range.  pgd_lock
> (0xc17ebdac) seems to be in that range.

That's what I was thinking...

> You change attribute from (low=0x16001e3, high=0x0) to (low=0x16001e1,
> high=0x80000000). IE you set
> NX bit (bit 63), but you also clear R/W bit (bit 2). So the page become read
> only, but you are using a lock
> inside this page that need RW access. So you got a page fault.

Yes, that would do it.

> Now I don't know what should be done.
> Is that normal we set the page RO ?

No, this page should not be RO, as it contains kernel's RW data.
The interesting part is that the call that initiates the change is
set_memory_nx(), so it should not be clearing RW bit... The
interesting part is that the kernel does not crash with lock debugging
disabled.

Thanks for your help.
