Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806Ab0KHW6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:58:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:23351 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab0KHW6J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:58:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,171,1288594800"; 
   d="scan'208";a="571497119"
Message-ID: <4CD8807E.90306@linux.intel.com>
Date: Mon, 08 Nov 2010 14:58:06 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
CC: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "lkml, " <linux-kernel@vger.kernel.org>
Subject: futex requeue_pi breakage
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven,

As we've discussed, the following changes break the futex_requeue_pi 
testcase I use to validate the futex_requeue_pi feature introduced in 
2.6.32(ish).

	commit 43fa5460fe60dea5c610490a1d263415419c60f6
	    sched: Try not to migrate higher priority RT tasks

	commit b3bc211cfe7d5fe94b310480d78e00bea96fbf2a
	    sched: Give CPU bound RT tasks preference

The source to this test is here:

http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git;a=summary
branch: futex-lock
file: futextest/functional/futex_requeue_pi.c

The futex_requeue_pi test main loop runs as sched_other while all the 
child threads are spawned as sched_fifo 1. This scenario results in the 
parent thread spinning in futex_wait_queue_me (most likely on the hash 
bucket spinlock) while attempting a pthread_join() on the rt child 
threads. However, if I run with chrt, forcing the parent thread to fifo 
1, it completes reliably:

$ sudo chrt -f 1 ./futex_requeue_pi
futex_requeue_pi: Test requeue functionality
         Arguments: broadcast=0 locked=0 owner=0 timeout=0ns
Result:  PASS

Whereas as sched_other:
$ sudo ./futex_requeue_pi
futex_requeue_pi: Test requeue functionality
         Arguments: broadcast=0 locked=0 owner=0 timeout=0ns
<hang>

$ ps -eLo tid,rtprio,wchan:20,comm | grep futex
  1987      - futex_wait_queue_me  auditd
  1988      - futex_wait_queue_me  audispd
  5533      - futex_wait_queue_me  rsyslogd
  5547      - futex_wait_queue_me  futex_requeue_p
  5549      1 futex_wait_queue_me  futex_requeue_p
  5550      1 futex_wait_queue_me  futex_requeue_p
  5551      1 futex_wait_queue_me  futex_requeue_p
  5552      1 futex_wait_queue_me  futex_requeue_p
  5553      1 futex_wait_queue_me  futex_requeue_p
  5554      1 futex_wait_queue_me  futex_requeue_p
  5555      1 futex_wait_queue_me  futex_requeue_p
  5556      1 futex_wait_queue_me  futex_requeue_p
  5557      1 futex_wait_queue_me  futex_requeue_p
  5558      1 ?                    futex_requeue_p
  5559      1 ?                    futex_requeue_p

I'm still thinking through how your changes would impact this, and if 
there could be some assumption in the futex code that fails with those 
changes. I wanted to get the information out there in case it triggers 
any insight from you.

This suggests that somehow an rt task blocked while holding a spinlock 
(without issuing a warning to the console) or that somehow a SCHED_OTHER 
task preempted an RT task which is not getting scheduled on another CPU. 
Neither of these seem likely.

Thanks,

-- 
Darren Hart
Embedded Linux Kernel
