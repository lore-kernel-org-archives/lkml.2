Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab0I1Ddw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 23:33:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31779 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab0I1Ddu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 23:33:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6119"; a="55810524"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 0/3] Fixing udelay() on SMP (and non-SMP too)
Date: Mon, 27 Sep 2010 20:33:44 -0700
Message-Id: <1285644827-6846-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are another attempt at fixing the udelay()
issue pointed out on arm-lkml[1][2]. A quick recap: some SMP
machines can scale their CPU frequencies independent of one
another. loops_per_jiffy is calibrated globally and used in
__const_udelay(). If one CPU is running faster than what the
loops_per_jiffy is calculated (or scaled) for, udelay() will
be incorrect and not wait long enough (or too long). A similar
problem occurs if the cpu frequency is scaled during a udelay()
call.

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

-- Reference --
[1] http://article.gmane.org/gmane.linux.kernel/977567
[2] http://article.gmane.org/gmane.linux.ports.arm.kernel/78496 

Stephen Boyd (3):
  [ARM] Translate delay.S into (mostly) C
  [ARM] Allow machines to override __delay()
  [ARM] Implement a timer based __delay() loop

 arch/arm/include/asm/delay.h |    5 ++-
 arch/arm/kernel/armksyms.c   |    4 --
 arch/arm/lib/delay.S         |   65 ------------------------------
 arch/arm/lib/delay.c         |   90 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 94 insertions(+), 70 deletions(-)
 delete mode 100644 arch/arm/lib/delay.S
 create mode 100644 arch/arm/lib/delay.c

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

