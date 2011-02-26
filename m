Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab1BZJXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 04:23:11 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:52373 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1BZJXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 04:23:08 -0500
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-WhiteListed: mail was accepted with no delay
X-Originating-IP: 217.70.178.45
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        platform-driver-x86@vger.kernel.org (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 09/14] asus-wmi: add calls to INIT, SPEC and SFUN on init
Date: Sat, 26 Feb 2011 10:20:38 +0100
Message-Id: <1298712045-17671-10-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
References: <1298712045-17671-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

INIT() call is needed to enable hotkeys on G73
SPEC() and SFUN() allow us to know more about
available features.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/asus-wmi.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index adf7b05..88596ea 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -66,10 +66,13 @@ MODULE_LICENSE("GPL");
 #define NOTIFY_BRNDOWN_MAX		0x2e
 
 /* WMI Methods */
+#define ASUS_WMI_METHODID_SPEC	        0x43455053
+#define ASUS_WMI_METHODID_SFUN		0x4E554653
 #define ASUS_WMI_METHODID_DSTS		0x53544344
 #define ASUS_WMI_METHODID_DSTS2		0x53545344
 #define ASUS_WMI_METHODID_DEVS		0x53564544
 #define ASUS_WMI_METHODID_CFVS		0x53564643
+#define ASUS_WMI_METHODID_INIT		0x54494E49
 
 #define ASUS_WMI_UNSUPPORTED_METHOD	0xFFFFFFFE
 
@@ -126,6 +129,8 @@ struct asus_rfkill {
 
 struct asus_wmi {
 	int dsts_id;
+	int spec;
+	int sfun;
 
 	struct input_dev *inputdev;
 	struct backlight_device *backlight_device;
@@ -1065,6 +1070,29 @@ static int asus_wmi_sysfs_init(struct platform_device *device)
  */
 static int __init asus_wmi_platform_init(struct asus_wmi *asus)
 {
+	int rv;
+
+	/* INIT enable hotkeys on some models */
+	if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_INIT, 0, 0, &rv))
+		pr_info("Initialization: %#x", rv);
+
+	/* We don't know yet what to do with this version... */
+	if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_SPEC, 0, 0x9, &rv)) {
+		pr_info("BIOS WMI version: %d.%d", rv >> 8, rv & 0xFF);
+		asus->spec = rv;
+	}
+
+	/*
+	 * The SFUN method probably allows the original driver to get the list
+	 * of features supported by a given model. For now, 0x0100 or 0x0800
+	 * bit signifies that the laptop is equipped with a Wi-Fi MiniPCI card.
+	 * The significance of others is yet to be found.
+	 */
+	if (!asus_wmi_evaluate_method(ASUS_WMI_METHODID_SFUN, 0, 0, &rv)) {
+		pr_info("SFUN value: %#x", rv);
+		asus->sfun = rv;
+	}
+
 	/*
 	 * Eee PC and Notebooks seems to have different method_id for DSTS,
 	 * but it may also be related to the BIOS's SPEC.
-- 
1.7.4

