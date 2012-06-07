Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246Ab2FGFwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 01:52:41 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:7215 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664Ab2FGFwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 01:52:39 -0400
From: Steven Newbury <steve@snewbury.org.uk>
Reply-To: Steven Newbury <steve@snewbury.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: hda - HDMI Audio init all connectors
X-Mailer: Modest 3.90.7
Content-Type: multipart/mixed; boundary="=-J06lWbz+FW+aXclNN6tn"
X-MS-Has-Attach: Yes
Date: Thu, 07 Jun 2012 06:52:59 +0100
Message-Id: <1339048379.2910.9.camel@Nokia-N900>
Mime-Version: 1.0
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=M8ut7WrbaokA:10 a=xqWC_Br6kY4A:10 a=N1CowNylAAAA:8 a=a7GXg28UNaKwcjQ6tJ0A:9 a=QEXdDO2ut3YA:10 a=8swQgU7S4FlixQ0lj14A:9 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-J06lWbz+FW+aXclNN6tn
Content-Type: text/plain; charset=utf-8
Content-ID: <1339048377.2910.6.camel@Nokia-N900>
Content-Transfer-Encoding: 7bit

When VGA_SWITCHEROO support is enabled hda_intel initialises the HDMI audio device on the current VGA device.  When it's not enabled it only initialises the HDMI device on the default VGA adaptor, this means secondary cards get no audio support which is very unhelpful for multi-seat!

With this patch, when SUPPORT_VGA_SWITCHEROO is disabled hda_intel initialises all HDMI audio devices, not just the default VGA.

Signed-off-by: Steven Newbury <steve@snewbury.org.uk>

--=-J06lWbz+FW+aXclNN6tn
Content-Disposition: attachment; filename=hdmi-audio-init.patch
Content-Type: text/x-patch; name=hdmi-audio-init.patch
Content-ID: <0>
Content-Transfer-Encoding: 7bit

commit 8989f0e53f7108d099fb7c5fdb76f58d3a63f85a
Author: Steven Newbury <steve@snewbury.org.uk>
Date:   Wed Jun 6 23:52:13 2012 +0100

ALSA: hda - Always initialise all HDMI audio connectors
              when SUPPORT_VGA_SWITCHEROO is disabled

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index e924722..f207549 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2484,9 +2484,9 @@ static void azx_notifier_unregister(struct azx *chip)
 static int DELAYED_INIT_MARK azx_first_init(struct azx *chip);
 static int DELAYED_INIT_MARK azx_probe_continue(struct azx *chip);
 
+#ifdef SUPPORT_VGA_SWITCHEROO
 static struct pci_dev __devinit *get_bound_vga(struct pci_dev *pci);
 
-#ifdef SUPPORT_VGA_SWITCHEROO
 static void azx_vs_set_state(struct pci_dev *pci,
 			     enum vga_switcheroo_state state)
 {
@@ -2641,6 +2641,7 @@ static int azx_dev_free(struct snd_device *device)
 /*
  * Check of disabled HDMI controller by vga-switcheroo
  */
+#ifdef SUPPORT_VGA_SWITCHEROO
 static struct pci_dev __devinit *get_bound_vga(struct pci_dev *pci)
 {
 	struct pci_dev *p;
@@ -2663,10 +2664,12 @@ static struct pci_dev __devinit *get_bound_vga(struct pci_dev *pci)
 	}
 	return NULL;
 }
+#endif /* SUPPORT_VGA_SWITCHER */
 
 static bool __devinit check_hdmi_disabled(struct pci_dev *pci)
 {
 	bool vga_inactive = false;
+#ifdef SUPPORT_VGA_SWITCHEROO
 	struct pci_dev *p = get_bound_vga(pci);
 
 	if (p) {
@@ -2674,6 +2677,7 @@ static bool __devinit check_hdmi_disabled(struct pci_dev *pci)
 			vga_inactive = true;
 		pci_dev_put(p);
 	}
+#endif
 	return vga_inactive;
 }
 

--=-J06lWbz+FW+aXclNN6tn--

