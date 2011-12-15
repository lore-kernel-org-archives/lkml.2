Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703Ab1LOJXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 04:23:18 -0500
Received: from mail01.manz-automation.com ([88.79.234.227]:57407 "EHLO
	mail01.manz-automation.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752667Ab1LOJXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 04:23:16 -0500
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Dec 2011 04:23:15 EST
Message-ID: <1323940664.16032.6.camel@raz>
Subject: Subject:[PATCH 1:1] boot paramer "root=" gets a list of devices
From: Raz Ben Yehuda <rbenyehuda@manz.com>
Reply-To: rbenyehuda@manz.com
To: <linux-kernel@vger.kernel.org>
Date: Thu, 15 Dec 2011 11:17:44 +0200
Organization: Manz
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Raz ben yehuda <rbenyehuda@manz.com>

Patch is aimed to bypass the need for initramfs when it is not
known which disk has the root file system.

Example: The kernel boot parameter "root=/dev/sda1,/dev/sdc1,/dev/sdb4".
Check if /dev/sda1 exists ,if /dev/sda1 does not exist then try
/dev/sdc1 an so on upto the first a device that exists ( ROOT_DEV != 0 ), 
else use the last device as the mount device.

Signed-off-by: Raz Ben Yehuda <rbenyehuda@manz.com>

---

diff --git a/init/do_mounts.c b/init/do_mounts.c
index 0f6e1d9..02ed235 100644
--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -162,9 +162,10 @@ done:
  *         of partition - device number of disk plus the partition number
  *	5) /dev/<disk_name>p<decimal> - same as the above, that form is
  *	   used when disk name of partitioned disk ends on a digit.
- *	6) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
+ *	6) /dev/<disk name><decimal>,/dev/<disk name><decimal>,...
+ *	7) PARTUUID=00112233-4455-6677-8899-AABBCCDDEEFF representing the
  *	   unique id of a partition if the partition table provides it.
- *	7) PARTUUID=<UUID>/PARTNROFF=<int> to select a partition in relation to
+ *	8) PARTUUID=<UUID>/PARTNROFF=<int> to select a partition in relation to
  *	   a partition with a known unique id.
  *
  *	If name doesn't have fall into the categories above, we return (0,0).
@@ -469,6 +470,63 @@ void __init mount_root(void)
 #endif
 }
 
+void scan_root_dev_list(void)
+{
+	char *root_device_eol;
+	char *tmp_dev_name = saved_root_name;
+	char *comma;
+
+	comma = root_device_name;
+	root_device_eol = root_device_name + strlen(root_device_name);
+
+	for (; comma != root_device_eol ;) {
+		char dev_name[64];
+		/*
+		 * scan for active device from
+		 * root=/dev/sda1,/dev/sda2,...
+		*/
+		comma = strchr(tmp_dev_name, ',');
+		if (!comma) {
+			/*
+			 * if there is no list of devices
+			 * ( root=/dev/sdaX) or we are at the end
+			*/
+			root_device_name = tmp_dev_name;
+			ROOT_DEV = name_to_dev_t(root_device_name);
+			printk(KERN_INFO "trying device %s\n",
+				root_device_name);
+			break;
+		}
+		/*
+		 * ok, we failed with first device,
+		 * move to next one in the comma separated list
+		 */
+		memset(dev_name, 0, sizeof(dev_name));
+		strncpy(dev_name, tmp_dev_name,
+					(long)comma - (long)tmp_dev_name);
+		ROOT_DEV = name_to_dev_t(dev_name);
+		printk(KERN_INFO "trying device %s\n", dev_name);
+		if (ROOT_DEV == 0) {
+			tmp_dev_name = comma + 1;
+			if (tmp_dev_name < root_device_eol)
+				continue;
+			break;
+		}
+		/*
+		 * we're lucky, we have a device,
+		 * let set root_device_name to point at it
+		*/
+		strcpy(root_device_name, dev_name);
+		break;
+	}
+	if (ROOT_DEV == 0) {
+		printk(KERN_INFO "kernel is likely to panic aiee..\n");
+		return;
+	}
+	printk(KERN_INFO "Found %s appropriate for boot\n",
+		root_device_name);
+}
+
 /*
  * Prepare the namespace - decide what/where to mount, load ramdisks, etc.
  */
@@ -500,10 +558,10 @@ void __init prepare_namespace(void)
 			mount_block_root(root_device_name, root_mountflags);
 			goto out;
 		}
-		ROOT_DEV = name_to_dev_t(root_device_name);
-		if (strncmp(root_device_name, "/dev/", 5) == 0)
-			root_device_name += 5;
+		scan_root_dev_list();
 	}
+	if (strncmp(root_device_name, "/dev/", 5) == 0)
+			root_device_name += 5;
 
 	if (initrd_load())
 		goto out;


