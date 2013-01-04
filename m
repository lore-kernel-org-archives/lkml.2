Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab3ADNBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 08:01:45 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:60836 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3ADNBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 08:01:43 -0500
MIME-Version: 1.0
In-Reply-To: <50E3DE29.6020403@synopsys.com>
References: <1352281674-2186-1-git-send-email-vgupta@synopsys.com>
	<1352281674-2186-16-git-send-email-vgupta@synopsys.com>
	<alpine.LFD.2.02.1211122110230.10000@ionos>
	<50E3DE29.6020403@synopsys.com>
Date: Fri, 4 Jan 2013 14:01:42 +0100
Message-ID: <CAFTL4hz95LF0qetu+tjR3ZyHf0PWKwc40Sx-puJaUdrsSXgvKw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 15/31] ARC: Process/scheduling/clock/Timers/Delay Management
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/2 Vineet Gupta <Vineet.Gupta1@synopsys.com>:
> On Tuesday 13 November 2012 01:59 AM, Thomas Gleixner wrote:
>> On Wed, 7 Nov 2012, Vineet Gupta wrote:
>>> +void cpu_idle(void)
>>> +{
>>> +    /* Since we SLEEP in idle loop, TIF_POLLING_NRFLAG can't be set */
>>> +
>>> +    /* endless idle loop with no priority at all */
>>> +    while (1) {
>>> +            tick_nohz_idle_enter();
>>> +
>>> +            while (!need_resched())
>>> +                    arch_idle();
>>> +
>>> +            tick_nohz_idle_exit();
>>> +
>>> +            preempt_enable_no_resched();
>>> +            schedule();
>>> +            preempt_disable();
>>
>>               schedule_preempt_disabled() please
>
>
> OK ! And it seems I was also missing the calls to rcu_idle_enter()/exit() to track
> commit 1268fbc746ea  "nohz: Remove tick_nohz_idle_enter_norcu() / ..."

Right!

They must be placed around the code that sets the low power mode, when
you know there is no use of RCU between rcu_idle_enter() /
rcu_idle_exit(). Here this would be likely:

while (1) {
        tick_nohz_idle_enter();

+      rcu_idle_enter();
        while (!need_resched())
                arch_idle();
+      rcu_idle_exit()

        tick_nohz_idle_exit();
        schedule_preempt_disabled();
}
