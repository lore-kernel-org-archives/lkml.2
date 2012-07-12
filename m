Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162303Ab2GLWze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:55:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46727 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162142Ab2GLWoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:44:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Adrian Knoth <adi@drcomp.erfurt.thur.de>,
        Jonathan Nieder <jrnieder@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [ 148/187] ACPI / PM: Leave Bus Master Arbitration enabled for suspend/resume
Date: Thu, 12 Jul 2012 15:35:04 -0700
Message-Id: <20120712191536.117091045@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

commit dc332fdf9f373a87b1e2f423b5b004b2a3c37e1a upstream.

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
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpica/hwsleep.c |   22 ----------------------
 1 file changed, 22 deletions(-)

--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -95,18 +95,6 @@ acpi_status acpi_hw_legacy_sleep(u8 slee
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
@@ -364,16 +352,6 @@ acpi_status acpi_hw_legacy_wake(u8 sleep
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


