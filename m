Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899Ab1FAFHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 01:07:24 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:54888 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393Ab1FAFHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 01:07:17 -0400
X-Originating-IP: 217.70.178.131
X-Originating-IP: 131.252.248.105
Date: Tue, 31 May 2011 22:07:01 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Jamey Sharp <jamey@minilop.net>
Subject: Hooking up SM501 on TQM5200 (MPC5200) board via device tree?
Message-ID: <20110601050659.GA7789@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a TQM5200 board, which has GPIO lines hooked up to an SM501.
I've managed to come up with the following patch to the tqm5200 device
tree, which manages to convince the sm501 driver to attach an sm501-fb:

--- a/arch/powerpc/boot/dts/tqm5200.dts  2009-11-23 03:13:27.000000000 -0800
+++ b/arch/powerpc/boot/dts/tqm5200.dts  2011-05-31 22:00:28.000580627 -0700
@@ -177,7 +177,8 @@
                compatible = "fsl,mpc5200-lpb","simple-bus";
                #address-cells = <2>;
                #size-cells = <1>;
-               ranges = <0 0 0xfc000000 0x02000000>;
+               ranges = <0 0 0xfc000000 0x02000000
+                         1 0 0xe0000000 0x04000000>;
 
                flash@0,0 {
                        compatible = "cfi-flash";
@@ -187,6 +188,13 @@
                        #size-cells = <1>;
                        #address-cells = <1>;
                };
+
+               display@1,0 {
+                       compatible = "smi,sm501";
+                       reg = <1 0x00000000 0x00800000
+                              1 0x03e00000 0x00200000>;
+                       interrupts = <1 1 3>;
+               };
        };
 
        pci@f0000d00 {


However, this doesn't hook up the sm501-gpio bits.  Reading the sm501
driver carefully, it looks like it only hooks up sm501-gpio if it has
platform_data available which sets some flags and other information.
So, if I understand correctly, hooking up sm501-gpio would require
adding functionality the driver to get the GPIO information from the
device tree in preference to the platform_data, if available, and fall
back to the platform_data for existing users?

What should the necessary device tree properties look like to replace
sm501_initdata?

- Josh Triplett
