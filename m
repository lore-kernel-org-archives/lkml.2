Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab1CVRMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 13:12:31 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:32783 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756480Ab1CVRM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 13:12:26 -0400
From: Julia Lawall <julia@diku.dk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel-janitors@vger.kernel.org, Niels de Vos <ndevos@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] drivers/parport/parport_pc.c: Convert release_resource to release_region/release_mem_region
Date: Tue, 22 Mar 2011 18:15:22 +0100
Message-Id: <1300814123-25314-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Request_region should be used with release_region, not
release_resource.

base_res is also dropped because it is no longer needed.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,E;
@@
*x = request_region(...)
... when != release_region(x)
    when != x = E
* release_resource(x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
In the original code, the second argument of request_region is 32 and the
second argument of the following release_region is 0x8.  I have thus used
0x8 as the second argument of the call to release_region introduced to
replace the call to release_resource.  But shouldn't the second arguments
of all of the functions be the same?

 drivers/parport/parport_pc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/parport/parport_pc.c b/drivers/parport/parport_pc.c
index 8d62fb7..320a4df 100644
--- a/drivers/parport/parport_pc.c
+++ b/drivers/parport/parport_pc.c
@@ -2550,7 +2550,6 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
 					 const struct parport_pc_via_data *via)
 {
 	short inta_addr[6] = { 0x2A0, 0x2C0, 0x220, 0x240, 0x1E0 };
-	struct resource *base_res;
 	u32 ite8872set;
 	u32 ite8872_lpt, ite8872_lpthi;
 	u8 ite8872_irq, type;
@@ -2561,8 +2560,7 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
 
 	/* make sure which one chip */
 	for (i = 0; i < 5; i++) {
-		base_res = request_region(inta_addr[i], 32, "it887x");
-		if (base_res) {
+		if (request_region(inta_addr[i], 32, "it887x")) {
 			int test;
 			pci_write_config_dword(pdev, 0x60,
 						0xe5000000 | inta_addr[i]);
@@ -2635,7 +2633,7 @@ static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
 	/*
 	 * Release the resource so that parport_pc_probe_port can get it.
 	 */
-	release_resource(base_res);
+	release_region(inta_addr[i], 0x8);
 	if (parport_pc_probe_port(ite8872_lpt, ite8872_lpthi,
 				   irq, PARPORT_DMA_NONE, &pdev->dev, 0)) {
 		printk(KERN_INFO

