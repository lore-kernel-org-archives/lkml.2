Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030734Ab2CFTqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 14:46:07 -0500
Received: from smtp-out-040.synserver.de ([212.40.185.40]:1098 "EHLO
	smtp-out-004.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965234Ab2CFTqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 14:46:05 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 23761
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] staging:iio: Fix compile error without CONFIG_DEBUG_FS
Date: Tue,  6 Mar 2012 20:43:45 +0100
Message-Id: <1331063025-25242-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <4F565CB0.8070301@xenotime.net>
References: <4F565CB0.8070301@xenotime.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e553f182d ("staging: iio: core: Introduce debugfs support, add support
for direct register access") added a '#if defined(CONFIG_DEBUG_FS)' around
iio_read_channel_ext_info and iio_write_channel_ext_info causing the following
compile error if CONFIG_DEBUG_FS is not defined.

	drivers/staging/iio/industrialio-core.c:621:11: error: 'iio_read_channel_ext_info' undeclared (first use in this function)
	drivers/staging/iio/industrialio-core.c:623:11: error: 'iio_write_channel_ext_info' undeclared (first use in this function)

This patch fixes the issue by moving the functions out of the '#if
defined(CONFIG_DEBUG_FS)' section again.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/staging/iio/industrialio-core.c |   54 +++++++++++++++---------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 27695df..d303bfb 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -227,33 +227,6 @@ static void iio_device_unregister_debugfs(struct iio_dev *indio_dev)
 	debugfs_remove_recursive(indio_dev->debugfs_dentry);
 }
 
-static ssize_t iio_read_channel_ext_info(struct device *dev,
-				     struct device_attribute *attr,
-				     char *buf)
-{
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-	const struct iio_chan_spec_ext_info *ext_info;
-
-	ext_info = &this_attr->c->ext_info[this_attr->address];
-
-	return ext_info->read(indio_dev, this_attr->c, buf);
-}
-
-static ssize_t iio_write_channel_ext_info(struct device *dev,
-				     struct device_attribute *attr,
-				     const char *buf,
-					 size_t len)
-{
-	struct iio_dev *indio_dev = dev_get_drvdata(dev);
-	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
-	const struct iio_chan_spec_ext_info *ext_info;
-
-	ext_info = &this_attr->c->ext_info[this_attr->address];
-
-	return ext_info->write(indio_dev, this_attr->c, buf, len);
-}
-
 static int iio_device_register_debugfs(struct iio_dev *indio_dev)
 {
 	struct dentry *d;
@@ -297,6 +270,33 @@ static void iio_device_unregister_debugfs(struct iio_dev *indio_dev)
 }
 #endif /* CONFIG_DEBUG_FS */
 
+static ssize_t iio_read_channel_ext_info(struct device *dev,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	const struct iio_chan_spec_ext_info *ext_info;
+
+	ext_info = &this_attr->c->ext_info[this_attr->address];
+
+	return ext_info->read(indio_dev, this_attr->c, buf);
+}
+
+static ssize_t iio_write_channel_ext_info(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf,
+					 size_t len)
+{
+	struct iio_dev *indio_dev = dev_get_drvdata(dev);
+	struct iio_dev_attr *this_attr = to_iio_dev_attr(attr);
+	const struct iio_chan_spec_ext_info *ext_info;
+
+	ext_info = &this_attr->c->ext_info[this_attr->address];
+
+	return ext_info->write(indio_dev, this_attr->c, buf, len);
+}
+
 static ssize_t iio_read_channel_info(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
-- 
1.7.2.5

