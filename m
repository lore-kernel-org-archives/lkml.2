Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034Ab1DLJ6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:58:39 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53924 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab1DLJ6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:58:37 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1104070718120.28555@sister.anvils>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
	<AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
	<AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
	<alpine.LSU.2.00.1103182158200.18771@sister.anvils>
	<BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
	<AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
	<BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com>
	<BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
	<BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com>
	<BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com>
	<BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com>
	<BANLkTimV1f1YDTWZUU9uvAtCO_fp6EKH9Q@mail.gmail.com>
	<BANLkTi=tavhpytcSV+nKaXJzw19Bo3W9XQ@mail.gmail.com>
	<alpine.LSU.2.00.1104060837590.4909@sister.anvils>
	<BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com>
	<BANLkTim0MZfa8vFgHB3W6NsoPHp2jfirrA@mail.gmail.com>
	<BANLkTim-hyXpLj537asC__8exMo3o-WCLA@mail.gmail.com>
	<alpine.LSU.2.00.1104070718120.28555@sister.anvils>
Date: Tue, 12 Apr 2011 11:58:36 +0200
Message-ID: <BANLkTik_9YW5+64FHrzNy7kPz1FUWrw-rw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 7, 2011 at 4:24 PM, Hugh Dickins <hughd@google.com> wrote:
> On Thu, 7 Apr 2011, Robert Swiecki wrote:
>> >
>> > Testing with Linus' patch. Will let you know in a few hours.
>>
>> Ok, nothing happened after ~20h. The bug, usually, was triggered within 5-10h.
>>
>> I can add some printk in this condition, and let it run for a few days
>> (I will not have access to my testing machine throughout that time),
>> if you think this will confirm your hypothesis.
>
> That's great, thanks Robert.  If the machine has nothing better to do,
> then it would be nice to let it run a little longer (a few days if that's
> what suits you), but it does look good so far.  Though I'm afraid you'll
> now discover something else entirely ;)

Ok, I added printk here:

        if (new_len > old_len) {
                unsigned long pgoff;

                if (vma->vm_flags & (VM_DONTEXPAND | VM_PFNMAP))
                        goto Efault;
                pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
                pgoff += vma->vm_pgoff;
                if (pgoff + (new_len >> PAGE_SHIFT) < pgoff) {
                        printk("VMA_TO_RESIZE: ADDR:%lx OLD_LEN:%lx
NEW_LEN:%lx PGOFF: %lx VMA->VM_START:%lx VMA->VM_FLAGS:%lx",
                                addr, old_len, new_len, pgoff,
vma->vm_start, vma->vm_flags);

                        goto Einval;
                }
        }


and after a few mins of fuzzing I get:

[  584.224028] VMA_TO_RESIZE: ADDR:f751f000 OLD_LEN:6000 NEW_LEN:c000
PGOFF: fffffffffffffffa VMA->VM_START:f751f000 VMA->VM_FLAGS:2321fa
[  639.777561] VMA_TO_RESIZE: ADDR:f751f000 OLD_LEN:6000 NEW_LEN:b000
PGOFF: fffffffffffffffa VMA->VM_START:f751f000 VMA->VM_FLAGS:2301f8

So, if this case is not caught later on in the code, I guess it solves
the problem. During the fuzzing I didn't experience any panic's, but
some other problems arose, i.e. cannot read /proc/<pid>/maps for some
processes (sys_read hangs, and such process cannot be killed or
stopped with any signal, still it's running (R state) and using CPU -
I'll submit another report for that).

-- 
Robert Święcki
