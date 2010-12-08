Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab0LHEi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 23:38:56 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12999 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0LHEiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 23:38:55 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6190"; a="65700303"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        John Stultz <johnstul@us.ibm.com>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>
Subject: [PATCHv3 0/4] ARM: Fixing udelay() for SMP and non-SMP systems
Date: Tue,  7 Dec 2010 20:38:44 -0800
Message-Id: <1291783128-27520-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches fixing the udelay() issue pointed out on
arm-lkml[1][2]. A quick recap: some SMP machines can scale
their CPU frequencies independent of one another. loops_per_jiffy
is calibrated globally and used in __const_udelay(). If one CPU
is running faster than what the loops_per_jiffy is calculated
(or scaled) for, udelay() will be incorrect and not wait long
enough (or too long). A similar problem occurs if the cpu
frequency is scaled during a udelay() call.

We could fix this issue a couple ways, wholesale replacement
of __udelay() and __const_udelay() (see [2] for that approach),
or replacement of __delay() (this series). Option 1 can fail if
anybody uses udelay() before memory is mapped and also duplicates
most of the code in asm/delay.h. It also needs to hardcode the
timer tick frequency, which can sometimes be inaccurate. The
benefit is that loops_per_jiffy stays the same and thus BogoMIPS
is unchanged.  Option 2 can't fail since the __delay() loop is
replaced after memory is mapped in, but it suffers from a low
BogoMIPS when timers are clocked slowly. It also more accurately
calculates the timer tick frequency through the use of
calibrate_delay_direct().

Russell, I'm planning on submitting these to the patch queue
unless I hear objections.

Changes since v2:
 * Additional patch using the timer based delay

Changes since v1:
 * likely() in delay.c
 * comment fixup for read_current_timer_delay_loop()
 * cosmetic improvements to commit text

Stephen Boyd (4):
  ARM: Translate delay.S into (mostly) C
  ARM: Allow machines to override __delay()
  ARM: Implement a timer based __delay() loop
  msm: timer: Migrate to timer based __delay()

 arch/arm/include/asm/delay.h           |    5 ++-
 arch/arm/kernel/armksyms.c             |    4 --
 arch/arm/lib/delay.S                   |   65 ------------------------
 arch/arm/lib/delay.c                   |   86 ++++++++++++++++++++++++++++++++
 arch/arm/mach-msm/include/mach/timex.h |    1 +
 arch/arm/mach-msm/timer.c              |   16 ++++++-
 6 files changed, 106 insertions(+), 71 deletions(-)
 delete mode 100644 arch/arm/lib/delay.S
 create mode 100644 arch/arm/lib/delay.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

