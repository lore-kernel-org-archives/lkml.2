Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676Ab2AJW5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:57:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647Ab2AJW5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:57:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:18 2012
Message-Id: <20120110214618.502109551@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Neil Horman <nhorman@tuxdriver.com>
Subject: [03/40] firmware: Fix an oops on reading fw_priv->fw in sysfs loading file
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Horman <nhorman@tuxdriver.com>

commit eea915bb0d1358755f151eaefb8208a2d5f3e10c upstream.

This oops was reported recently:
firmware_loading_store+0xf9/0x17b
dev_attr_store+0x20/0x22
sysfs_write_file+0x101/0x134
vfs_write+0xac/0xf3
sys_write+0x4a/0x6e
system_call_fastpath+0x16/0x1b

The complete backtrace was unfortunately not captured, but details can be found
here:
https://bugzilla.redhat.com/show_bug.cgi?id=769920

The cause is fairly clear.

Its caused by the fact that firmware_loading_store has a case 0 in its
switch statement that reads and writes the fw_priv->fw poniter without the
protection of the fw_lock mutex.  since there is a window between the time that
_request_firmware sets fw_priv->fw to NULL and the time the corresponding sysfs
file is unregistered, its possible for a user space application to race in, and
write a zero to the loading file, causing a NULL dereference in
firmware_loading_store.  Fix it by extending the protection of the fw_lock mutex
to cover all of the firware_loading_store function.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/base/firmware_class.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -226,13 +226,13 @@ static ssize_t firmware_loading_store(st
 	int loading = simple_strtol(buf, NULL, 10);
 	int i;
 
+	mutex_lock(&fw_lock);
+
+	if (!fw_priv->fw)
+		goto out;
+
 	switch (loading) {
 	case 1:
-		mutex_lock(&fw_lock);
-		if (!fw_priv->fw) {
-			mutex_unlock(&fw_lock);
-			break;
-		}
 		firmware_free_data(fw_priv->fw);
 		memset(fw_priv->fw, 0, sizeof(struct firmware));
 		/* If the pages are not owned by 'struct firmware' */
@@ -243,7 +243,6 @@ static ssize_t firmware_loading_store(st
 		fw_priv->page_array_size = 0;
 		fw_priv->nr_pages = 0;
 		set_bit(FW_STATUS_LOADING, &fw_priv->status);
-		mutex_unlock(&fw_lock);
 		break;
 	case 0:
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {
@@ -274,7 +273,8 @@ static ssize_t firmware_loading_store(st
 		fw_load_abort(fw_priv);
 		break;
 	}
-
+out:
+	mutex_unlock(&fw_lock);
 	return count;
 }
 


