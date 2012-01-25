Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2AYNSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 08:18:14 -0500
Received: from exprod5og101.obsmtp.com ([64.18.0.141]:49071 "EHLO
	exprod5og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab2AYNSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 08:18:13 -0500
X-Greylist: delayed 17619 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jan 2012 08:18:13 EST
MIME-Version: 1.0
Date: Wed, 25 Jan 2012 16:24:32 +0800
Message-ID: <CAOwKts_Og5CONxvP-1AF4HdCUggN4RYw1D=kW3Xv7PJ216nRDA@mail.gmail.com>
Subject: Softlockup (LOCKUP_DETECTOR) detection issue
From: TAO HU <tghk48@motorola.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

While playing kernel 3.0.8 with below test code, it does NOT report
any softlockup with 60%~70% chances.
NOTE: the softlockup timeout is set to 10 seconds (i.e.
watchdog_thresh=5) in my test.
... ...
preempt_disable();
local_irq_disable();
for (i = 0; i < 20; i++)
       mdelay(1000);
local_irq_enable();
preempt_enable();
... ...

However, if I remove local_irq_disable()/local_irq_enable() it will
report softlockup with no problem.
I believe it is due to that after local_irq_enable()
touch_softlockup_watchdog() is called prior softlockup timer.

touch_softlockup_watchdog() basically resets the lockup detection
process which implies that the 20-second lockup will be ignored.
I noticed that touch_softlockup_watchdog() is called in dozens of
places in kernel.

Is that a design limitation or a bug? Any way to improve the situation?

kernel/debug/debug_core.c:453:	touch_softlockup_watchdog_sync();
kernel/power/hibernate.c:443:	touch_softlockup_watchdog();
kernel/panic.c:153:		touch_softlockup_watchdog();
kernel/time/timekeeping.c:684:	touch_softlockup_watchdog();
kernel/time/tick-sched.c:149:	touch_softlockup_watchdog();
kernel/time/tick-sched.c:543:	touch_softlockup_watchdog();
kernel/time/tick-sched.c:596:		touch_softlockup_watchdog();
kernel/time/tick-sched.c:756:			touch_softlockup_watchdog();
kernel/sched_clock.c:277:	touch_softlockup_watchdog();



-- 
Best Regards
Hu Tao
