Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1FTFqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 01:46:53 -0400
Received: from qmta06.westchester.pa.mail.comcast.net ([76.96.62.56]:34029
	"EHLO qmta06.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab1FTFpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 01:45:36 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 13/22] staging: usbip: userspace: usbip_unbind.c: implement using libsysfs
Date: Sun, 19 Jun 2011 22:44:43 -0700
Message-Id: <09b6a05d08a70e2a4a52fb04f2ab37a546d10937.1308547654.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify unbind to use libsysfs, and include a check to verify that the
device is actually using usbip-host before proceeding. The output
messages have been changed to be consistent with `usbip bind'.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_unbind.c |  123 +++++++++++++++++---
 1 files changed, 107 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_unbind.c b/drivers/staging/usbip/userspace/src/usbip_unbind.c
index 9978d38..d5a9ab6 100644
--- a/drivers/staging/usbip/userspace/src/usbip_unbind.c
+++ b/drivers/staging/usbip/userspace/src/usbip_unbind.c
@@ -16,10 +16,13 @@
  * along with this program. If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <sysfs/libsysfs.h>
+
+#include <errno.h>
 #include <stdio.h>
+#include <string.h>
 
 #include <getopt.h>
-#include <unistd.h>
 
 #include "usbip_common.h"
 #include "utils.h"
@@ -35,41 +38,129 @@ void usbip_unbind_usage(void)
 	printf("usage: %s", usbip_unbind_usage_string);
 }
 
-static int use_device_by_other(char *busid)
+static int unbind_device(char *busid)
 {
-	int rc;
-	int config;
+	char bus_type[] = "usb";
+	struct sysfs_driver *usbip_host_drv;
+	struct sysfs_device *dev;
+	struct dlist *devlist;
+	int verified = 0;
+	int rc, ret = -1;
+
+	char attr_name[] = "bConfigurationValue";
+	char sysfs_mntpath[SYSFS_PATH_MAX];
+	char busid_attr_path[SYSFS_PATH_MAX];
+	struct sysfs_attribute *busid_attr;
+	char *val = NULL;
+	int len;
+
+	/* verify the busid device is using usbip-host */
+	usbip_host_drv = sysfs_open_driver(bus_type, USBIP_HOST_DRV_NAME);
+	if (!usbip_host_drv) {
+		err("could not open %s driver: %s", USBIP_HOST_DRV_NAME,
+		    strerror(errno));
+		return -1;
+	}
+
+	devlist = sysfs_get_driver_devices(usbip_host_drv);
+	if (!devlist) {
+		err("%s is not in use by any devices", USBIP_HOST_DRV_NAME);
+		goto err_close_usbip_host_drv;
+	}
+
+	dlist_for_each_data(devlist, dev, struct sysfs_device) {
+		if (!strncmp(busid, dev->name, strlen(busid)) &&
+		    !strncmp(dev->driver_name, USBIP_HOST_DRV_NAME,
+			     strlen(USBIP_HOST_DRV_NAME))) {
+			verified = 1;
+			break;
+		}
+	}
+
+	if (!verified) {
+		err("device on busid %s is not using %s", busid,
+		    USBIP_HOST_DRV_NAME);
+		goto err_close_usbip_host_drv;
+	}
+
+	/*
+	 * NOTE: A read and write of an attribute value of the device busid
+	 * refers to must be done to start probing. That way a rebind of the
+	 * default driver for the device occurs.
+	 *
+	 * This seems very hackish and adds a lot of pointless code. I think it
+	 * should be done in the kernel by the driver after del_match_busid is
+	 * finished!
+	 */
+
+	rc = sysfs_get_mnt_path(sysfs_mntpath, SYSFS_PATH_MAX);
+	if (rc < 0) {
+		err("sysfs must be mounted: %s", strerror(errno));
+		return -1;
+	}
 
-	/* read and write the same config value to kick probing */
-	config = read_bConfigurationValue(busid);
-	if (config < 0) {
-		dbg("read bConfigurationValue of %s, failed", busid);
+	snprintf(busid_attr_path, sizeof(busid_attr_path), "%s/%s/%s/%s/%s/%s",
+		 sysfs_mntpath, SYSFS_BUS_NAME, bus_type, SYSFS_DEVICES_NAME,
+		 busid, attr_name);
+
+	/* read a device attribute */
+	busid_attr = sysfs_open_attribute(busid_attr_path);
+	if (!busid_attr) {
+		err("could not open %s/%s: %s", busid, attr_name,
+		    strerror(errno));
 		return -1;
 	}
 
+	if (sysfs_read_attribute(busid_attr) < 0) {
+		err("problem reading attribute: %s", strerror(errno));
+		goto err_out;
+	}
+
+	len = busid_attr->len;
+	val = malloc(len);
+	*val = *busid_attr->value;
+	sysfs_close_attribute(busid_attr);
+
+	/* notify driver of unbind */
 	rc = modify_match_busid(busid, 0);
 	if (rc < 0) {
-		dbg("del %s to match_busid, failed", busid);
+		err("unable to unbind device on %s", busid);
+		goto err_out;
+	}
+
+	/* write the device attribute */
+	busid_attr = sysfs_open_attribute(busid_attr_path);
+	if (!busid_attr) {
+		err("could not open %s/%s: %s", busid, attr_name,
+		    strerror(errno));
 		return -1;
 	}
 
-	rc = write_bConfigurationValue(busid, config);
+	rc = sysfs_write_attribute(busid_attr, val, len);
 	if (rc < 0) {
-		dbg("read bConfigurationValue of %s, failed", busid);
-		return -1;
+		err("problem writing attribute: %s", strerror(errno));
+		goto err_out;
 	}
+	sysfs_close_attribute(busid_attr);
+
+	ret = 0;
+	printf("unbind device on busid %s: complete\n", busid);
 
-	info("bind %s to other drivers than usbip, complete!", busid);
+err_out:
+	free(val);
+err_close_usbip_host_drv:
+	sysfs_close_driver(usbip_host_drv);
 
-	return 0;
+	return ret;
 }
 
 int usbip_unbind(int argc, char *argv[])
 {
 	static const struct option opts[] = {
 		{ "busid", required_argument, NULL, 'b' },
-		{ NULL, 0, NULL, 0 }
+		{ NULL,    0,                 NULL,  0  }
 	};
+
 	int opt;
 	int ret = -1;
 
@@ -81,7 +172,7 @@ int usbip_unbind(int argc, char *argv[])
 
 		switch (opt) {
 		case 'b':
-			ret = use_device_by_other(optarg);
+			ret = unbind_device(optarg);
 			goto out;
 		default:
 			goto err_out;
-- 
1.7.5.2

