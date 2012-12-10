Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab2LJPDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 10:03:13 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:38320 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab2LJPDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 10:03:12 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2012 10:03:12 EST
Date: Mon, 10 Dec 2012 09:51:35 -0500
From: "Gabriel L. Somlo" <somlo@cmu.edu>
To: rydberg@euromail.se, khali@linux-fr.org, linux@roeck-us.net,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: agraf@suse.de, rene@exactcode.com
Subject: [PATCH] applesmc: add sysfs file to report OSK
Message-ID: <20121210145134.GA2097@hedwig.ini.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, FROM_EDU_TLD 0, TO_NO_NAME 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_STRUCTURE_1 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AppleSMC contains two char[32] keys, OSK0 and OSK1, which are not
reported in the key count and index by default. These keys are used by
the OS X boot sequence, and normally don't matter when running Linux.

This patch creates a sysfs entry which reports the value of these keys
as an ASCII string, to help emulators (such as QEMU) load OS X when
running on genuine Apple hardware.

Signed-off-by: Gabriel L. Somlo <somlo@cmu.edu>
---

For extra context: To boot OS X as a guest, QEMU must (among others)
emulate the AppleSMC. To boot successfully, OS X insists on querying
the (emulated) SMC for the value of OSK0 and OSK1. Currently, these
values must be supplied on the QEMU command line as

  -device applesmc,osk="...concatenated values of OSK0 and OSK1..."

With the availability of /sys/devices/platform/applesmc.768/osk, the
emulated QEMU AppleSMC could acquire this string directly from the
(Apple-manufactured) host machine.

Thanks,
  Gabriel

 drivers/hwmon/applesmc.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b41baff..0c7cc71 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1013,6 +1013,23 @@ static ssize_t applesmc_key_at_index_store(struct device *dev,
 	return count;
 }
 
+static ssize_t applesmc_osk_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	int fail;
+
+	mutex_lock(&smcreg.mutex);
+	fail = read_smc(APPLESMC_READ_CMD, "OSK0", sysfsbuf, 32) ||
+	       read_smc(APPLESMC_READ_CMD, "OSK1", sysfsbuf + 32, 32);
+	mutex_unlock(&smcreg.mutex);
+	if (fail)
+		return -1;
+
+	sysfsbuf[64] = '\n';
+	sysfsbuf[65] = '\0';
+	return 65;
+}
+
 static struct led_classdev applesmc_backlight = {
 	.name			= "smc::kbd_backlight",
 	.default_trigger	= "nand-disk",
@@ -1027,6 +1044,7 @@ static struct applesmc_node_group info_group[] = {
 	{ "key_at_index_type", applesmc_key_at_index_type_show },
 	{ "key_at_index_data_length", applesmc_key_at_index_data_length_show },
 	{ "key_at_index_data", applesmc_key_at_index_read_show },
+	{ "osk", applesmc_osk_show },
 	{ }
 };
 
-- 
1.7.7.6

