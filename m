Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab0C3QFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:05:13 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1067 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab0C3QFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:05:11 -0400
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Mar 2010 12:05:11 EDT
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Tue, 30 Mar 2010 09:00:09 -0700
From: Gary King <GKing@nvidia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, Gary King <GKing@nvidia.com>
Date: Tue, 30 Mar 2010 08:58:47 -0700
Subject: Bug in hrtimer_get_next_event?
Thread-Topic: Bug in hrtimer_get_next_event?
Thread-Index: AQHK0CHhkHdtz3LvQ0q0XgrtfZaTog==
Message-ID: <A0A1E7539300DF49AA383E614C7827BC04930A0DBB@HQMAIL01.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am implementing idle state controls (CPU_IDLE) for Tegra SoCs, and one of the idle states is not awakened by the hrtimer interrupt. There is a system-wide high-resolution timer which can be used as a wakeup source, but I need the high-resolution sleep time to configure the alarm.

To fix this, I want to use hrtimer_get_next_event; however, the code that is in the tree only walks the hrtimer bases when hres mode is not active; when hres mode is active, hrtimer_get_next_event always returns KTIME_MAX. Is there any reason for the negative comparison, or is this a bug?

After changing this locally, I encountered one other problem on dynamic-tick systems: get_next_timer_interrupt is called to determine whether or not it is safe to enter nohz mode; however, hrtimer_get_next_event (which is used by get_next_timer_interrupt) will always return <=1 jiffy, since the emulated tick scheduler event will be armed when tick_nohz_stop_sched_tick queries the sleep time. As a result, tick_nohz_stop_sched_tick will never enter nohz mode.  I can think of a couple ways to address this (cancel the tick timer before querying the event and rearm if necessary from either the arch cpu_idle code or nohz_stop_sched_tick; ignore the tick timer in hrtimer_get_next_event); does anyone have a recommendation for a preferred approach?

- Gary
gking@nvidia.com
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
