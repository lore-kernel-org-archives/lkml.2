Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862Ab2EPCdm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 22:33:42 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47039 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2EPCdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 22:33:40 -0400
From: Robert Lee <rob.lee@linaro.org>
To: kernel@pengutronix.de
Cc: shawn.guo@linaro.org, u.kleine-koenig@pengutronix.de,
        richard.zhao@freescale.com, amit.kucheria@linaro.org,
        daniel.lezcano@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, jj@chaosbits.net
Subject: [PATCH v4 0/7] cleanup imx5 idle, add imx5/6 cpuidle
Date: Tue, 15 May 2012 21:33:29 -0500
Message-Id: <1337135616-8988-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup up imx5 idle code and enable imx5 low powe idle for imx53.

Add common imx cpuidle initialization functionality and add a i.MX5 and i.MX6Q
platform cpuidle implementation.

Based on v3.4-rc7 plus recently submitted/accepted MACHINE_INIT late_initcall
 patch: http://www.spinics.net/lists/arm-kernel/msg171620.html

v4 changes:
 * Added several imx5 idle cleanups to series.
 * Modified imx_io_p2v function to allow common imx5 AIPS2 bus virutal address
 * Added comment to tzic_wakeup_enable().
 * Movied imx5 idle code from mm-imx5.c to pm-imx5.c.
 * Removed unnecessary time consuming code execution that ran on each idle
   instance.
 * modified imx5_pm_init to be a late_initcall
 * added late_initcall to all imx53 MACHINE_START entries.
 * enabled imx5 low power idle for imx53
 * rebased cpuidle driver on top of imx5 cleanup changes.
 * modified cpuidle driver exit time to reflect removal of unnecessary code
   

v3 changes:
 * removed file introduced in v1 no longer needed after v2 [per Shawn Guo]
 * re-ordered added #includes in alphabetical order [per Shawn Guo]
 * Remove if(!drv) check to allow handling by stack trace [per Sascha Hauer]
 * Added missing return value in error meesage [per Shawn Guo]
 * fixed (void *) casting problem pointed out Sasha Hauer.  Used a different
   type of casting to properly give warning on improper casting:
   	arm_pm_idle = (void (*)(void))imx5_idle;
   Used this casting instead of adding a dummy caller function because
   adding the dummy function appears to unnecessarily introduce the following
   additional operations:
	static void imx5_pm_idle(void)
	{
	  a0:	e1a0c00d 	mov	ip, sp
	  a4:	e92dd800 	push	{fp, ip, lr, pc}
	  a8:	e24cb004 	sub	fp, ip, #4
		imx5_idle();
	  ac:	ebffffd3 	bl	0 <imx5_idle>
	}
	  b0:	e89da800 	ldm	sp, {fp, sp, pc}

http://permalink.gmane.org/gmane.linux.linaro.devel/11653

v2 changes:
 * Removed some unnecessary  spaces [per Jess Juhl]
 * Added return value for an error message [per Sascha Hauer]
 * Reworked init scheme to use device tree late_initcall [per Sascha and Shawn]
 * Moved imx6q and imx5 cpuidle functionality to existing files.

https://lkml.org/lkml/2012/5/1/363

v1 initial submission:

https://lkml.org/lkml/2012/4/16/644

Robert Lee (7):
  ARM: imx: Modify IMX_IO_P2V macro
  ARM: imx: Add comments to tzic_enable_waker()
  ARM: imx: clean and consolidate imx5 suspend and idle code
  ARM: imx: Enable imx53 low power idle
  ARM: imx: Add common imx cpuidle init functionality.
  ARM: imx: Add imx5 cpuidle
  ARM: imx: Add imx6q cpuidle driver

 arch/arm/mach-imx/clock-mx51-mx53.c       |    1 +
 arch/arm/mach-imx/imx53-dt.c              |    1 +
 arch/arm/mach-imx/mach-imx6q.c            |   19 ++++++
 arch/arm/mach-imx/mach-mx53_ard.c         |    1 +
 arch/arm/mach-imx/mach-mx53_evk.c         |    1 +
 arch/arm/mach-imx/mach-mx53_loco.c        |    1 +
 arch/arm/mach-imx/mach-mx53_smd.c         |    1 +
 arch/arm/mach-imx/mm-imx5.c               |   25 ++-----
 arch/arm/mach-imx/pm-imx5.c               |  103 +++++++++++++++++++++--------
 arch/arm/plat-mxc/Makefile                |    1 +
 arch/arm/plat-mxc/cpuidle.c               |   80 ++++++++++++++++++++++
 arch/arm/plat-mxc/include/mach/common.h   |    4 +-
 arch/arm/plat-mxc/include/mach/cpuidle.h  |   22 ++++++
 arch/arm/plat-mxc/include/mach/hardware.h |   25 ++++---
 arch/arm/plat-mxc/tzic.c                  |    4 ++
 15 files changed, 231 insertions(+), 58 deletions(-)
 create mode 100644 arch/arm/plat-mxc/cpuidle.c
 create mode 100644 arch/arm/plat-mxc/include/mach/cpuidle.h

-- 
1.7.10

