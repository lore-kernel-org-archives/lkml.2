Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab2BRQyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 11:54:39 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:13010 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2BRQyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 11:54:37 -0500
Date: Sat, 18 Feb 2012 17:54:23 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: Fix ACPI conflict check
Message-ID: <20120218175423.3f8d6ce6@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code is currently always checking the first resource of every
device only (several times.) This has been broken since the ACPI check
was added in February 2010 in commit
91fedede0338eb6203cdd618d8ece873fdb7c22c.

Fix the check to run on each resource individually, once.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: stable@vger.kernel.org
---
I still believe that having ACPI checks in mfd-core is wrong to start
with. ACPI conflicts have become so frequent that this check if likely
to get a whole MFD chip to be unusable even if some of ifs functions
would be useable. For this reason I think the ACPI checks should be
the responsibility of the subdrivers. With this fix, even more
conflicts will happen, and I suspect more and more drivers will set
mfd_cell.ignore_resource_conflicts = true.

Still, if we have the check in place, let's do it right.

 drivers/mfd/mfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-3.3-rc3.orig/drivers/mfd/mfd-core.c	2012-01-06 11:21:11.000000000 +0100
+++ linux-3.3-rc3/drivers/mfd/mfd-core.c	2012-02-18 17:03:24.854788023 +0100
@@ -123,7 +123,7 @@ static int mfd_add_device(struct device
 		}
 
 		if (!cell->ignore_resource_conflicts) {
-			ret = acpi_check_resource_conflict(res);
+			ret = acpi_check_resource_conflict(&res[r]);
 			if (ret)
 				goto fail_res;
 		}


-- 
Jean Delvare
