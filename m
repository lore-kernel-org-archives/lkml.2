Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab2EWPoB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:44:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:34947 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752042Ab2EWPoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:44:00 -0400
Message-ID: <1337787838.1734.15.camel@joe2Laptop>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Chen <hi3766691@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 08:43:58 -0700
In-Reply-To: <20120523150359.GB26974@gmail.com>
References: <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
	 <1337084609.27020.156.camel@laptop>
	 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
	 <1337086834.27020.162.camel@laptop>
	 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
	 <1337096141.27694.82.camel@twins> <1337193010.27694.146.camel@twins>
	 <CA+55aFzuygx6L-2hVCMbk5cvEdDp6AUtOGq-wYFn=4yEyebPLw@mail.gmail.com>
	 <1337468148.573.139.camel@twins>
	 <CANQmPXhN92i9E8HqxE7pqz=kOwtn5Mz0crW37H6qs+XD420Yuw@mail.gmail.com>
	 <20120523150359.GB26974@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 17:03 +0200, Ingo Molnar wrote:
> * Chen <hi3766691@gmail.com> wrote:
> 
> > Still you are just trying to said that your code is not bloated?
> > Up to over 500K for a cpu scheduler. Laughing
> 
> Where did you get that 500K from? You are off from the truth 
> almost by an order of magnitude.
> 
> Here's the scheduler size on Linus's latest tree, on 64-bit 
> defconfig's:
> 
>  $ size kernel/sched/built-in.o 
>    text	   data	    bss	    dec	    hex	filename
>   83611	  10404	   2524	  96539	  1791b	kernel/sched/built-in.o
> 
> That's SMP+NUMA, i.e. everything included.
> 
> The !NUMA !SMP UP scheduler, if you are on a size starved 
> ultra-embedded device, is even smaller, just 22K:
> 
>  $ size kernel/sched/built-in.o 
>    text	   data	    bss	    dec	    hex	filename
>   19882	   2218	    148	  22248	   56e8	kernel/sched/built-in.o

Here's an allyesconfig x86-32
$ size kernel/sched/built-in.o
   text	   data	    bss	    dec	    hex	filename
 213892	  10856	  65832	 290580	  46f14	kernel/sched/built-in.o

But that's not the only sched related code.

In a 1000 cpu config, there also an extra 500+ bytes per cpu
in printk (I don't think that's particularly important btw)

kernel/printk.c adds:

static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);

Maybe #ifdefing this when !CONFIG_PRINTK would reduce size
a little in a few cases.  I've attached a trivial suggested patch.

btw: There's still the unnecessary
static DEFINE_PER_CPU(int, printk_pending);
but the code is more involved around that one.

printk.c needs some refactoring and modularization,
it's pretty ugly right now.

diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..3bd9a11 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1734,16 +1734,21 @@ int is_console_locked(void)
 #define PRINTK_PENDING_SCHED	0x02
 
 static DEFINE_PER_CPU(int, printk_pending);
-static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
+
+#ifdef CONFIG_PRINTK
+static DEFINE_PER_CPU(char[PRINTK_BUF_SIZE], printk_sched_buf);
+#endif
 
 void printk_tick(void)
 {
 	if (__this_cpu_read(printk_pending)) {
 		int pending = __this_cpu_xchg(printk_pending, 0);
+#ifdef CONFIG_PRINTK
 		if (pending & PRINTK_PENDING_SCHED) {
 			char *buf = __get_cpu_var(printk_sched_buf);
 			printk(KERN_WARNING "[sched_delayed] %s", buf);
 		}
+#endif
 		if (pending & PRINTK_PENDING_WAKEUP)
 			wake_up_interruptible(&log_wait);
 	}


