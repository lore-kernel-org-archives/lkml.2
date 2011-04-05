Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab1DEX4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 19:56:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33983 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1DEX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 19:56:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6307"; a="83965972"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mattias Wallin <Mattias.Wallin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCHv5 0/3] Constant udelay() for SMP and non-SMP systems
Date: Tue,  5 Apr 2011 16:56:37 -0700
Message-Id: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.rc0.131.gfa38c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: I will submit this to the patch tracker in 48 hours.
Tested by are appreciated.

These patches fix the udelay() issue pointed out on
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
is unchanged.  Option 2 cannot fail since the __delay() loop is
repointed after memory is mapped in, but it suffers from a low
BogoMIPS when timers are clocked slowly. It also more accurately
calculates the timer tick frequency through the use of
calibrate_delay_direct().

-- Reference --
[1] http://article.gmane.org/gmane.linux.kernel/977567
[2] http://article.gmane.org/gmane.linux.ports.arm.kernel/78496 

Changes since v4:
 * Rebased against changes to udelay.S

Changes since v3:
 * Inlined set_delay_fn()

Changes since v2:
 * Additional patch using the timer based delay

Changes since v1:
 * likely() in delay.c
 * comment fixup for read_current_timer_delay_loop()
 * cosmetic improvements to commit text

Stephen Boyd (3):
  ARM: Translate delay.S into (mostly) C
  ARM: Allow machines to override __delay()
  ARM: Implement a timer based __delay() loop

 arch/arm/include/asm/delay.h |   11 +++++-
 arch/arm/kernel/armksyms.c   |    4 --
 arch/arm/lib/delay.S         |   69 ---------------------------------
 arch/arm/lib/delay.c         |   87 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 97 insertions(+), 74 deletions(-)
 delete mode 100644 arch/arm/lib/delay.S
 create mode 100644 arch/arm/lib/delay.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

