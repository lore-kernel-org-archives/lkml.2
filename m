Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528Ab1KYK40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:56:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39435 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1KYK4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:56:25 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 1/1] iio: iio_event_getfd -- fix ev_int build failure
Date: Fri, 25 Nov 2011 10:56:22 +0000
Message-Id: <1322218582-4271-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build failure in staging iio driver:

.../drivers/staging/iio/industrialio-core.c: In function 'iio_event_getfd':
.../drivers/staging/iio/industrialio-core.c:262:32: error:
			'ev_int' undeclared (first use in this function)

Also convert the rest of the function to use the new variable.

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 drivers/staging/iio/industrialio-core.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 2656409..aec9311 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -242,25 +242,24 @@ static const struct file_operations iio_event_chrdev_fileops = {
 
 static int iio_event_getfd(struct iio_dev *indio_dev)
 {
+	struct iio_event_interface *ev_int = indio_dev->event_interface;
 	int fd;
 
-	if (indio_dev->event_interface == NULL)
+	if (ev_int == NULL)
 		return -ENODEV;
 
-	mutex_lock(&indio_dev->event_interface->event_list_lock);
-	if (test_and_set_bit(IIO_BUSY_BIT_POS,
-			     &indio_dev->event_interface->flags)) {
-		mutex_unlock(&indio_dev->event_interface->event_list_lock);
+	mutex_lock(&ev_int->event_list_lock);
+	if (test_and_set_bit(IIO_BUSY_BIT_POS, &ev_int->flags)) {
+		mutex_unlock(&ev_int->event_list_lock);
 		return -EBUSY;
 	}
-	mutex_unlock(&indio_dev->event_interface->event_list_lock);
+	mutex_unlock(&ev_int->event_list_lock);
 	fd = anon_inode_getfd("iio:event",
-				&iio_event_chrdev_fileops,
-				indio_dev->event_interface, O_RDONLY);
+				&iio_event_chrdev_fileops, ev_int, O_RDONLY);
 	if (fd < 0) {
-		mutex_lock(&indio_dev->event_interface->event_list_lock);
+		mutex_lock(&ev_int->event_list_lock);
 		clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
-		mutex_unlock(&indio_dev->event_interface->event_list_lock);
+		mutex_unlock(&ev_int->event_list_lock);
 	}
 	return fd;
 }
-- 
1.7.5.4

