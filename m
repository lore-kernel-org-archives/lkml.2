Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab2L1Twk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:52:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55060 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511Ab2L1TRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:17:36 -0500
Message-Id: <20121228190359.439576865@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:05:57 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alasdair G Kergon <agk@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: [ 147/173] dm ioctl: prevent unsafe change to dm_ioctl data_size
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alasdair G Kergon <agk@redhat.com>

commit e910d7ebecd1aac43125944a8641b6cb1a0dfabe upstream.

Abort dm ioctl processing if userspace changes the data_size parameter
after we validated it but before we finished copying the data buffer
from userspace.

The dm ioctl parameters are processed in the following sequence:
 1. ctl_ioctl() calls copy_params();
 2. copy_params() makes a first copy of the fixed-sized portion of the
    userspace parameters into the local variable "tmp";
 3. copy_params() then validates tmp.data_size and allocates a new
    structure big enough to hold the complete data and copies the whole
    userspace buffer there;
 4. ctl_ioctl() reads userspace data the second time and copies the whole
    buffer into the pointer "param";
 5. ctl_ioctl() reads param->data_size without any validation and stores it
    in the variable "input_param_size";
 6. "input_param_size" is further used as the authoritative size of the
    kernel buffer.

The problem is that userspace code could change the contents of user
memory between steps 2 and 4.  In particular, the data_size parameter
can be changed to an invalid value after the kernel has validated it.
This lets userspace force the kernel to access invalid kernel memory.

The fix is to ensure that the size has not changed at step 4.

This patch shouldn't have a security impact because CAP_SYS_ADMIN is
required to run this code, but it should be fixed anyway.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/dm-ioctl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index afd9598..a651d52 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1566,6 +1566,14 @@ static int copy_params(struct dm_ioctl __user *user, struct dm_ioctl **param)
 	if (copy_from_user(dmi, user, tmp.data_size))
 		goto bad;
 
+	/*
+	 * Abort if something changed the ioctl data while it was being copied.
+	 */
+	if (dmi->data_size != tmp.data_size) {
+		DMERR("rejecting ioctl: data size modified while processing parameters");
+		goto bad;
+	}
+
 	/* Wipe the user buffer so we do not return it to userspace */
 	if (secure_data && clear_user(user, tmp.data_size))
 		goto bad;


