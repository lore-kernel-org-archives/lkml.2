Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab0EQJCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:02:35 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:53779 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0EQJCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:02:33 -0400
Message-ID: <4BF1070B.4000507@oss.ntt.co.jp>
Date: Mon, 17 May 2010 18:06:19 +0900
From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>, mtosatti@redhat.com,
       agraf@suse.de, fernando@oss.ntt.co.jp, kvm@vger.kernel.org,
       kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, arnd@arndb.de, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/12] KVM, x86, ppc, asm-generic: moving dirty bitmaps
 to user space
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com> <4BE7F6D7.3060005@redhat.com> <4BE7FB7B.5010600@oss.ntt.co.jp> <4BEBE6D0.8020000@redhat.com>
In-Reply-To: <4BEBE6D0.8020000@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> User allocated bitmaps have the advantage of reducing pinned memory.
> However we have plenty more pinned memory allocated in memory slots, so
> by itself, user allocated bitmaps don't justify this change.

In that sense, what do you think about the question I sent last week?

=== REPOST 1 ===
 >>
 >> mark_page_dirty is called with the mmu_lock spinlock held in set_spte.
 >> Must find a way to move it outside of the spinlock section.
 >>
 >
 > Oh, it's a serious problem. I have to consider it.

Avi, Marcelo,

Sorry but I have to say that mmu_lock spin_lock problem was completely out of
my mind. Although I looked through the code, it seems not easy to move the
set_bit_user to outside of spinlock section without breaking the semantics of
its protection.

So this may take some time to solve.

But personally, I want to do something for x86's "vmallc() every time" problem
even though moving dirty bitmaps to user space cannot be achieved soon.

In that sense, do you mind if we do double buffering without moving dirty bitmaps to
user space?

I know that the resource for vmalloc() is precious for x86 but even now, at the timing
of get_dirty_log, we use the same amount of memory as double buffering.
=== 1 END ===


>
> Perhaps if we optimize memory slot write protection (I have some ideas
> about this) we can make the performance improvement more pronounced.
>

It's really nice!

Even now we can measure the performance improvement by introducing switch ioctl
when guest is relatively idle, so the combination will be really effective!

=== REPOST 2 ===
 >>
 >> Can you post such a test, for an idle large guest?
 >
 > OK, I'll do!


Result of "low workload test" (running top during migration) first,

4GB guest
picked up slots[1](len=3757047808) only
*****************************************
     get.org     get.opt    switch.opt

     1060875     310292     190335
     1076754     301295     188600
      655504     318284     196029
      529769     301471        325
      694796      70216     221172
      651868     353073     196184
      543339     312865     213236
     1061938      72785     203090
      689527     323901     249519
      621364     323881        473
     1063671      70703     192958
      915903     336318     174008
     1046462     332384        782
     1037942      72783     190655
      680122     318305     243544
      688156     314935     193526
      558658     265934     190550
      652454     372135     196270
      660140      68613        352
     1101947     378642     186575
         ...        ...        ...
*****************************************

As expected we've got the difference more clearly.

In this case, switch.opt reduced 1/3 (.1 msec) compared to get.opt
for each iteration.

And when the slot is cleaner, the ratio is bigger.
=== 2 END ===
