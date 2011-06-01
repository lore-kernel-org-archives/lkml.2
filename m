Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab1FAUvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 16:51:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35090 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758957Ab1FAUvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 16:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=GMasOgAWqVZMahd15u2Q2r/vQgn3gxi7yGfOBOgJLmKgnFb2/23CXmRqhTG0ws6Om5
         ysJcSCAEX0AvfS7/F4ZQ==
MIME-Version: 1.0
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 1 Jun 2011 14:50:52 -0600
Message-ID: <BANLkTiniq6GVMJPO_-efKrWHQg9V9Dod9g@mail.gmail.com>
Subject: /proc/stat btime accuracy problem
To: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

timekeeping_init() basically does the following:

    xtime = RTC
    if (arch implements read_boot_clock())
        wall_to_monotonic = -read_boot_clock()
    else
      wall_to_monotonic = -xtime

So wall_to_monotonic records some approximation of the system boot
time, which is then used to derive the "btime" reported in /proc/stat.

The problem I'm seeing is that xtime is updated on timer ticks, so
uninterruptible code, like kernel serial printk, makes us miss ticks,
so xtime falls behind the RTC.  Then, when userland fixes xtime, in my
case with "hwclock --hctosys", the delta is applied to both xtime and
wall_to_monotonic.  The result is that "btime" is no longer accurate.

Here's an example where I artificially exaggerated the problem by
adding 30 seconds of wait time with interrupts disabled.  Assume the
RTC is perfectly correct at boot, and note that xtime has fallen
behind the RTC by 31 seconds by the time userland resets the clock:

  rtc 1306957603 xtime 1306957603 wall_to_monotonic -1306957603  in
timekeeping_init()
  rtc 1306957638 xtime 1306957607 wall_to_monotonic -1306957603
before do_settimeofday()
  rtc 1306957638 xtime 1306957638 wall_to_monotonic -1306957634  after
do_settimeofday()

Now /proc/stat btime reports 1306957634 instead of the correct 1306957603.

Bjorn
