Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849Ab2BJXGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:06:42 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779Ab2BJWnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:43:31 -0500
MIME-Version: 1.0
Message-Id: <20120210222952.615926683@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andreas Herrmann <andreas.herrmann3@amd.com>,
        Dave Jones <davej@redhat.com>
Subject: [patch 85/86] [CPUFREQ] powernow-k8: Avoid Pstate MSR accesses on systems supporting CPB
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 201bf0f129e1715a33568d1563d9a75b840ab4d3 upstream.

Due to CPB we can't directly map SW Pstates to Pstate MSRs. Get rid of
the paranoia check. (assuming that the ACPI Pstate information is
correct.)

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/powernow-k8.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -926,23 +926,24 @@ static int fill_powernow_table_pstate(st
 			invalidate_entry(powernow_table, i);
 			continue;
 		}
-		rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
-		if (!(hi & HW_PSTATE_VALID_MASK)) {
-			pr_debug("invalid pstate %d, ignoring\n", index);
-			invalidate_entry(powernow_table, i);
-			continue;
-		}
-
-		powernow_table[i].index = index;
-
 		/* Frequency may be rounded for these */
 		if ((boot_cpu_data.x86 == 0x10 && boot_cpu_data.x86_model < 10)
 				 || boot_cpu_data.x86 == 0x11) {
+
+			rdmsr(MSR_PSTATE_DEF_BASE + index, lo, hi);
+			if (!(hi & HW_PSTATE_VALID_MASK)) {
+				pr_debug("invalid pstate %d, ignoring\n", index);
+				invalidate_entry(powernow_table, i);
+				continue;
+			}
+
 			powernow_table[i].frequency =
 				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
 		} else
 			powernow_table[i].frequency =
 				data->acpi_data.states[i].core_frequency * 1000;
+
+		powernow_table[i].index = index;
 	}
 	return 0;
 }


