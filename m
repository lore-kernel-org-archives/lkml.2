Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2IJOgc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:36:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46268 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2IJOg3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:36:29 -0400
Message-ID: <1347287780.2124.10.camel@twins>
Subject: Re: Linux 3.6-rc4
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 10 Sep 2012 16:36:20 +0200
In-Reply-To: <CA+55aFwh5kUDC_5-_4_TkqnQU73sotAkOs166ag4R3Fx8VKffw@mail.gmail.com>
References: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com>
	 <20120904154412.GA14321@redhat.com> <504A3527.9070104@gmail.com>
	 <CA+55aFwh5kUDC_5-_4_TkqnQU73sotAkOs166ag4R3Fx8VKffw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 11:39 -0700, Linus Torvalds wrote:
> Al? Please look into this. I'm not entirely sure what's going on, but
> lockdep complains about this:
> 
>  Possible interrupt unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&(&p->alloc_lock)->rlock);
>                                local_irq_disable();
>                                lock(&(&new_timer->it_lock)->rlock);
>                                lock(tasklist_lock);
>   <Interrupt>
>     lock(&(&new_timer->it_lock)->rlock);
> 
>  *** DEADLOCK ***
> 
> and it looks real. IOW, if I read that right, we have the task_lock ->
> it_lock dependency through exit_itimers(), and then we have the
> tasklist_lock -> task_lock dependency everywhere else. So now it_lock
> -> tasklist_lock becomes a deadlock. 

Agreed, I've got the following series from Oleg queued to solve this:

 http://marc.info/?l=linux-kernel&m=134600821828491&w=2


