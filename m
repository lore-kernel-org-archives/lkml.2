Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab2DZMLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 08:11:47 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:51827 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2DZMLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 08:11:46 -0400
From: Richard Cochran <richardcochran@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/1] ntp bug fix
Date: Thu, 26 Apr 2012 14:11:31 +0200
Message-Id: <cover.1335442155.git.richardcochran@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been cooking up a patch series to keep the core time in TAI
instead of UTC. In the course of that work I noticed a bug in the
current NTP code. During a leap second insertion, the kernel will
advertise the wrong TAI offset.

There is a nice explanation of this issue in the NIST leap second
list, which I quote below. With reference to that, the Linux kernel
handles the UTC time value like in the first case, but sets the TAI
offset as in the second case, resulting in a discontinuity in the
apparent TAI time.

* Excerpt from ftp://time.nist.gov/pub/leap-seconds.list

   If your system keeps time as the number of seconds since some epoch
   (e.g., NTP timestamps), then the algorithm for assigning a UTC time
   stamp to an event that happens during a positive leap second is not
   well defined. The official name of that leap second is 23:59:60,
   but there is no way of representing that time in these systems.

   Many systems of this type effectively stop the system clock for one
   second during the leap second and use a time that is equivalent to
   23:59:59 UTC twice. For these systems, the corresponding TAI
   timestamp would be obtained by advancing to the next entry in the
   following table when the time equivalent to 23:59:59 UTC is used
   for the second time. Thus the leap second which occurred on 30 June
   1972 at 23:59:59 UTC would have TAI timestamps computed as follows:

   30 June 1972 23:59:59 (2287785599, first time):  TAI= UTC + 10 seconds
   30 June 1972 23:59:60 (2287785599,second time):  TAI= UTC + 11 seconds
   1  July 1972 00:00:00 (2287785600)               TAI= UTC + 11 seconds

   If your system realizes the leap second by repeating 00:00:00 UTC
   twice (this is possible but not usual), then the advance to the
   next entry in the table must occur the second time that a time
   equivlent to 00:00:00 UTC is used. Thus, using the same example as
   above:

   30 June 1972 23:59:59 (2287785599):              TAI= UTC + 10 seconds
   30 June 1972 23:59:60 (2287785600, first time):  TAI= UTC + 10 seconds
   1  July 1972 00:00:00 (2287785600,second time):  TAI= UTC + 11 seconds

   in both cases the use of timestamps based on TAI produces a smooth
   time scale with no discontinuity in the time interval.


Richard Cochran (1):
  ntp: advertise correct TAI offset during leap second

 kernel/time/ntp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

-- 
1.7.2.5

