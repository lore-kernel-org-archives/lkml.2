Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab2GHTEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 15:04:42 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:39498 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GHTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:04:40 -0400
Date: Sun, 8 Jul 2012 14:04:35 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Octavio Alvarez <alvarezp@alvarezp.com>
Cc: Bob Moore <robert.moore@intel.com>,
        Adrian Knoth <adi@drcomp.erfurt.thur.de>, Shaohua Li <shli@kernel.org>,
        Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: Leave Bus Master Arbitration enabled for suspend/resume
Message-ID: <20120708190434.GD7328@burratino>
References: <op.wg3en6ij6g6bxc@localhost.localdomain>
 <Pine.LNX.4.44L0.1207072208270.508-100000@netrider.rowland.org>
 <20120708025730.GE2961@burratino>
 <op.wg30yabp6g6bxc@localhost.localdomain>
 <20120708090432.GF4625@burratino>
 <op.wg4f33nl6g6bxc@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.wg4f33nl6g6bxc@localhost.localdomain>
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

The bug snuck back in in commit 33620c5419e8 (ACPICA: Support for
custom ACPICA build for ACPI 5 reduced hardware, 2012-02-14),
presumably by copy/pasting from the wrong source for the legacy case.

On affected machines, after that commit, the machine locks up hard
on resume from suspend.  The same fix as seven years ago fixes it.

Addresses <https://bugzilla.kernel.org/show_bug.cgi?id=43641>.

Reported-bisected-and-tested-by: Octavio Alvarez <alvarezp@alvarezp.com>
Reported-by: Adrian Knoth <adi@drcomp.erfurt.thur.de>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: <stable@vger.kernel.org> # 3.4
---
Octavio Alvarez wrote:

> Given the complexity of the ACPI_DEBUG logging (particularly the
> console part), I decided to give your patch a shot directly.
>
> Result: the system no longer locks up.

Thanks!

Here's a properly formatted patch.

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

