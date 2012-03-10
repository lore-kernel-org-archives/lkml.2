Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab2CJXLy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 18:11:54 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:42074 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752522Ab2CJXLx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 18:11:53 -0500
X-Authenticated: #5086196
X-Provags-ID: V01U2FsdGVkX18cPI4J93QceExnEldKmI1QLlC19rTSiEZTntmJ5s
	tGgdY0edhXu+pV
From: Fawzi Mohamed <fawzi@gmx.ch>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: bug in thread_group_times (+possible patch)
Date: Sun, 11 Mar 2012 00:11:56 +0100
Message-Id: <2C80D678-F219-4B4E-A7FB-D0F890ECC7DD@gmx.ch>
Cc: Thomas Dargel <td@chemie.hu-berlin.de>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1251.1)
X-Mailer: Apple Mail (2.1251.1)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a friend of mine asked me about a kernel crash that he was having on a linux cluster (always after long compute intensive task).
I found the bug causing it, and patched it (in an imperfect way), and as I have seen that in the current git the bug is still there, I am writing it here.
I am not into kernel development, so I did not subscribe to the list, please CC me if you want me to answer.
Sorry if this is not the correct way, but I hope this might help to squash just another little bug.

Now the bug is in kernel/sched/core.c in thread_group_times which if CONFIG_VIRT_CPU_ACCOUNTING is not defined looks like this

void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
{
        struct signal_struct *sig = p->signal;
        struct task_cputime cputime;
        cputime_t rtime, utime, total;

        thread_group_cputime(p, &cputime);

        total = cputime.utime + cputime.stime;
        rtime = nsecs_to_cputime(cputime.sum_exec_runtime);

        if (total) {
                u64 temp = (__force u64) rtime;

                temp *= (__force u64) cputime.utime;
                do_div(temp, (__force u32) total);
                utime = (__force cputime_t) temp;
        } else
                utime = rtime;

        sig->prev_utime = max(sig->prev_utime, utime);
        sig->prev_stime = max(sig->prev_stime, rtime - sig->prev_utime);

        *ut = sig->prev_utime;
        *st = sig->prev_stime;
}

as already noted in 2005 http://lkml.indiana.edu/hypermail/linux/kernel/0503.2/0414.html using do_div with 64bit base is not correct

The solution in the current source seems to simply cast total to 32 bit, but this is done only in do_div, not in the if, so there is the possibility of crashes if total !=0 but (__force u32) total == 0.
Indeed in a 64 bit kernel where cputime_t is 64 bit the code above crashes.

A quick and dirty fix (the one I did) is

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b342f57..6bbc431 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2967,6 +2967,10 @@ void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *st)
                u64 temp = (__force u64) rtime;
 
                temp *= (__force u64) cputime.utime;
+               if (total > 0xFFFF_FFFF) {
+                   temp = (temp >> 32);
+                   total = (total >> 32);
+               }
                do_div(temp, (__force u32) total);
                utime = (__force cputime_t) temp;
        } else
-------------------

which looses precision, but maintains the intent of the original code when total is large.

I find very bad to crash in routine that collect statistics (even if relevant for scheduling).
Well actually any crash in the kernel is kind of bad :).

Anyway I hope this will be fixed, and thanks for making linux what it is.

PS I guess my contribution is below the obviousness threshold, and I suppose one could implement a better workaround, but anyway I hereby clarify that I give my code snippet away with GPL or whatever else license is required.

ciao
Fawzi