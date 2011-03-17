Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab1CQPkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 11:40:52 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:49481 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab1CQPkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 11:40:49 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
	<AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
Date: Thu, 17 Mar 2011 16:40:47 +0100
Message-ID: <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 1, 2011 at 12:35 AM, Robert Święcki <robert@swiecki.net> wrote:
>> But rather than exporting the notion of restart_addr from memory.c, or
>> converting to restart_pgoff throughout, simply reset vm_truncate_count
>> to 0 to force a rescan if mremap move races with preempted truncation.
>>
>> We have no confirmation that this fixes Robert's BUG,
>> but it is a fix that's worth making anyway.
>
> Hi, I don't have currently access to my rs232/console testing machine
> (lame excuse but it helps a lot;), cause I'm working currently OOtO,
> so I'll try to test it asap - which is probably Mar 15th or so.

So, I compiled 2.6.38 and started fuzzing it. I'm bumping into other
problems, and never seen anything about mremap in 2.6.38 (yet), as it
had been happening in 2.6.37-rc2. The output goes to
http://alt.swiecki.net/linux_kernel/ - I'm still trying.

> Btw, the fuzzer is here: http://code.google.com/p/iknowthis/
>
> I think i was trying it with this revision:
> http://code.google.com/p/iknowthis/source/detail?r=11 (i386 mode,
> newest 'iknowthis' supports x86-64 natively), so feel free to try it.
>
> It used to crash the machine (it's BUG_ON but the system became
> unusable) in matter of hours. Btw, when I was testing it for the last
> time it Ooopsed much more frequently in proc_readdir (I sent report in
> one of earliet e-mails).
>
>> Signed-off-by: Hugh Dickins <hughd@google.com>
>> ---
>>
>>  mm/mremap.c |    4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> --- 2.6.38-rc6/mm/mremap.c      2011-01-18 22:04:56.000000000 -0800
>> +++ linux/mm/mremap.c   2011-02-23 15:29:52.000000000 -0800
>> @@ -94,9 +94,7 @@ static void move_ptes(struct vm_area_str
>>                 */
>>                mapping = vma->vm_file->f_mapping;
>>                spin_lock(&mapping->i_mmap_lock);
>> -               if (new_vma->vm_truncate_count &&
>> -                   new_vma->vm_truncate_count != vma->vm_truncate_count)
>> -                       new_vma->vm_truncate_count = 0;
>> +               new_vma->vm_truncate_count = 0;
>>        }
>>
>>        /*
>>
>
>
>
> --
> Robert Święcki
>



-- 
Robert Święcki
