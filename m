Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab1KXIvE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 03:51:04 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:58024 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460Ab1KXIvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 03:51:01 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
References: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1322043239-26082-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] iio: Fix build error in industrialio-core.c
From: Jonathan Cameron <jic23@cam.ac.uk>
Date: Thu, 24 Nov 2011 08:49:51 +0000
To: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Message-ID: <4e3c37a6-3777-4138-800b-f055f7caa8f3@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sasha Levin <levinsasha928@gmail.com> wrote:

>The error was introduced in commit b4641336 ("iio: fix a leak due to
>improper use of anon_inode_getfd()").
>
>Looks like the code wasn't even compile tested. Instead of just fixing
>the
>error I changed the function a bit to make it nicer.
Minimal change would have been slightly nicer but clean up is obvious so fine. Thanks for doing this.  Andrew m has a dirty build fix in NM but he will drop that when this hits.
>Cc: Jonathan Cameron <jic23@cam.ac.uk>
>Cc: Greg Kroah-Hartman <gregkh@suse.de>
>Cc: linux-iio@vger.kernel.org
>Cc: devel@driverdev.osuosl.org
>Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
>---
> drivers/staging/iio/industrialio-core.c |   21 ++++++++++-----------
> 1 files changed, 10 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/staging/iio/industrialio-core.c
>b/drivers/staging/iio/industrialio-core.c
>index 2656409..5367914 100644
>--- a/drivers/staging/iio/industrialio-core.c
>+++ b/drivers/staging/iio/industrialio-core.c
>@@ -242,25 +242,24 @@ static const struct file_operations
>iio_event_chrdev_fileops = {
> 
> static int iio_event_getfd(struct iio_dev *indio_dev)
> {
>+	struct iio_event_interface *ev_int = indio_dev->event_interface;
> 	int fd;
> 
>-	if (indio_dev->event_interface == NULL)
>+	if (ev_int == NULL)
> 		return -ENODEV;
> 
>-	mutex_lock(&indio_dev->event_interface->event_list_lock);
>-	if (test_and_set_bit(IIO_BUSY_BIT_POS,
>-			     &indio_dev->event_interface->flags)) {
>-		mutex_unlock(&indio_dev->event_interface->event_list_lock);
>+	mutex_lock(&ev_int->event_list_lock);
>+	if (test_and_set_bit(IIO_BUSY_BIT_POS, &ev_int->flags)) {
>+		mutex_unlock(&ev_int->event_list_lock);
> 		return -EBUSY;
> 	}
>-	mutex_unlock(&indio_dev->event_interface->event_list_lock);
>-	fd = anon_inode_getfd("iio:event",
>-				&iio_event_chrdev_fileops,
>-				indio_dev->event_interface, O_RDONLY);
>+	mutex_unlock(&ev_int->event_list_lock);
>+	fd = anon_inode_getfd("iio:event", &iio_event_chrdev_fileops,
>+				ev_int, O_RDONLY);
> 	if (fd < 0) {
>-		mutex_lock(&indio_dev->event_interface->event_list_lock);
>+		mutex_lock(&ev_int->event_list_lock);
> 		clear_bit(IIO_BUSY_BIT_POS, &ev_int->flags);
>-		mutex_unlock(&indio_dev->event_interface->event_list_lock);
>+		mutex_unlock(&ev_int->event_list_lock);
> 	}
> 	return fd;
> }
>-- 
>1.7.8.rc3

-- 
Sent from my Android phone 
with K-9 Mail. Please excuse my brevity.
