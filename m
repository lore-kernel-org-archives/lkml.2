Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab0DNPHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 11:07:06 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:6087 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab0DNPHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 11:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:organization:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=MXwob78Sa0kAp7ugngm3BTe8QW3Kh+z2EBjoMdyb0anV5VWu5hEF9XztVB6XVlaD1u
         xIkpGMOPnvh2/xZUuxVjzhahK9jZH73A//MQauMtjInOcSVTDShLZ72w82E6qnd3o0Zn
         yD7Za1yD/UuH5SXgwPipvEUA4Bf3sn2RYFnjY=
Date: Wed, 14 Apr 2010 19:06:57 +0400
From: Timur Maximov <xcom.org@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] serial_cs: MD55x support (PCMCIA GPRS/EDGE modem) (kernel
 2.6.33)
Message-Id: <20100414190657.50a245f8.xcom.org@gmail.com>
Organization: -= X-COM =-
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many PCMCIA GPRS modems like: Onda Edge N100E, Novaway PC98 (OEM SPC98Z),
Rovermate Edgus Adaptmate-039 and others have same construction and
identification:

lspcmcia -vvv
Product Name:   Generic Modem: MD55x 1.00 Serial number: xxxxx-xxx 
Identification: manf_id: 0x015d card_id: 0x4c45
                function: 2 (serial)
                prod_id(1): "Generic" (0xc49e4731)
                prod_id(2): "Modem: MD55x" (0x8913b110)
                prod_id(3): "1.00" (0x83dbf271)
                prod_id(4): "Serial number: xxxxx-xxx" (0x73ee9514)

Serial connection to GSM module based on Elan VPU16551 PCMCIA UART with
datasheet recommeded 14.7456MHz crystal oscillator.

By default serial_cs set UART clock == 1843200 Hz
For correct work need set clock 14745600 Hz.
This quirk already present in driver, only need add device in quirk list.

Signed-off-by: Timur Maximov <xcom.org@gmail.com>
---

--- linux-2.6.33/drivers/serial/serial_cs.c.orig	2010-02-24 21:52:17.000000000 +0300
+++ linux-2.6.33/drivers/serial/serial_cs.c	2010-04-13 21:01:07.984186038 +0400
@@ -105,6 +105,10 @@ struct serial_cfg_mem {
  * manfid 0x0160, 0x0104
  * This card appears to have a 14.7456MHz clock.
  */
+/* Generic Modem: MD55x (GPRS/EDGE) have
+ * Elan VPU16551 UART with 14.7456MHz oscillator
+ * manfid 0x015D, 0x4C45
+ */
 static void quirk_setup_brainboxes_0104(struct pcmcia_device *link, struct uart_port *port)
 {
 	port->uartclk = 14745600;
@@ -196,6 +200,11 @@ static const struct serial_quirk quirks[
 		.multi	= -1,
 		.setup	= quirk_setup_brainboxes_0104,
 	}, {
+		.manfid	= 0x015D,
+		.prodid	= 0x4C45,
+		.multi	= -1,
+		.setup	= quirk_setup_brainboxes_0104,
+	}, {
 		.manfid	= MANFID_IBM,
 		.prodid	= ~0,
 		.multi	= -1,
