Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933144Ab2BAV6x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:58:53 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45791 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539Ab2BAVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:07:43 -0500
X-Sasl-enc: NSVViVD//dLAGg1Qab8JEn6HE87bwJ2JC3wTrtrNINPb 1328130462
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:15:31 2012
Message-Id: <20120201201531.200570434@clark.kroah.org>
User-Agent: quilt/0.51-14.1
Date: Wed, 01 Feb 2012 12:14:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tyler Hicks <tyhicks@canonical.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [01/20] eCryptfs: Sanitize write counts of /dev/ecryptfs
In-Reply-To: <20120201210055.GA25374@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Tyler Hicks <tyhicks@canonical.com>

commit db10e556518eb9d21ee92ff944530d84349684f4 upstream.

A malicious count value specified when writing to /dev/ecryptfs may
result in a a very large kernel memory allocation.

This patch peeks at the specified packet payload size, adds that to the
size of the packet headers and compares the result with the write count
value. The resulting maximum memory allocation size is approximately 532
bytes.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ecryptfs/miscdev.c |   56 +++++++++++++++++++++++++++++++++-----------------
 1 file changed, 38 insertions(+), 18 deletions(-)

--- a/fs/ecryptfs/miscdev.c
+++ b/fs/ecryptfs/miscdev.c
@@ -408,11 +408,47 @@ ecryptfs_miscdev_write(struct file *file
 	ssize_t sz = 0;
 	char *data;
 	uid_t euid = current_euid();
+	unsigned char packet_size_peek[3];
 	int rc;
 
-	if (count == 0)
+	if (count == 0) {
 		goto out;
+	} else if (count == (1 + 4)) {
+		/* Likely a harmless MSG_HELO or MSG_QUIT - no packet length */
+		goto memdup;
+	} else if (count < (1 + 4 + 1)
+		   || count > (1 + 4 + 2 + sizeof(struct ecryptfs_message) + 4
+			       + ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES)) {
+		printk(KERN_WARNING "%s: Acceptable packet size range is "
+		       "[%d-%lu], but amount of data written is [%zu].",
+		       __func__, (1 + 4 + 1),
+		       (1 + 4 + 2 + sizeof(struct ecryptfs_message) + 4
+			+ ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES), count);
+		return -EINVAL;
+	}
+
+	if (copy_from_user(packet_size_peek, (buf + 1 + 4),
+			   sizeof(packet_size_peek))) {
+		printk(KERN_WARNING "%s: Error while inspecting packet size\n",
+		       __func__);
+		return -EFAULT;
+	}
 
+	rc = ecryptfs_parse_packet_length(packet_size_peek, &packet_size,
+					  &packet_size_length);
+	if (rc) {
+		printk(KERN_WARNING "%s: Error parsing packet length; "
+		       "rc = [%d]\n", __func__, rc);
+		return rc;
+	}
+
+	if ((1 + 4 + packet_size_length + packet_size) != count) {
+		printk(KERN_WARNING "%s: Invalid packet size [%zu]\n", __func__,
+		       packet_size);
+		return -EINVAL;
+	}
+
+memdup:
 	data = memdup_user(buf, count);
 	if (IS_ERR(data)) {
 		printk(KERN_ERR "%s: memdup_user returned error [%ld]\n",
@@ -434,23 +470,7 @@ ecryptfs_miscdev_write(struct file *file
 		}
 		memcpy(&counter_nbo, &data[i], 4);
 		seq = be32_to_cpu(counter_nbo);
-		i += 4;
-		rc = ecryptfs_parse_packet_length(&data[i], &packet_size,
-						  &packet_size_length);
-		if (rc) {
-			printk(KERN_WARNING "%s: Error parsing packet length; "
-			       "rc = [%d]\n", __func__, rc);
-			goto out_free;
-		}
-		i += packet_size_length;
-		if ((1 + 4 + packet_size_length + packet_size) != count) {
-			printk(KERN_WARNING "%s: (1 + packet_size_length([%zd])"
-			       " + packet_size([%zd]))([%zd]) != "
-			       "count([%zd]). Invalid packet format.\n",
-			       __func__, packet_size_length, packet_size,
-			       (1 + packet_size_length + packet_size), count);
-			goto out_free;
-		}
+		i += 4 + packet_size_length;
 		rc = ecryptfs_miscdev_response(&data[i], packet_size,
 					       euid, current_user_ns(),
 					       task_pid(current), seq);


