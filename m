Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab1F2MkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:40:11 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:53609 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab1F2MkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:40:10 -0400
Date: Wed, 29 Jun 2011 14:40:08 +0200
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] xen: Add module alias to autoload backend drivers
Message-ID: <20110629124008.GB31038@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	xen-devel@lists.xensource.com,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the Xen backend drivers are assigned to a special bus type
xen-backend. This patch exports xen-backend:* names through modalias and
uevent to autoload them.

Signed-off-by: Bastian Blank <waldi@debian.org>
Acked-by: Ian Campbell <ian.campbell@citrix.com>
Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xenbus/xenbus_probe.c         |    3 ++-
 drivers/xen/xenbus/xenbus_probe_backend.c |    3 +++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 2ed0b04..bd2f90c 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -393,7 +393,8 @@ static ssize_t devtype_show(struct device *dev,
 static ssize_t modalias_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
-	return sprintf(buf, "xen:%s\n", to_xenbus_device(dev)->devicetype);
+	return sprintf(buf, "%s:%s\n", dev->bus->name,
+		       to_xenbus_device(dev)->devicetype);
 }
 
 struct device_attribute xenbus_dev_attrs[] = {
diff --git a/drivers/xen/xenbus/xenbus_probe_backend.c b/drivers/xen/xenbus/xenbus_probe_backend.c
index ec510e5..60adf91 100644
--- a/drivers/xen/xenbus/xenbus_probe_backend.c
+++ b/drivers/xen/xenbus/xenbus_probe_backend.c
@@ -107,6 +107,9 @@ static int xenbus_uevent_backend(struct device *dev,
 	if (xdev == NULL)
 		return -ENODEV;
 
+	if (add_uevent_var(env, "MODALIAS=xen-backend:%s", xdev->devicetype))
+		return -ENOMEM;
+
 	/* stuff we want to pass to /sbin/hotplug */
 	if (add_uevent_var(env, "XENBUS_TYPE=%s", xdev->devicetype))
 		return -ENOMEM;
-- 
1.7.5.4

