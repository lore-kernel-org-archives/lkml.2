Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031127Ab2I1TZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:25:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63006 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030396Ab2I1TDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 178/262] PM / Runtime: Check device PM QoS setting before "no callbacks" check
Date: Fri, 28 Sep 2012 11:51:47 -0700
Message-Id: <20120928183019.083781833@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit 55d7ec4520e86d735d178c15d7df33d507bd43c6 upstream.

If __dev_pm_qos_read_value(dev) returns a negative value,
rpm_suspend() should return -EPERM for dev even if its
power.no_callbacks flag is set.  For this to happen, the device's
power.no_callbacks flag has to be checked after the PM QoS check,
so move the PM QoS check to rpm_check_suspend_allowed() (this will
make it cover idle notifications as well as runtime suspend too).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/power/runtime.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -147,6 +147,8 @@ static int rpm_check_suspend_allowed(str
 	    || (dev->power.request_pending
 			&& dev->power.request == RPM_REQ_RESUME))
 		retval = -EAGAIN;
+	else if (__dev_pm_qos_read_value(dev) < 0)
+		retval = -EPERM;
 	else if (dev->power.runtime_status == RPM_SUSPENDED)
 		retval = 1;
 
@@ -402,12 +404,6 @@ static int rpm_suspend(struct device *de
 		goto out;
 	}
 
-	if (__dev_pm_qos_read_value(dev) < 0) {
-		/* Negative PM QoS constraint means "never suspend". */
-		retval = -EPERM;
-		goto out;
-	}
-
 	__update_runtime_status(dev, RPM_SUSPENDING);
 
 	if (dev->pm_domain)


