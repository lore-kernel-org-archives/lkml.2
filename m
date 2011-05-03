Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab1ECQEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 12:04:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35131 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1ECQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 12:04:41 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6334"; a="89052758"
From: David Collins <collinsd@codeaurora.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>
Subject: [PATCH v2 0/2] regulator: msm: Add PM8921 regulator driver
Date: Tue,  3 May 2011 09:04:28 -0700
Message-Id: <1304438668-23680-1-git-send-email-collinsd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds a new regulator driver to control the regulators in
Qualcomm PM8921 PMIC chips.  It also introduces board file changes to use
this new driver with the Qualcomm MSM 8960 platform.

This patch set depends upon the following outstanding PM8XXX and PM8921
patches:

https://patchwork.kernel.org/patch/688832/
https://patchwork.kernel.org/patch/688882/
https://patchwork.kernel.org/patch/735362/
https://patchwork.kernel.org/patch/735372/
https://patchwork.kernel.org/patch/688842/

Updates from V1:
Major modifications were made based on Mark Brown's suggestions.

Major changes:
 1. A set of semi-virtual regulators were added to support pin-control.
 2. The set_mode callbacks were modified so that they act normal and do not
    control pin-control.
 3. Changed set_voltage callbacks to round up min_uV to the next available set
    point and to bail out if that set point is greater than max_uV.
 4. Added list_voltage callbacks.
 5. Enable and disable callbacks were separated out per regualtor type to
    handle differing requirements for pin controllable regulators.

Minor changes:
 1. Moved kfree of regulator mfd_cells to the PMIC core remove function.
 2. Simplified handling of unknown voltages in regulators in which enable state
    and output voltage are set using the same bits.
 3. Made symbol names more consistent.
 4. Modified how overlapping voltage ranges are handled to ensure most
    efficient operation.
 5. Corrected names used for PMIC 8921 pin control inputs.
 6. Removed unused member: struct pm8921_vreg.state
 7. Renamed pm8921_vreg_write to pm8921_vreg_masked_write to better illustrate
    its functionality.
 8. Added pm8921_vreg_masked_write_forced to handle registers that must be
    overwritten even if their value is unchanged in order for hardware to
    change state.
 9. Mutex locking was added for all callback functions which touch pin
    controllable regulators because the regulator framework will have no way
    of knowing that two separate regualtor_dev's modify the same physical
    regulators.
10. Debug/error messages were moved so that they do not span multiple lines.
11. pm8921_init_regulator was removed and the switch statement in it was moved
    into pm8921_vreg_probe.
12. pm8921_vreg_init was changed from module_init to subsys_init.
13. Comments were added describing the enums and structs in pm8921-regulator.h.
14. system_uA platform data was added to quantify the max current draw 
    intrinsic to a system that is not associated with any consumer.
15. Changed NULL to "reg-debug-consumer" in the board file.
16. Remove pin-control column in board file for normal regulator constraints.

David Collins (2):
  regulator: pm8921-regulator: Add regulator driver for PM8921
  msm: board-8960: Add support for pm8921-regulator

 arch/arm/mach-msm/Makefile                  |    1 +
 arch/arm/mach-msm/board-msm8960-regulator.c |  306 +++
 arch/arm/mach-msm/board-msm8960.c           |    4 +
 arch/arm/mach-msm/board-msm8960.h           |   23 +
 drivers/mfd/pm8921-core.c                   |   34 +
 drivers/regulator/Kconfig                   |   10 +
 drivers/regulator/Makefile                  |    1 +
 drivers/regulator/pm8921-regulator.c        | 3025 +++++++++++++++++++++++++++
 include/linux/mfd/pm8xxx/pm8921.h           |    3 +
 include/linux/regulator/pm8921-regulator.h  |  155 ++
 10 files changed, 3562 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-msm/board-msm8960-regulator.c
 create mode 100644 arch/arm/mach-msm/board-msm8960.h
 create mode 100644 drivers/regulator/pm8921-regulator.c
 create mode 100644 include/linux/regulator/pm8921-regulator.h

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

