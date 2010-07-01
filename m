Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0GAHgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 03:36:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35270 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab0GAHgR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 03:36:17 -0400
Subject: Re: What's the relationship between Linux driver running priority
 and FIFO policy?
From: Peter Zijlstra <peterz@infradead.org>
To: "Zhang, Yongchao (GE Healthcare)" <Yongchao.Zhang@ge.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9BC2BBFFF6E8F04094DB58B805758CE406C039A7@SHAMLVEM01.e2k.ad.ge.com>
References: <9BC2BBFFF6E8F04094DB58B805758CE406C039A7@SHAMLVEM01.e2k.ad.ge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 09:36:14 +0200
Message-ID: <1277969774.1917.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 13:21 +0800, Zhang, Yongchao (GE Healthcare)
wrote:
> Hi
>   I have a question disturb me very much.
>   You know linux FIFO policy is common,and also there are many drivers
> running in system,so
>   which level are these drivers running on? If I have a progrom which
> priority is FIFO99, does it disturb the driver running?
>   I want know which level does drivers running on? For example, driver
> running on FIFOXX? and how does linux schedule on this 
>   case?
>  

Fully depends on what a driver is and what you expect it to. If part of
the driver consists of a (or multiple) kernel thread, and that thread
has lower priority than FIFO99 (very typical) then of course.

If the driver is a pure IRQ driven thingy, then no, since hardirq
context will still preempt any task context.

Of course, if whatever proglet is talking to the driver is running at a
lower priority, that will get starved and your driver might again not
make any progress because all its queues are filled (incomming) or empty
(outgoing).

In general having a FIFO99 task around that consumes unbounded amounts
of cpu time is not something that is healthy for the system and it not
something I can recommend.

The Real-Time classes (FIFO/RR) are designed for deterministic programs
with bounded runtime. Things like spinning in userspace are very bad for
a number of reasons (which nevertheless doesn't seem to stop people from
doing just that).

The only answer that I can give you is: don't do that.

As to how Linux schedules, the scheduler is concerned only with tasks;
it will run the highest priority FIFO/RR task available, if there are no
FIFO/RR tasks present it will run SCHED_OTHER tasks, for those it will
divide the remaining time fairly based on their nice value (which is
mapped to a weight).

Interrupts -- at a hardware level -- interrupt task context and are thus
always ran whenever they happen.

That's all, there's really nothing more to it.
