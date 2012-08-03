Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2HCHIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 03:08:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57839 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab2HCHHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 03:07:50 -0400
From: Huacai Chen <chenhuacai@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>, stable@vger.kernel.org
Subject: [PATCH V4 15/16] MIPS: Fix poweroff failure when HOTPLUG_CPU configured.
Date: Fri,  3 Aug 2012 15:06:10 +0800
Message-Id: <1343977571-2292-16-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1343977571-2292-1-git-send-email-chenhc@lemote.com>
References: <1343977571-2292-1-git-send-email-chenhc@lemote.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When poweroff machine, kernel_power_off() call disable_nonboot_cpus().
And if we have HOTPLUG_CPU configured, disable_nonboot_cpus() is not an
empty function but attempt to actually disable the nonboot cpus. Since
system state is SYSTEM_POWER_OFF, play_dead() won't be called and thus
disable_nonboot_cpus() hangs. Therefore, we make this patch to avoid
poweroff failure.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
Cc: stable@vger.kernel.org
---
 arch/mips/kernel/process.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index e9a5fd7..69b17a9 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -72,9 +72,7 @@ void __noreturn cpu_idle(void)
 			}
 		}
 #ifdef CONFIG_HOTPLUG_CPU
-		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map) &&
-		    (system_state == SYSTEM_RUNNING ||
-		     system_state == SYSTEM_BOOTING))
+		if (!cpu_online(cpu) && !cpu_isset(cpu, cpu_callin_map))
 			play_dead();
 #endif
 		rcu_idle_exit();
-- 
1.7.7.3

