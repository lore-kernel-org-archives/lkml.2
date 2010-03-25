Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0CYMG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:06:29 -0400
Received: from server78.greatnet.de ([83.133.96.102]:59245 "EHLO
	server78.greatnet.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab0CYMG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:06:27 -0400
From: Henrik Kretzschmar <henne@nachtwindheim.de>
To: isdn@linux-pingi.de
Cc: davem@davemloft.net, linux@dominikbrodowski.net, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Henrik Kretzschmar <henne@nachtwindheim.de>
Subject: [PATCH 2/4] isdn: Cleanup Sections in PCMCIA driver teles
Date: Thu, 25 Mar 2010 13:05:30 +0100
Message-Id: <1269518732-4515-2-git-send-email-henne@nachtwindheim.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compiling this driver gave a section mismatch,
so I reviewed the init/exit paths of the driver
and made the correct changes.

WARNING: drivers/isdn/hisax/built-in.o(.text+0x56bfb): Section mismatch
in reference from the function teles_cs_config() to the function
.devinit.text:hisax_init_pcmcia()
The function teles_cs_config() references
the function __devinit hisax_init_pcmcia().
This is often because teles_cs_config lacks a __devinit
annotation or the annotation of hisax_init_pcmcia is wrong.

Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---
 drivers/isdn/hisax/teles_cs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/isdn/hisax/teles_cs.c b/drivers/isdn/hisax/teles_cs.c
index b0c5976..d010a0d 100644
--- a/drivers/isdn/hisax/teles_cs.c
+++ b/drivers/isdn/hisax/teles_cs.c
@@ -57,7 +57,7 @@ module_param(protocol, int, 0);
    handler.
 */
 
-static int teles_cs_config(struct pcmcia_device *link);
+static int teles_cs_config(struct pcmcia_device *link) __devinit ;
 static void teles_cs_release(struct pcmcia_device *link);
 
 /*
@@ -66,7 +66,7 @@ static void teles_cs_release(struct pcmcia_device *link);
    needed to manage one actual PCMCIA card.
 */
 
-static void teles_detach(struct pcmcia_device *p_dev);
+static void teles_detach(struct pcmcia_device *p_dev) __devexit ;
 
 /*
    A linked list of "instances" of the teles_cs device.  Each actual
@@ -112,7 +112,7 @@ typedef struct local_info_t {
 
 ======================================================================*/
 
-static int teles_probe(struct pcmcia_device *link)
+static int __devinit teles_probe(struct pcmcia_device *link)
 {
     local_info_t *local;
 
@@ -156,7 +156,7 @@ static int teles_probe(struct pcmcia_device *link)
 
 ======================================================================*/
 
-static void teles_detach(struct pcmcia_device *link)
+static void __devexit teles_detach(struct pcmcia_device *link)
 {
 	local_info_t *info = link->priv;
 
@@ -200,7 +200,7 @@ static int teles_cs_configcheck(struct pcmcia_device *p_dev,
 	return -ENODEV;
 }
 
-static int teles_cs_config(struct pcmcia_device *link)
+static int __devinit teles_cs_config(struct pcmcia_device *link)
 {
     local_info_t *dev;
     int i;
@@ -319,7 +319,7 @@ static struct pcmcia_driver teles_cs_driver = {
 		.name	= "teles_cs",
 	},
 	.probe		= teles_probe,
-	.remove		= teles_detach,
+	.remove		= __devexit_p(teles_detach),
 	.id_table       = teles_ids,
 	.suspend	= teles_suspend,
 	.resume		= teles_resume,
-- 
1.6.3.3

