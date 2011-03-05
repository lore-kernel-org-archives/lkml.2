Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760483Ab1CEBAh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:00:37 -0500
Received: from kroah.org ([198.145.64.141]:50316 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759883Ab1CEBAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:00:30 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:38 2011
Message-Id: <20110305005638.771311301@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:55:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [43/73] ACPI / debugfs: Fix buffer overflows, double free
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 2949ad50711cc161721cf788711722eeeca33764 upstream.

File position is not controlled, it may lead to overwrites of arbitrary
kernel memory.  Also the code may kfree() the same pointer multiple
times.

One more flaw is still present: if multiple processes open the file then
all 3 static variables are shared, leading to various race conditions.
They should be moved to file->private_data.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Reviewed-by: Eugene Teo <eugeneteo@kernel.org>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/debugfs.c |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/drivers/acpi/debugfs.c
+++ b/drivers/acpi/debugfs.c
@@ -26,7 +26,9 @@ static ssize_t cm_write(struct file *fil
 			size_t count, loff_t *ppos)
 {
 	static char *buf;
-	static int uncopied_bytes;
+	static u32 max_size;
+	static u32 uncopied_bytes;
+
 	struct acpi_table_header table;
 	acpi_status status;
 
@@ -37,19 +39,24 @@ static ssize_t cm_write(struct file *fil
 		if (copy_from_user(&table, user_buf,
 				   sizeof(struct acpi_table_header)))
 			return -EFAULT;
-		uncopied_bytes = table.length;
-		buf = kzalloc(uncopied_bytes, GFP_KERNEL);
+		uncopied_bytes = max_size = table.length;
+		buf = kzalloc(max_size, GFP_KERNEL);
 		if (!buf)
 			return -ENOMEM;
 	}
 
-	if (uncopied_bytes < count) {
-		kfree(buf);
+	if (buf == NULL)
+		return -EINVAL;
+
+	if ((*ppos > max_size) ||
+	    (*ppos + count > max_size) ||
+	    (*ppos + count < count) ||
+	    (count > uncopied_bytes))
 		return -EINVAL;
-	}
 
 	if (copy_from_user(buf + (*ppos), user_buf, count)) {
 		kfree(buf);
+		buf = NULL;
 		return -EFAULT;
 	}
 
@@ -59,6 +66,7 @@ static ssize_t cm_write(struct file *fil
 	if (!uncopied_bytes) {
 		status = acpi_install_method(buf);
 		kfree(buf);
+		buf = NULL;
 		if (ACPI_FAILURE(status))
 			return -EINVAL;
 		add_taint(TAINT_OVERRIDDEN_ACPI_TABLE);


