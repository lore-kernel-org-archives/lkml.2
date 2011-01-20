Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1ATUvg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 15:51:36 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:1530 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838Ab1ATUvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 15:51:35 -0500
Message-ID: <4D38A051.2010301@caviumnetworks.com>
Date: Thu, 20 Jan 2011 12:51:29 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: RTC seems broken on 2.6.38-rc1 for RTCs lacking alarms.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2011 20:51:34.0981 (UTC) FILETIME=[D326BF50:01CBB8E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hwclock program on my MIPS Debian GNU/Linux 5.0 system quit
working with 2.6.38-rc1.

This particular ds1307 has no interrupt connection, so the alarm
feature cannot be used.  Because of this the
rtc_class_ops.set_alarm() function always will return -EINVAL


This problem appears to be related to commits:
042620a RTC: Remove UIE emulation
6610e08 RTC: Rework RTC code to use timerqueue for events

My system uses a ds1307 RTC which still works as evidenced by the
kernel boot messages.

.
.
.
rtc-ds1307 0-0068: setting system clock to 2011-01-20 19:58:48 UTC 
(1295553528)
.
.
.

But hwclock now fails here is some nice strace output:
.
.
.
open("/dev/rtc0", O_RDONLY|O_LARGEFILE) = 3
ioctl(3, PRESTO_GETMOUNT or RTC_UIE_ON, 0) = 0
_newselect(4, [3], NULL, NULL, {5, 0})  = 0 (Timeout)
write(2, "select() to /dev/rtc0 to wait for"..., 55select() to /dev/rtc0 
to wait for clock tick timed out
) = 55
ioctl(3, PRESTO_SETPID or RTC_UIE_OFF, 0) = 0
close(3)                                = 0
exit_group(1)                           = ?


The hwclock program is asking to put the clock in UIE mode and then
does a select() on it.  Since the alarm doesn't work, the select times out.

Previously the ioctl(RTC_UIE_ON) would return EINVAL:
.
.
.
open("/dev/rtc0", O_RDONLY|O_LARGEFILE)  = 3
ioctl(3, PRESTO_GETMOUNT or RTC_UIE_ON, 0) = -1 EINVAL (Invalid argument)
ioctl(3, PRESTO_SETOPT or RTC_RD_TIME, {tm_sec=48, tm_min=41, 
tm_hour=20, tm_mday=20, tm_mon=0, tm_year=111, ...}) = 0
ioctl(3, PRESTO_SETOPT or RTC_RD_TIME, {tm_sec=48, tm_min=41, 
tm_hour=20, tm_mday=20, tm_mon=0, tm_year=111, ...}) = 0
.
.
.

The problem seems to be that rtc_update_irq_enable() no longer returns
-EINVAL when it cannot set the alarm.

David Daney
