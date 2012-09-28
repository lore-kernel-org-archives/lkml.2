Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965215Ab2I1S7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:59:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965200Ab2I1S7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 109/262] hwmon: (fam15h_power) Tweak runavg_range on resume
Date: Fri, 28 Sep 2012 11:50:38 -0700
Message-Id: <20120928183011.069135813@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Herrmann <andreas.herrmann3@amd.com>

commit 5f0ecb907deb1e6f28071ee3bd568903b9da1be4 upstream.

The quirk introduced with commit
00250ec90963b7ef6678438888f3244985ecde14 (hwmon: fam15h_power: fix
bogus values with current BIOSes) is not only required during driver
load but also when system resumes from suspend. The BIOS might set the
previously recommended (but unsuitable) initilization value for the
running average range register during resume.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Tested-by: Andreas Hartmann <andihartmann@01019freenet.de>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/fam15h_power.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -128,12 +128,12 @@ static bool __devinit fam15h_power_is_in
  * counter saturations resulting in bogus power readings.
  * We correct this value ourselves to cope with older BIOSes.
  */
-static DEFINE_PCI_DEVICE_TABLE(affected_device) = {
+static const struct pci_device_id affected_device[] = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
 	{ 0 }
 };
 
-static void __devinit tweak_runavg_range(struct pci_dev *pdev)
+static void tweak_runavg_range(struct pci_dev *pdev)
 {
 	u32 val;
 
@@ -157,6 +157,16 @@ static void __devinit tweak_runavg_range
 		REG_TDP_RUNNING_AVERAGE, val);
 }
 
+#ifdef CONFIG_PM
+static int fam15h_power_resume(struct pci_dev *pdev)
+{
+	tweak_runavg_range(pdev);
+	return 0;
+}
+#else
+#define fam15h_power_resume NULL
+#endif
+
 static void __devinit fam15h_power_init_data(struct pci_dev *f4,
 					     struct fam15h_power_data *data)
 {
@@ -255,6 +265,7 @@ static struct pci_driver fam15h_power_dr
 	.id_table = fam15h_power_id_table,
 	.probe = fam15h_power_probe,
 	.remove = __devexit_p(fam15h_power_remove),
+	.resume = fam15h_power_resume,
 };
 
 module_pci_driver(fam15h_power_driver);


