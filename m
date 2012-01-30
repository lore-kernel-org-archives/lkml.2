Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2A3Vy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:54:28 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59677 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab2A3Vy0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:54:26 -0500
Message-ID: <4F271188.3060107@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 03:24:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "pavel@ucw.cz" <pavel@ucw.cz>, "len.brown@intel.com" <len.brown@intel.com>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] PM/Hibernate: Thaw kernel threads in SNAPSHOT_CREATE_IMAGE
 ioctl path
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12013021-3864-0000-0000-0000012D68E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the SNAPSHOT_CREATE_IMAGE ioctl, if the call to hibernation_snapshot()
fails, the frozen tasks are not thawed.

And in the case of success, if we happen to exit due to a successful freezer
test, all tasks (including those of userspace) are thawed, whereas actually
we should have thawed only the kernel threads at that point. Fix both these
issues.

Cc: stable@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---
This applies on top of the patch posted at https://lkml.org/lkml/2012/1/27/501

 kernel/power/user.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/power/user.c b/kernel/power/user.c
index e5a21a8..3e10007 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -249,13 +249,15 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
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


