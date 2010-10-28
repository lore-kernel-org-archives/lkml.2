Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536Ab0J1VTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 17:19:40 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21899 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760257Ab0J1VTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 17:19:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6150"; a="59634590"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Colin Cross <ccross@android.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nicolas Pitre <nico@fluxnic.net>
Subject: [PATCHv2 0/3] ARM: Fixing udelay() for SMP and non-SMP systems
Date: Thu, 28 Oct 2010 14:19:27 -0700
Message-Id: <1288300770-18350-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.1.104.gc752e
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

Changes since v1:
 * likely() in delay.c
 * comment fixup for read_current_timer_delay_loop() 
 * cosmetic improvements to commit text

I didn't add any more comments to delay.c's functions since I
couldn't come up with anything worthwhile to say.

-- Reference --
[1] http://article.gmane.org/gmane.linux.kernel/977567
[2] http://article.gmane.org/gmane.linux.ports.arm.kernel/78496 

Stephen Boyd (3):
  ARM: Translate delay.S into (mostly) C
  ARM: Allow machines to override __delay()
  ARM: Implement a timer based __delay() loop

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

