Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676Ab2FAFUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 01:20:05 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55965 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568Ab2FAFUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 01:20:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1205311834270.3231@ionos>
References: <CAH3Oq6SHLWvcdVUFsmPvqNedBC_QQhVSxrvCiyAUL3TgPQn3wQ@mail.gmail.com>
	<alpine.LFD.2.02.1205311834270.3231@ionos>
Date: Fri, 1 Jun 2012 13:20:02 +0800
Message-ID: <CAH3Oq6QxFmtTuZSdF=95FPugwu1AzMgHm650qmNUwsdLr9O8Rg@mail.gmail.com>
Subject: Re: Make kstat_incr_irqs_this_cpu() called when an irq is actually
 being handled
From: Ning Jiang <ning.n.jiang@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/1 Thomas Gleixner <tglx@linutronix.de>:
> On Thu, 31 May 2012, Ning Jiang wrote:
>> kstat_incr_irqs_this_cpu() is supposed to record the irq number
>> that is actually taken by a certain cpu. But it failed to do so
>> in its current form.
>
> It exactly counts the number of interrupts which are delivered to and
> handled by a CPU. That includes interrupts which are delivered in a
> state where the device handler cannot be called. And this is on
> purpose. We want to see the real number of interruptions not the
> number of calls to a device handler.
>
>> For level irq, if its disabled or no action available, we'll skip
>> irq handling. When it is enabled later, the irq will be retriggered
>> and kstat_incr_irqs_this_cpu() will be counted twice for this
>> single irq.
>
> This counts the number of interrupts arrived at the CPU and therefor
> it counts TWO in this situation. The CPU is interrupted twice, not
> once.
>

I've got your point. For level irq, no problem. But how do you account
for edge irq in my comments?

For edge irq, we'll not have the same problem as level irq because
kstat_incr_irqs_this_cpu() is placed after status checking for
disable or no action. But it has its own problem. Suppose a second
irq happens when the first is being handled, it will mark itself
pending and quit, then it will be handled in the same loop after the
first one has been handled. Thus kstat_incr_irqs_this_cpu() will
only be counted once for two irqs.
