Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab1B1Xfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:35:42 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33736 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab1B1Xfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:35:41 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
Date: Mon, 28 Feb 2011 15:35:40 -0800
Message-ID: <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
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

> But rather than exporting the notion of restart_addr from memory.c, or
> converting to restart_pgoff throughout, simply reset vm_truncate_count
> to 0 to force a rescan if mremap move races with preempted truncation.
>
> We have no confirmation that this fixes Robert's BUG,
> but it is a fix that's worth making anyway.

Hi, I don't have currently access to my rs232/console testing machine
(lame excuse but it helps a lot;), cause I'm working currently OOtO,
so I'll try to test it asap - which is probably Mar 15th or so.

Btw, the fuzzer is here: http://code.google.com/p/iknowthis/

I think i was trying it with this revision:
http://code.google.com/p/iknowthis/source/detail?r=11 (i386 mode,
newest 'iknowthis' supports x86-64 natively), so feel free to try it.

It used to crash the machine (it's BUG_ON but the system became
unusable) in matter of hours. Btw, when I was testing it for the last
time it Ooopsed much more frequently in proc_readdir (I sent report in
one of earliet e-mails).

> Signed-off-by: Hugh Dickins <hughd@google.com>
> ---
>
>  mm/mremap.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> --- 2.6.38-rc6/mm/mremap.c      2011-01-18 22:04:56.000000000 -0800
> +++ linux/mm/mremap.c   2011-02-23 15:29:52.000000000 -0800
> @@ -94,9 +94,7 @@ static void move_ptes(struct vm_area_str
>                 */
>                mapping = vma->vm_file->f_mapping;
>                spin_lock(&mapping->i_mmap_lock);
> -               if (new_vma->vm_truncate_count &&
> -                   new_vma->vm_truncate_count != vma->vm_truncate_count)
> -                       new_vma->vm_truncate_count = 0;
> +               new_vma->vm_truncate_count = 0;
>        }
>
>        /*
>



-- 
Robert Święcki
