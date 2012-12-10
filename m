Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751700Ab2LJWY4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:24:56 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:58123 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2LJWYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:24:55 -0500
Date: Mon, 10 Dec 2012 17:23:13 -0500
From: "Gabriel L. Somlo" <somlo@cmu.edu>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Guenter Roeck <groeck-dsl@sbcglobal.net>, khali@linux-fr.org,
        linux@roeck-us.net, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, agraf@suse.de, rene@exactcode.com
Subject: [PATCH v2] applesmc: add sysfs file to report OSK
Message-ID: <20121210222313.GF2097@hedwig.ini.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210195414.GA642@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NEG_0500 0, FROM_EDU_TLD 0, __ANY_URI 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __PHISH_SPEAR_STRUCTURE_1 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __USER_AGENT 0)
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

Henrik,

On Mon, Dec 10, 2012 at 09:19:51PM +0100, Alexander Graf wrote:
>
> On Mon, Dec 10, 2012 at 08:54:14PM +0100, Henrik Rydberg wrote:
> >
> > The OSK string seems constant accross machines, which renders the
> > patch rather pointless, no? And even if the OSK differs between a
> > couple of machines, the emulator could easily handle it gracefully.
>
> The point is that the return value of the OSK is a copyrighted string,
> we can not include in any other layer. The only way to make this
> legally savvy is to   read the key from the host.

I believe this second version addresses your stylistic objections.

As Alex pointed out, hardcoding the OSK in any open-source project
might lead to legal/copyright related issues, whereas simply reporting
whatever the the hardware happens to contain should keep everyone safe.

As for struct applesmc_node_group info_group[]:

> > Unfortunately this is not a good place to put random things going
> > forward.

I figured "info_group" for the "least bad" place to put the OSK, given
that it's more or less "information from/about the SMC". If you could be
persuaded by the above arguments to accept the patch, and have a better
place in mind, I'd be happy to move it there...

Thanks again,
 Gabriel

 drivers/hwmon/applesmc.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b41baff..b37b271 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -1013,6 +1013,24 @@ static ssize_t applesmc_key_at_index_store(struct device *dev,
 	return count;
 }
 
+static ssize_t applesmc_osk_show(struct device *dev,
+				struct device_attribute *attr, char *sysfsbuf)
+{
+	int ret;
+	char buf[65];
+
+	mutex_lock(&smcreg.mutex);
+	ret = read_smc(APPLESMC_READ_CMD, "OSK0", buf, 32);
+	if (!ret)
+		ret = read_smc(APPLESMC_READ_CMD, "OSK1", buf + 32, 32);
+	mutex_unlock(&smcreg.mutex);
+	if (ret)
+		return ret;
+
+	buf[64] = '\0';
+	return snprintf(sysfsbuf, PAGE_SIZE, "%s\n", buf);
+}
+
 static struct led_classdev applesmc_backlight = {
 	.name			= "smc::kbd_backlight",
 	.default_trigger	= "nand-disk",
@@ -1027,6 +1045,7 @@ static struct applesmc_node_group info_group[] = {
 	{ "key_at_index_type", applesmc_key_at_index_type_show },
 	{ "key_at_index_data_length", applesmc_key_at_index_data_length_show },
 	{ "key_at_index_data", applesmc_key_at_index_read_show },
+	{ "osk", applesmc_osk_show },
 	{ }
 };
 
-- 
1.7.7.6

