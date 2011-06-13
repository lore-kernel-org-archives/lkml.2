Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1FMAoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 20:44:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:26228 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab1FMAoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 20:44:17 -0400
From: Colin Cross <ccross@android.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>
Subject: [PATCH 0/3] CPU PM notifiers
Date: Sun, 12 Jun 2011 17:43:42 -0700
Message-Id: <1307925825-28566-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set tries to address Russell's concerns with platform
pm code calling into the driver for every block in the Cortex A9s
during idle, hotplug, and suspend.  The first patch adds cpu pm
notifiers that can be called by platform code, the second uses
the notifier to save and restore the GIC state, and the third
saves the VFP state.

The notifiers are used for two types of events, CPU PM events and
CPU complex PM events.  CPU PM events are used to save and restore
per-cpu context when a single CPU is preparing to enter or has
just exited a low power state.  For example, the VFP saves the
last thread context, and the GIC saves banked CPU registers.

CPU complex events are used after all the CPUs in a power domain
have been prepared for the low power state.  The GIC uses these
events to save global register state.

Platforms that call the cpu_pm APIs must select
CONFIG_ARCH_USES_CPU_PM

L2 cache is not covered by this patch set, as the determination
of when the L2 is reset and when it is retained is
platform-specific, and most of the APIs necessary are already
present.

 arch/arm/Kconfig              |    7 ++
 arch/arm/common/gic.c         |  212 +++++++++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/cpu_pm.h |   54 +++++++++++
 arch/arm/kernel/Makefile      |    1 +
 arch/arm/kernel/cpu_pm.c      |  181 +++++++++++++++++++++++++++++++++++
 arch/arm/vfp/vfpmodule.c      |   40 ++++++++
 6 files changed, 495 insertions(+), 0 deletions(-)
