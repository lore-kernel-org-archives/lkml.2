Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0LQAuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 19:50:13 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12572 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab0LQAuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 19:50:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6199"; a="66953205"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>,
        Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>,
        Saravana Kannan <skannan@codeaurora.org>
Subject: [PATCH 00/22] MSM clock driver updates
Date: Thu, 16 Dec 2010 16:49:44 -0800
Message-Id: <1292547006-19741-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches syncs the MSM clock code in Linus' tree with 
the MSM tree @ codeaurora.org. They're prepared against the msm-core
tree (git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-core).

 * 1 - 4 are cleanups and minor additions to the existing clock driver

 * 5 - 6 add support for the 7x30 local clock driver

 * 7 - 10 add support for the 8x60 local clock driver; refactor the
          7x30 driver into a generic driver and remove the dummy clock
	  driver in use by 8x60

 * 11 - 12 add debugfs aides for locally controlled clocks

 * 13 - 17 implement clock rate voting for clocks with multiple
           consumers where each consumer requires different minimum rates

 * 18 moves the clock driver to clkdev

 * 19 - 22 moves the iommu driver to proper usage of the clock driver

I understand the diffstat is rather large, but please review. All feedback
is welcome.

Matt Wagantall (5):
  msm: clock: Move debugfs code from clock.c to clock-debug.c
  msm: clock: Refactor clock-7x30 into generic clock-local driver
  msm: clock-8x60: Add msm8x60 local clock driver
  msm: clock Add debugfs interface to measure clock rates
  msm: clock: Add list_rate debugfs nodes for locally-controlled clocks

Saravana Kannan (1):
  msm: clock-7x30: Add 7x30 local clock driver

Stepan Moskovchenko (3):
  msm: iommu: Add bus clocks to platform data
  msm: iommu: Clock control for the IOMMU driver
  msm: iommu: Rework clock logic and add IOMMU bus clock control

Stephen Boyd (13):
  msm: clock: Remove unused code and definitions
  msm: clock: Invert debugfs directory layout
  msm: clock: Add support for more proc_comm clocks
  msm: clock-7x30: Update clock table
  msm: clock: Remove references to clk_ops_pcom
  msm: Move 8x60 to the real clock driver
  msm: clock: Push down clock count and locking into sub drivers
  msm: clock: Support clk_set_parent() clk_ops
  msm: clock-pcom: Add pbus specific clock ops
  msm: clock: Implement rate voting
  msm: Migrate to clock rate voting
  msm: clock: Migrate to clkdev
  msm: clock-8x60: Don't keep IOMMU clocks on at boot

 arch/arm/Kconfig                                |    1 +
 arch/arm/mach-msm/Makefile                      |   10 +-
 arch/arm/mach-msm/board-msm8x60.c               |    8 +-
 arch/arm/mach-msm/clock-7x30.c                  | 1166 ++++++++++++++
 arch/arm/mach-msm/clock-7x30.h                  |  265 ++--
 arch/arm/mach-msm/clock-8x60.c                  | 1896 +++++++++++++++++++++++
 arch/arm/mach-msm/clock-8x60.h                  |  218 +++
 arch/arm/mach-msm/clock-debug.c                 |  176 +++
 arch/arm/mach-msm/clock-local.c                 |  696 +++++++++
 arch/arm/mach-msm/clock-local.h                 |  233 +++
 arch/arm/mach-msm/clock-pcom.c                  |  102 ++-
 arch/arm/mach-msm/clock-pcom.h                  |   21 +-
 arch/arm/mach-msm/clock-voter.c                 |  202 +++
 arch/arm/mach-msm/clock-voter.h                 |   54 +
 arch/arm/mach-msm/clock.c                       |  244 +---
 arch/arm/mach-msm/clock.h                       |   70 +-
 arch/arm/mach-msm/devices-msm7x00.c             |   32 +-
 arch/arm/mach-msm/devices-msm7x30.c             |  170 ++-
 arch/arm/mach-msm/devices-msm8x60-iommu.c       |    5 -
 arch/arm/mach-msm/devices-msm8x60.c             |  183 +++
 arch/arm/mach-msm/devices-qsd8x50.c             |   29 +-
 arch/arm/mach-msm/devices.h                     |    9 +-
 arch/arm/mach-msm/include/mach/board.h          |    4 +-
 arch/arm/mach-msm/include/mach/clkdev.h         |   23 +
 arch/arm/mach-msm/include/mach/iommu.h          |   12 +-
 arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |   12 +
 arch/arm/mach-msm/io.c                          |    3 +
 arch/arm/mach-msm/iommu.c                       |   57 +-
 arch/arm/mach-msm/iommu_dev.c                   |  204 ++-
 arch/arm/mach-msm/proc_comm.h                   |    1 +
 30 files changed, 5524 insertions(+), 582 deletions(-)
 create mode 100644 arch/arm/mach-msm/clock-7x30.c
 create mode 100644 arch/arm/mach-msm/clock-8x60.c
 create mode 100644 arch/arm/mach-msm/clock-8x60.h
 create mode 100644 arch/arm/mach-msm/clock-debug.c
 create mode 100644 arch/arm/mach-msm/clock-local.c
 create mode 100644 arch/arm/mach-msm/clock-local.h
 create mode 100644 arch/arm/mach-msm/clock-voter.c
 create mode 100644 arch/arm/mach-msm/clock-voter.h
 create mode 100644 arch/arm/mach-msm/devices-msm8x60.c
 create mode 100644 arch/arm/mach-msm/include/mach/clkdev.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

