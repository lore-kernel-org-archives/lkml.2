Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab0HaAzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:55:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53186 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab0HaAzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:55:14 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4C7C5314.7090404@np.css.fujitsu.com>
Date: Tue, 31 Aug 2010 09:55:48 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: "Yu, Fenghua" <fenghua.yu@intel.com>, Jean Delvare <khali@linux-fr.org>
CC: "Brown, Len" <len.brown@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.jf.intel.com>,
        LKLM <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        mingo Redhat <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [Patch-next] Trival fixes in thermal_throttle_add_dev().
References: <4C75D3C4.6040802@np.css.fujitsu.com>	<20100826060822.GA15021@fenghua-desk.sc.intel.com>	<4C7625D1.4060201@np.css.fujitsu.com> <20100827152007.27636fa5@hyperion.delvare> <4C7B64A8.2030208@np.css.fujitsu.com> <493994B35A117E4F832F97C4719C4C04A111EEDF@orsmsx505.amr.corp.intel.com>
In-Reply-To: <493994B35A117E4F832F97C4719C4C04A111EEDF@orsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed the following two problems.
  1. When the feature PTS is not supported by CPU, the sysfile
     package_power_limit_count for package should not be generated.
  2. No matter whether a sysfile is failed to be created or not,
     the next one will be created.

As the resolving methods:
  1. Add missing { and } after checking PTS feature.
  2. Fix the error handling.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Reviewed-by: Fenghua Yu <fenghua.yu@initel.com>
---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index d9368ee..79d563a 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -216,14 +216,27 @@ static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
 		err = sysfs_add_file_to_group(&sys_dev->kobj,
 					      &attr_core_power_limit_count.attr,
 					      thermal_attr_group.name);
-	if (cpu_has(c, X86_FEATURE_PTS))
+	if (err)
+		goto error;
+
+	if (cpu_has(c, X86_FEATURE_PTS)) {
 		err = sysfs_add_file_to_group(&sys_dev->kobj,
 					      &attr_package_throttle_count.attr,
 					      thermal_attr_group.name);
+		if (err)
+			goto error;
+
 		if (cpu_has(c, X86_FEATURE_PLN))
 			err = sysfs_add_file_to_group(&sys_dev->kobj,
 					&attr_package_power_limit_count.attr,
 					thermal_attr_group.name);
+		if (err)
+			goto error;
+	}
+
+	return 0;
+error:
+	sysfs_remove_group(&sys_dev->kobj, &thermal_attr_group);
 
 	return err;
 }
-- 
1.7.1.1

