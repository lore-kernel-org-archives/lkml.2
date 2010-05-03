Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401Ab0ECN1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:27:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:59045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341Ab0ECN1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:27:17 -0400
Subject: Re: [PATCH 1/4] cpu_stop: implement stop_cpu[s]()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, x86@kernel.org,
       oleg@redhat.com, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       arjan@linux.intel.com, torvalds@linux-foundation.org
In-Reply-To: <1271952554-22368-2-git-send-email-tj@kernel.org>
References: <1271952554-22368-1-git-send-email-tj@kernel.org>
	 <1271952554-22368-2-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 03 May 2010 15:26:29 +0200
Message-ID: <1272893189.5605.119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-22 at 18:09 +0200, Tejun Heo wrote:
> +static int cpu_stopper_thread(void *data)
> +{
> +       struct cpu_stopper *stopper = data; 

BUG_ON(stopper != __get_cpu_var(cpu_stopper)); ?

> +       work = NULL;
> +       spin_lock_irq(&stopper->lock);
> +       if (!list_empty(&stopper->works)) {
> +               work = list_first_entry(&stopper->works,
> +                                       struct cpu_stop_work, list);
> +               list_del_init(&work->list);
> +       }
> +       spin_unlock_irq(&stopper->lock);

Not sure if its worth the hassle, but you could list_splice_init() the
complete pending list onto a local list, possible avoiding some locks.

But since this isn't supposed to be used much, I doubt we'll ever see
the difference.

> +               /* restore preemption and check it's still balanced */
> +               preempt_enable();
> +               WARN_ON_ONCE(preempt_count());

You would use WARN_ONCE() and print the function that last ran and
leaked the preempt count.


