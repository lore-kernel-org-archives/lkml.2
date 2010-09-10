Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab0IJCoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 22:44:11 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:38682 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab0IJCoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 22:44:10 -0400
Date: Thu, 09 Sep 2010 21:43:49 -0500
From: Corey Minyard <minyard@acm.org>
To: Andrew Morton <akpm@osdl.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] ipmi: fix acpi probe print
Message-id: <20100910024348.GB5627@mail.minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

After
|commit d9e1b6c45059ccfff647a120769ae86da78dfdc4
|
|    ipmi: fix ACPI detection with regspacing

got
[   11.026326] ipmi_si: probing via ACPI
[   11.030019] ipmi_si 00:09: (null) regsize 1 spacing 1 irq 0
[   11.035594] ipmi_si: Adding ACPI-specified kcs state machine

on old system with only one range for ipmi kcs range.

Try to fix it by adding another res pointer.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Corey Minyard <cminyard@mvista.com>

---
 drivers/char/ipmi/ipmi_si_intf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6.35/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.35.orig/drivers/char/ipmi/ipmi_si_intf.c	2010-09-09 21:26:35.980978855 -0500
+++ linux-2.6.35/drivers/char/ipmi/ipmi_si_intf.c	2010-09-09 21:26:50.542230669 -0500
@@ -2126,7 +2126,7 @@
 {
 	struct acpi_device *acpi_dev;
 	struct smi_info *info;
-	struct resource *res;
+	struct resource *res, *res_second;
 	acpi_handle handle;
 	acpi_status status;
 	unsigned long long tmp;
@@ -2182,13 +2182,13 @@
 	info->io.addr_data = res->start;
 
 	info->io.regspacing = DEFAULT_REGSPACING;
-	res = pnp_get_resource(dev,
+	res_second = pnp_get_resource(dev,
 			       (info->io.addr_type == IPMI_IO_ADDR_SPACE) ?
 					IORESOURCE_IO : IORESOURCE_MEM,
 			       1);
-	if (res) {
-		if (res->start > info->io.addr_data)
-			info->io.regspacing = res->start - info->io.addr_data;
+	if (res_second) {
+		if (res_second->start > info->io.addr_data)
+			info->io.regspacing = res_second->start - info->io.addr_data;
 	}
 	info->io.regsize = DEFAULT_REGSPACING;
 	info->io.regshift = 0;
