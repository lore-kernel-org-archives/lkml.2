Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab0EGMmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:42:21 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64387 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab0EGMmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:42:20 -0400
To: xiaosuo@gmail.com, akpm@linux-foundation.org
Cc: eric.dumazet@gmail.com, jslaby@suse.cz, viro@zeniv.linux.org.uk,
       paulmck@linux.vnet.ibm.com, adobriyan@gmail.com, mingo@elte.hu,
       peterz@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [RFC] mm: generic adaptive large memory allocation APIs
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1273105838-4441-1-git-send-email-xiaosuo@gmail.com>
	<t2p412e6f7f1005062132lbcaf5192ua6ead4872465a766@mail.gmail.com>
In-Reply-To: <t2p412e6f7f1005062132lbcaf5192ua6ead4872465a766@mail.gmail.com>
Message-Id: <201005072142.IIC30776.FFtOOHMOVFJLQS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 7 May 2010 21:42:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changli Gao wrote:
> static void __kvfree(void *ptr, bool inatomic)

inatomic might be confusing because what vfree() checks is
BUG_ON(in_interrupt()) rather than BUG_ON(in_atomic()).

> {
>         if (unlikely(ZERO_OR_NULL_PTR(ptr)))
>                 return;
>         if (is_vmalloc_addr(ptr)) {
>                 if (inatomic) {

By the way, is in_interrupt() a heavy operation?

  register unsigned long current_stack_pointer asm("esp") __used;
  static inline struct thread_info *current_thread_info(void)
  {
  	return (struct thread_info *)
  		(current_stack_pointer & ~(THREAD_SIZE - 1));
  }
  #define preempt_count() (current_thread_info()->preempt_count)
  #define irq_count()     (preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK | NMI_MASK))
  #define in_interrupt()  (irq_count())

If we can agree on changing from (inatomic) to (in_interrupt()),
we can merge kvfree() and kvfree_inatomic().

>                         struct work_struct *work;
> 
>                         work = ptr;
>                         BUILD_BUG_ON(sizeof(struct work_struct) > PAGE_SIZE);
>                         INIT_WORK(work, kvfree_work);
>                         schedule_work(work);
>                 } else {
>                         vfree(ptr);
>                 }
>         } else {
>                 struct page *page;
> 
>                 page = virt_to_head_page(ptr);
>                 if (PageSlab(page) || PageCompound(page))
>                         kfree(ptr);
>                 else
>                         free_pages_exact(ptr, page->private);
>         }
> }
