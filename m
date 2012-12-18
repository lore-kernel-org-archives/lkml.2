Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab2LRMHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:07:14 -0500
Received: from service87.mimecast.com ([91.220.42.44]:37148 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2LRMHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:07:12 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, nico@linaro.org, will.deacon@arm.com,
        marc.zyngier@arm.com, john.stultz@linaro.org,
        Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 0/5] clockevents: decouple broadcast mechanism from drivers
Date: Tue, 18 Dec 2012 12:06:53 +0000
Message-Id: <1355832418-31692-1-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 18 Dec 2012 12:07:07.0844 (UTC) FILETIME=[339C3040:01CDDD18]
X-MC-Unique: 112121812070924901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qBIC7Kef018301

In some SMP systems, cpu-local timers may stop delivering interrupts
when in low power states, or not all CPUs may have local timers. To
support these systems we have a mechanism for broadcasting timer ticks
to other CPUs. This mechanism relies on the struct
clock_event_device::broadcast function pointer, which is a
driver-specific mechanism for broadcasting ticks to other CPUs.

As the broadcast mechanism is architecture-specific, placing the
broadcast function on struct clock_event_device ties each driver to a
single architecture. Additionally the driver or architecture backend
must handle the routing of broadcast ticks to the correct
clock_event_device, leading to duplication of the list of active
clock_event_devices.

These patches introduce a generic mechanism for handling the receipt of
timer broadcasts, and an optional architecture-specific broadcast
function which allows drivers to be decoupled from a particular
architecture will retaining support for timer tick broadcasts. These
mechanisms are wired up for the arm port, and have been boot-tested on a
pandaboard.

Thanks,
Mark.

Mark Rutland (5):
  ARM: remove useless guard in smp.c
  clockevents: Add generic timer broadcast receiver
  ARM: Use generic timer broadcast receive
  clockevents: Add generic timer broadcast function
  ARM: Add generic timer broadcast support

 arch/arm/Kconfig             |    1 +
 arch/arm/kernel/smp.c        |   15 ++-------------
 include/linux/clockchips.h   |    9 +++++++++
 kernel/time/Kconfig          |    4 ++++
 kernel/time/tick-broadcast.c |   30 ++++++++++++++++++++++++++++++
 5 files changed, 46 insertions(+), 13 deletions(-)


