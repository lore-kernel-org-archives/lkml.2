Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab2DQUc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 16:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273Ab2DQUc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 16:32:27 -0400
Date: Tue, 17 Apr 2012 16:32:23 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [3.4-rc3] Thread overran stack, or stack corrupted
Message-ID: <20120417203223.GA31699@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120417172142.GA30237@redhat.com>
 <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFy-uhOgEoEBr-LkOjFQBVh14wwr-20jTrtsg_2EnuNY5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 01:20:51PM -0700, Linus Torvalds wrote:
 > On Tue, Apr 17, 2012 at 10:21 AM, Dave Jones <davej@redhat.com> wrote:
 > > My syscall fuzzer started showing up some cases where it we seem to be
 > > overrunning the stack.  I added a WARN_ON when the stack is really low,
 > > to see if there's a deep call trace, but it's not really telling me much ..
 > 
 > You seem to have added the WARN_ON() to check_stack_usage() itself.
 > 
 > That's not very useful, because it uses the *current* stack pointer.
 > Instead, how about just calling "show_trace()" with the actual lowest
 > stack pointer at that point? That should show you the stack as it was
 > when it was at its lowest, and that could actually be useful.
 > 
 > IOW, just something like
 > 
 >     show_trace(NULL, NULL, (void *)end_of_stack(p) + lowest_to_date, NULL);
 > 
 > Or something kind of like that. Yes?

Ok, this builds. I'll run with this for a while, and see what falls out.

thanks,

	Dave

--- linux/kernel/exit.c	2012-03-29 22:45:18.912241586 -0400
+++ linux/kernel/exit.c	2012-04-17 16:29:54.473445787 -0400
@@ -871,7 +871,7 @@
 }
 
 #ifdef CONFIG_DEBUG_STACK_USAGE
-static void check_stack_usage(void)
+static void check_stack_usage(struct task_struct *p)
 {
 	static DEFINE_SPINLOCK(low_water_lock);
 	static int lowest_to_date = THREAD_SIZE;
@@ -888,11 +888,13 @@
 				"left\n",
 				current->comm, free);
 		lowest_to_date = free;
+		if (lowest_to_date < 512)
+			show_trace(NULL, NULL, (long unsigned int *)end_of_stack(p) + lowest_to_date, 0);
 	}
 	spin_unlock(&low_water_lock);
 }
 #else
-static inline void check_stack_usage(void) {}
+static inline void check_stack_usage(struct task_struct *p) {}
 #endif
 
 void do_exit(long code)
@@ -987,7 +989,7 @@
 	exit_shm(tsk);
 	exit_files(tsk);
 	exit_fs(tsk);
-	check_stack_usage();
+	check_stack_usage(tsk);
 	exit_thread();
 
 	/*

