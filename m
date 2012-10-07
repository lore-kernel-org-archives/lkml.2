Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2JGX3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:29:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38635 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618Ab2JGXXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:17 -0400
Message-Id: <20121007225840.529035238@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:59:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Andreas Hartmann <andihartmann@01019freenet.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 042/108] hwmon: (fam15h_power) Tweak runavg_range on resume
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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
 
 static int __init fam15h_power_init(void)


