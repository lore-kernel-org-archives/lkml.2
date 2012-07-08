Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2GHTpa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 15:45:30 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40108 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2GHTp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:45:28 -0400
Date: Sun, 8 Jul 2012 14:45:19 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Octavio Alvarez <alvarezp@alvarezp.com>,
        Bob Moore <robert.moore@intel.com>,
        Adrian Knoth <adi@drcomp.erfurt.thur.de>, Shaohua Li <shli@kernel.org>,
        Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] ACPI: Leave Bus Master Arbitration enabled for
 suspend/resume
Message-ID: <20120708194519.GA8807@burratino>
References: <op.wg3en6ij6g6bxc@localhost.localdomain>
 <20120708190434.GD7328@burratino>
 <20120708193204.GF7328@burratino>
 <201207082143.04099.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207082143.04099.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an old suspend/resume lockup fix:

	commit 2780cc4660e1
	Author: Len Brown <len.brown@intel.com>
	Date:   Thu Dec 23 13:43:30 2004 -0500

	    [ACPI] Fix suspend/resume lockup issue
	    by leaving Bus Master Arbitration enabled.
	    The ACPI spec mandates it be disabled only for C3.

	    http://bugzilla.kernel.org/show_bug.cgi?id=3599

	    Signed-off-by: David Shaohua Li <shaohua.li@intel.com>
	    Signed-off-by: Len Brown <len.brown@intel.com>

The bug snuck back in in commit 2feec47d4c5f (ACPICA: ACPI 5: Support
for new FADT SleepStatus, SleepControl registers, 2012-02-14),
presumably by copy/pasting a copy of the code without that fix for the
legacy case.

On affected machines, after that commit, the machine locks up hard on
resume from suspend.  The same fix as seven years ago still works.

Addresses <https://bugzilla.kernel.org/show_bug.cgi?id=43641>.

Reported-bisected-and-tested-by: Octavio Alvarez <alvarezp@alvarezp.com>
Reported-by: Adrian Knoth <adi@drcomp.erfurt.thur.de>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: <stable@vger.kernel.org> # 3.4
---
Rafael J. Wysocki wrote:

> Can you please repost it with _both_ the changelog and the patch?

Here you go.  Sorry about that.

 drivers/acpi/acpica/hwsleep.c |   22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/acpi/acpica/hwsleep.c b/drivers/acpi/acpica/hwsleep.c
index 0ed85cac3231..615996a36bed 100644
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -95,18 +95,6 @@ acpi_status acpi_hw_legacy_sleep(u8 sleep_state, u8 flags)
 		return_ACPI_STATUS(status);
 	}
 
-	if (sleep_state != ACPI_STATE_S5) {
-		/*
-		 * Disable BM arbitration. This feature is contained within an
-		 * optional register (PM2 Control), so ignore a BAD_ADDRESS
-		 * exception.
-		 */
-		status = acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 1);
-		if (ACPI_FAILURE(status) && (status != AE_BAD_ADDRESS)) {
-			return_ACPI_STATUS(status);
-		}
-	}
-
 	/*
 	 * 1) Disable/Clear all GPEs
 	 * 2) Enable all wakeup GPEs
@@ -364,16 +352,6 @@ acpi_status acpi_hw_legacy_wake(u8 sleep_state, u8 flags)
 				    [ACPI_EVENT_POWER_BUTTON].
 				    status_register_id, ACPI_CLEAR_STATUS);
 
-	/*
-	 * Enable BM arbitration. This feature is contained within an
-	 * optional register (PM2 Control), so ignore a BAD_ADDRESS
-	 * exception.
-	 */
-	status = acpi_write_bit_register(ACPI_BITREG_ARB_DISABLE, 0);
-	if (ACPI_FAILURE(status) && (status != AE_BAD_ADDRESS)) {
-		return_ACPI_STATUS(status);
-	}
-
 	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, ACPI_SST_WORKING);
 	return_ACPI_STATUS(status);
 }
-- 
1.7.10.4

