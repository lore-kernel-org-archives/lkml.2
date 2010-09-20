Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755874Ab0ITM7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 08:59:13 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50442 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111Ab0ITM7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 08:59:12 -0400
Subject: [PATCH] drm/sysfs: Provide per connector control of DRM KMS polling
From: Andy Walls <awalls@md.metrocast.net>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Dave Airlie <airlied@redhat.com>,
        Jon Smirl <jonsmirl@gmail.com>, Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 08:59:00 -0400
Message-ID: <1284987540.2242.29.camel@morgan.silverblock.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-20_06:2010-09-20,2010-09-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009200046
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRM KMS polling of connections providing errant EDID responses, or
polling of "connectors" that have chips responding on DDC I2C bus
address 0xA0/0xA1 with no actual physical connector nor EDID EEPROM,
will create perpetual noise in dmesg and the system log every 10
seconds.  Currently the user has apparently little recourse to silence
these messages aside from replacing the offending cable, monitor, or
graphics adapter.  That recourse is impossible for an unused DVI-D
"connector" of an internal graphics processor on a motherboard that
provides no physical DVI-D connector.

This change allows the root user to disable (and re-enable) DRM KMS
connector polling on a per connector basis via sysfs, like so:

        # cat /sys/class/drm/card0/card0-DVI-D-1/polled
        [hotplug_detectable] connect disconnect
        
        # echo > /sys/class/drm/card0/card0-DVI-D-1/polled
        # cat /sys/class/drm/card0/card0-DVI-D-1/polled
        hotplug_detectable connect disconnect
        
        # echo " connect  hotplug_detectable " > \
        	/sys/class/drm/card0/card0-DVI-D-1/polled
        # cat /sys/class/drm/card0/card0-DVI-D-1/polled
        [hotplug_detectable] [connect] disconnect
        
        # echo > /sys/class/drm/card0/card0-DVI-D-1/polled
        # cat /sys/class/drm/card0/card0-DVI-D-1/polled
        hotplug_detectable connect disconnect

with the enabled poll types for the connector denoted in brackets: [].
This allows the root user to silence DRM KMS log spam for locally known
uncorrectable conditions.

Signed-off-by Andy Walls <awalls@md.metrocast.net>

diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 86118a7..8e0807d 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -318,11 +318,80 @@ static ssize_t select_subconnector_show(struct device *device,
 			drm_get_dvi_i_select_name((int)subconnector));
 }
 
+static const struct {
+	uint8_t mask;
+	const char *name;
+} polled_bit_names[] = {
+	{ DRM_CONNECTOR_POLL_HPD,        "hotplug_detectable" },
+	{ DRM_CONNECTOR_POLL_CONNECT,    "connect"            },
+	{ DRM_CONNECTOR_POLL_DISCONNECT, "disconnect"         },
+};
+
+/*
+ * Return the decoded contents of connector->polled, using the names of the
+ * all the bit masks.  Bits that are set, have their names enclosed in brackets.
+ */
+static ssize_t polled_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct drm_connector *connector = to_drm_connector(dev);
+	char *tmp;
+	int i;
+
+	tmp = buf;
+	for (i = 0; i < ARRAY_SIZE(polled_bit_names); i++) {
+		if (connector->polled & polled_bit_names[i].mask)
+			tmp += sprintf(tmp, "[%s] ", polled_bit_names[i].name);
+		else
+			tmp += sprintf(tmp, "%s ", polled_bit_names[i].name);
+	}
+
+	if (tmp != buf)
+		*(tmp - 1) = '\n';
+	return tmp - buf;
+}
+
+/*
+ * Change the state of connector->polled, given input bit-mask name-strings
+ * that are separated by space or newline.
+ */
+static ssize_t polled_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct drm_connector *connector = to_drm_connector(dev);
+	const char *tmp;
+	int i;
+	uint8_t polled;
+
+	/* Polling of this connector will cease, if no match is made below */
+	polled = 0;
+
+	/* Incrementally split and parse the input */
+	while ((tmp = strsep((char **) &buf, " \n")) != NULL) {
+
+		/* Don't waste effort on multiple adjacent separators */
+		if (*tmp == '\0')
+			continue;
+
+		/* Check for a match with a connector poll type name */
+		for (i = 0; i < ARRAY_SIZE(polled_bit_names); i++) {
+			if (!strncasecmp(tmp, polled_bit_names[i].name,
+					 strlen(polled_bit_names[i].name))) {
+				polled |= polled_bit_names[i].mask;
+				break;
+			}
+		}
+	}
+	connector->polled = polled;
+	return count;
+}
+
 static struct device_attribute connector_attrs[] = {
 	__ATTR_RO(status),
 	__ATTR_RO(enabled),
 	__ATTR_RO(dpms),
 	__ATTR_RO(modes),
+	__ATTR(polled, 0644, polled_show, polled_store),
 };
 
 /* These attributes are for both DVI-I connectors and all types of tv-out. */


