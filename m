Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932320Ab0HKBwj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 21:52:39 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:44320 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324Ab0HKBwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 21:52:37 -0400
Message-ID: <4C6201F5.3080600@kernel.org>
Date: Tue, 10 Aug 2010 18:50:45 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Corey Minyard <minyard@acm.org>, Andrew Morton <akpm@linux-foundation.org>
CC: Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
        Myron Stowe <myron.stowe@hp.com>,
        openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] ipmi: fix acpi probe print
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

---
 drivers/char/ipmi/ipmi_si_intf.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
===================================================================
--- linux-2.6.orig/drivers/char/ipmi/ipmi_si_intf.c
+++ linux-2.6/drivers/char/ipmi/ipmi_si_intf.c
@@ -2132,7 +2132,7 @@ static int __devinit ipmi_pnp_probe(stru
 {
 	struct acpi_device *acpi_dev;
 	struct smi_info *info;
-	struct resource *res;
+	struct resource *res, *res_second;
 	acpi_handle handle;
 	acpi_status status;
 	unsigned long long tmp;
@@ -2188,13 +2188,13 @@ static int __devinit ipmi_pnp_probe(stru
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
