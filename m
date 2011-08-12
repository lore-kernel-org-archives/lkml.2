Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab1HNQ00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 12:26:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36489 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab1HNQHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 12:07:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 12 14:05:54 2011
Message-Id: <20110812210554.847498847@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 12 Aug 2011 14:04:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [31/90] asus-wmi: fix hwmon/pwm1
In-Reply-To: <20110812210626.GA4725@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Corentin Chary <corentin.chary@gmail.com>

commit 49979d091d1847823c064301da1ec173619ddd92 upstream.

The code was completly broken, and should never had been sent
to the kernel. That's what happens when you write code without
hardware to test it.

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/asus-wmi.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -797,8 +797,8 @@ exit:
  * Hwmon device
  */
 static ssize_t asus_hwmon_pwm1(struct device *dev,
-			    struct device_attribute *attr,
-			    char *buf)
+			       struct device_attribute *attr,
+			       char *buf)
 {
 	struct asus_wmi *asus = dev_get_drvdata(dev);
 	u32 value;
@@ -809,7 +809,7 @@ static ssize_t asus_hwmon_pwm1(struct de
 	if (err < 0)
 		return err;
 
-	value |= 0xFF;
+	value &= 0xFF;
 
 	if (value == 1) /* Low Speed */
 		value = 85;
@@ -869,7 +869,7 @@ static mode_t asus_hwmon_sysfs_is_visibl
 		 * - reverved bits are non-zero
 		 * - sfun and presence bit are not set
 		 */
-		if (value != ASUS_WMI_UNSUPPORTED_METHOD || value & 0xFFF80000
+		if (value == ASUS_WMI_UNSUPPORTED_METHOD || value & 0xFFF80000
 		    || (!asus->sfun && !(value & ASUS_WMI_DSTS_PRESENCE_BIT)))
 			ok = false;
 	}
@@ -904,6 +904,7 @@ static int asus_wmi_hwmon_init(struct as
 		pr_err("Could not register asus hwmon device\n");
 		return PTR_ERR(hwmon);
 	}
+	dev_set_drvdata(hwmon, asus);
 	asus->hwmon_device = hwmon;
 	result = sysfs_create_group(&hwmon->kobj, &hwmon_attribute_group);
 	if (result)


