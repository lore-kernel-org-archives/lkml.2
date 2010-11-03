Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310Ab0KCSUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:20:16 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47090 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab0KCSUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nuuQ9rESkbiLTPymSHg7Zm8CsqPacqsIaycEGxlHcs/qBUWgK0f5aRq88RUDkt+3sS
         qAsScRWhSvajfoyJIlACtRo+qh1PP7R8GVf8Zam/ZUxikCGP6SaxJdb0wD//2L+dodwn
         4NqVL01SzyWWlGwptEtyffxNIZVhUpGaSgH1A=
Message-ID: <4CD1A7F6.2020504@lwfinger.net>
Date: Wed, 03 Nov 2010 13:20:38 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.14) Gecko/20101013 SUSE/3.0.9 Thunderbird/3.0.9
MIME-Version: 1.0
To: pali.rohar@gmail.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC/RFT] OHCI: Fix for regression in 2.6.37-rc1 since commit 3df7169e7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following commit 3df7169e73fc1d71a39cffeacc969f6840cdf52b, my logs are spammed
with messages of the form "hub 2-0:1.0: unable to enumerate USB device on
port 5".

Experimentation has shown that if the functional state bits of the control
register are preserved in the fixup, then the messages no longer appear.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Pali,

Is it possible for you to test this patch to ensure that it does not interfere
with the fix for the shutdown problem.

Thanks,

Larry
---

Index: linux-realtek/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-realtek.orig/drivers/usb/host/pci-quirks.c
+++ linux-realtek/drivers/usb/host/pci-quirks.c
@@ -35,6 +35,7 @@
 #define OHCI_INTRENABLE		0x10
 #define OHCI_INTRDISABLE	0x14
 #define OHCI_OCR		(1 << 3)	/* ownership change request */
+#define OHCI_CTRL_HCFS		(3 << 6)	/* functional state */
 #define OHCI_CTRL_RWC		(1 << 9)	/* remote wakeup connected */
 #define OHCI_CTRL_IR		(1 << 8)	/* interrupt routing */
 #define OHCI_INTR_OC		(1 << 30)	/* ownership change */
@@ -184,7 +185,7 @@ static void __devinit quirk_usb_handoff_
 #ifdef __hppa__
 #define	OHCI_CTRL_MASK		(OHCI_CTRL_RWC | OHCI_CTRL_IR)
 #else
-#define	OHCI_CTRL_MASK		OHCI_CTRL_RWC
+#define	OHCI_CTRL_MASK		(OHCI_CTRL_RWC | OHCI_CTRL_HCFS)

 	if (control & OHCI_CTRL_IR) {
 		int wait_time = 500; /* arbitrary; 5 seconds */


