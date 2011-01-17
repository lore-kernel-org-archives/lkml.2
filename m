Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab1AQOiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:38:06 -0500
Received: from smtp.nokia.com ([147.243.1.48]:50921 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab1AQOiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:38:00 -0500
Subject: Bug in scheduler when using rt_mutex
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: mingo@elte.hu, peterz@infradead.org
Cc: "Onkalo Samu.P" <samu.p.onkalo@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Mon, 17 Jan 2011 16:42:45 +0200
Message-ID: <1295275365.12840.13.camel@kolo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi

I believe that there are some problems in the scheduling when
the following happens:
- Normal priority process locks rt_mutex and sleeps while keeping it
locked.
- RT priority process blocks on the rt_mutex while normal priority
process is sleeping

This sequence can occur with I2C access when both normal priority
thread and irq-thread access the same I2C bus. I2C core
contains rt_mutex and I2C drivers can sleep with wait_for_completion.


I have seen following failure to happen (also with 2.6.37):

User process access some device handle or sysfs entry which finally
makes an I2C access. I2C core contains rt_mutex protection against
parallel access. Sometimes when the rt_mutex is unlocked, user process
is not running for a long time (several minutes). This can occur when
there are only small number of user processes running. In my test cases
there was only cat /dev/zero > /dev/null running at the background and
other process was accessing sysfs entry.

Example:

cat /dev/zero > /dev/null &
while [ 1 ] ; do
cat /sys/devices/platform/lis3lv02d/selftest
done

Selftest causes I2C accesses from both user process and irq-thread.

Based on my debugging following sequence occurs (single CPU
system):

1) There is some user process running at the background (like
cat /dev/zero..)
2) User process reads sysfs entry which causes I2C acccess
3) User process locks rt_mutex in the I2C-core
4) User process sleeps while it keeps rt_mutex locked
(wait_for_completion in I2C transfer function)
5) irq-thread is kicked to run
6) irq-thread tries to take rt_mutex which is allready locked by user
process
7) sleeping user process is promoted to irq-thread priority (RT class)
8) user process is woken up by completion mechanism and it finishes its
job
9) user process unlocks rt_mutex and is changed back to old priority and
scheduling class
10) irq-thread continues as expected

User process is stucked to at phase 9. Scheduler may skip that process
for a long time.

Based on my analysis vruntime calculations fails for the user process.
At phase 9, vruntime for that sched_entity is much bigger compared other
processes which leads to situation that it is not scheduled for a long
time.

Problem is that at phase 7) user process is sleeping and the rt_mutex
priority change control is done for the sleeping task. se.vruntime is
not modified and when the user process continues running se.vruntime
contains about twice the cfs_rq.min_runtime value.

Success case:
- user process locks rt_mutex
- irq-thread causes user process to be promoted to RT level while the
user process is in the running and "on_rq == 1" state
-> dequeue_task is called which modifies se.vruntime
dequeue_entity function:

	if (!(flags & DEQUEUE_SLEEP))
		se->vruntime -= cfs_rq->min_vruntime;

When the process is moved back from rt to normal priority enqueue_task
updates vruntime again to correct value:
enqueue_entity:
	if (!(flags & ENQUEUE_WAKEUP) || (flags & ENQUEUE_WAKING))
		se->vruntime += cfs_rq->min_vruntime;


Failure case:
- user process locks rt_mutex
- and goes to sleep (wait_for_completion etc.)
- user process is dequeued to sleep state
-> vruntime is not updated in dequeue_entity

- irq-thread blocks to rt_mutex and user process is promoted to RT
priory
- User process wakes up and continues until it releases rt_mutex
-> User process is moved from rt-queue to cfs queue. WAKEUP / WAKING
flags are not set so vruntime is updated to incorrect value.

I have a simple dummy-driver which demonstrates the case. It is tested
with single CPU embedded system on 2.6.37.
I also have correction proposal, but it is quite possible that there is
better way to do this and it may be that I miss some case totally.
Scheduler is quite complex thing. I'll send patches for the test case
and for the proposal.

Br, Samu Onkalo







