Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab1DEPi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 11:38:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38857 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754017Ab1DEPiZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:38:25 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
 <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
 <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
 <alpine.LSU.2.00.1103182158200.18771@sister.anvils> <BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
 <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
 <BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com> <BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
 <BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com> <BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Apr 2011 08:37:32 -0700
Message-ID: <BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
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

On Tue, Apr 5, 2011 at 5:21 AM, Robert Święcki <robert@swiecki.net> wrote:
>
> Here it is, I'll leave it in this state (kdb) in case you need some
> remote debugging
>
> <4>[ 1523.877666] WARNING: at mm/prio_tree.c:95 vma_prio_tree_add+0x43/0x110()
> <4>[ 1523.978650] vm_area_struct at ffff880120bda508:
> <4>[ 1523.983199]  ffff88011eb5aa00 00000000f72f3000 00000000f73f0000 ffff88011b8eaa10
> <4>[ 1523.990674]  ffff88011b8ea228 0000000000000027 00000000000101ff ffff88011b8ea6b1
> <4>[ 1523.998151]  ffff88011e390820 ffff88011b8ea260 ffff880120796780 ffff880120bdad40
> <4>[ 1524.005624]            (null)           (null) ffff88011ed5b910 ffff88011ed5b1f0
> <4>[ 1524.013103]  ffff88011f72b168 ffffffff82427480 ffffffffffffff03 ffff8800793ff0c0
> <4>[ 1524.020581]            (null)           (null)           (null)

vma->vm_start/end is 0xf72f3000-0xf73f0000

> <4>[ 1524.026556] vm_area_struct at ffff880120bdacf0:
> <4>[ 1524.031110]  ffff88011eb5a300 00000000f72f3000 00000000f7400000 ffff88011f6c6f18
> <4>[ 1524.038584]  ffff88011b5c9da8 0000000000000027 00000000000101ff ffff8801206f0c71
> <4>[ 1524.046062]  ffff88011f6c6f50 ffff88011b5c9de0 ffff880120bdad40 ffff880120bdad40
> <4>[ 1524.053536]  ffff880120bda558           (null) ffff88011f758ee0 ffff88011f7583a0
> <4>[ 1524.061016]  ffff88011f556690 ffffffff82427480 ffffffffffffff03 ffff8800793ff0c0
> <4>[ 1524.068491]            (null)           (null)           (null)

vma->vm_start/end is 0xf72f3000-0xf7400000.

If I read those right, then the vm_pgoff (RADIX_INDEX for the
prio-tree) is ffffffffffffff03 for both cases. That doesn't look good.
How do we get a negative pg_off for a file mapping?

Also, since they have a different size, they should have a different
HEAP_INDEX. That's why we BUG_ON() - with a different HEAP_INDEX,
shouldn't that mean that the prio_tree_insert() logic should create a
new node for it?

I dunno. But that odd negative pg_off thing makes me think there is
some overflow issue (ie HEAP_INDEX being pg_off + size ends up
fluctuating between really big and really small). So I'd suspect THAT
as the main reason.

But maybe I'm mis-reading the dump, and the ffffffffffffff03 isn't
vm_pgoff at all.

Hugh?

                              Linus
