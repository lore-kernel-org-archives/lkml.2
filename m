Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890Ab2BJXKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:10:34 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668Ab2BJWmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:51 -0500
MIME-Version: 1.0
Message-Id: <20120210222948.330553230@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:56 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [patch 37/86] PM / Hibernate: Thaw kernel threads in SNAPSHOT_CREATE_IMAGE ioctl path
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>

commit fe9161db2e6053da21e4649d77bbefaf3030b11d upstream.

In the SNAPSHOT_CREATE_IMAGE ioctl, if the call to hibernation_snapshot()
fails, the frozen tasks are not thawed.

And in the case of success, if we happen to exit due to a successful freezer
test, all tasks (including those of userspace) are thawed, whereas actually
we should have thawed only the kernel threads at that point. Fix both these
issues.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/power/user.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -283,13 +283,15 @@ static long snapshot_ioctl(struct file *
 		}
 		pm_restore_gfp_mask();
 		error = hibernation_snapshot(data->platform_support);
-		if (!error) {
+		if (error) {
+			thaw_kernel_threads();
+		} else {
 			error = put_user(in_suspend, (int __user *)arg);
 			if (!error && !freezer_test_done)
 				data->ready = 1;
 			if (freezer_test_done) {
 				freezer_test_done = false;
-				thaw_processes();
+				thaw_kernel_threads();
 			}
 		}
 		break;


