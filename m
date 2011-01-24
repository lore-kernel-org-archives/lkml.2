Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1AXXqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:46:23 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:55979 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1AXXqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:46:21 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>
Subject: [PATCH] pps: claim parallel port exclusively
Date: Tue, 25 Jan 2011 02:46:05 +0300
Message-Id: <5f4d478f7f5ec0e0734b29e6f35c635c86a2488d.1295912692.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110121194317.GA8908@elte.hu>
References: <20110121194317.GA8908@elte.hu>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both pps_parport and pps_gen_parport are written in a way that they
can't share a port with any other driver. This can result in locking up
the process that loads modules or even the whole kernel if the modules
are compiled in. Use PARPORT_FLAG_EXCL to indicate this.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/clients/pps_parport.c        |    2 +-
 drivers/pps/generators/pps_gen_parport.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index 32221ef..c571d6d 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -163,7 +163,7 @@ static void parport_attach(struct parport *port)
 	}
 
 	device->pardev = parport_register_device(port, KBUILD_MODNAME,
-			NULL, NULL, parport_irq, 0, device);
+			NULL, NULL, parport_irq, PARPORT_FLAG_EXCL, device);
 	if (!device->pardev) {
 		pr_err("couldn't register with %s\n", port->name);
 		goto err_free;
diff --git a/drivers/pps/generators/pps_gen_parport.c b/drivers/pps/generators/pps_gen_parport.c
index 5c32f8d..b93af3e 100644
--- a/drivers/pps/generators/pps_gen_parport.c
+++ b/drivers/pps/generators/pps_gen_parport.c
@@ -198,7 +198,7 @@ static void parport_attach(struct parport *port)
 	}
 
 	device.pardev = parport_register_device(port, KBUILD_MODNAME,
-			NULL, NULL, NULL, 0, &device);
+			NULL, NULL, NULL, PARPORT_FLAG_EXCL, &device);
 	if (!device.pardev) {
 		pr_err("couldn't register with %s\n", port->name);
 		return;
-- 
1.7.2.3

