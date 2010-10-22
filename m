Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab0JVSjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:39:43 -0400
Received: from kroah.org ([198.145.64.141]:45916 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758713Ab0JVSjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:39:09 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:36:02 2010
Message-Id: <20101022183602.094033497@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:35:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Huaxu Wan <huaxu.wan@linux.intel.com>, Carsten Emde <C.Emde@osadl.org>,
        Jean Delvare <khali@linux-fr.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Yong Wang <yong.y.wang@linux.intel.com>,
        Rudolf Marek <r.marek@assembler.cz>,
        Brad Buce <Brad.Buce@elbitsystems-us.com>
Subject: [66/66] drivers/hwmon/coretemp.c: detect the thermal sensors by CPUID
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carsten Emde <C.Emde@osadl.org>

commit 5db47b009d17d69a2f8d84357e7b24c3e3c2edec upstream.

The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
indicated by CPUID.06H.EAX[0].

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Reviewed-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Brad Buce <Brad.Buce@elbitsystems-us.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/coretemp.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -479,28 +479,20 @@ static int __init coretemp_init(void)
 
 	for_each_online_cpu(i) {
 		struct cpuinfo_x86 *c = &cpu_data(i);
-
-		/* check if family 6, models 0xe (Pentium M DC),
-		  0xf (Core 2 DC 65nm), 0x16 (Core 2 SC 65nm),
-		  0x17 (Penryn 45nm), 0x1a (Nehalem), 0x1c (Atom),
-		  0x1e (Lynnfield) */
-		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
-		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
-			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
-			(c->x86_model == 0x1a) || (c->x86_model == 0x1c) ||
-			(c->x86_model == 0x1e))) {
-
-			/* supported CPU not found, but report the unknown
-			   family 6 CPU */
-			if ((c->x86 == 0x6) && (c->x86_model > 0xf))
-				printk(KERN_WARNING DRVNAME ": Unknown CPU "
-					"model %x\n", c->x86_model);
-			continue;
+		/*
+		* CPUID.06H.EAX[0] indicates whether the CPU has thermal
+		* sensors. We check this bit only, all the early CPUs
+		* without thermal sensors will be filtered out.
+		*/
+		if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01)) {
+			err = coretemp_device_add(i);
+			if (err)
+				goto exit_devices_unreg;
+
+		} else {
+			printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
+				" has no thermal sensor.\n", c->x86_model);
 		}
-
-		err = coretemp_device_add(i);
-		if (err)
-			goto exit_devices_unreg;
 	}
 	if (list_empty(&pdev_list)) {
 		err = -ENODEV;


