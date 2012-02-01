Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab2BAV2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:28:47 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:63465 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab2BAVTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:22 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/bootup: During bootup suppress XENBUS: Unable to read cpu state
Date: Wed,  1 Feb 2012 16:16:40 -0500
Message-Id: <1328131000-13485-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1328131000-13485-1-git-send-email-konrad.wilk@oracle.com>
References: <1328131000-13485-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F29AC58.0052,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the initial domain starts, it prints (depending on the
amount of CPUs) a slew of
XENBUS: Unable to read cpu state
XENBUS: Unable to read cpu state
XENBUS: Unable to read cpu state
XENBUS: Unable to read cpu state

which provide no useful information - as the error is a valid
issue - but not on the initial domain. The reason is that the
XenStore is not accessible at that time (it is after all the
first guest) so the CPU hotplug watch cannot parse "availability/cpu"
attribute.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/cpu_hotplug.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/cpu_hotplug.c b/drivers/xen/cpu_hotplug.c
index 14e2d99..4dcfced 100644
--- a/drivers/xen/cpu_hotplug.c
+++ b/drivers/xen/cpu_hotplug.c
@@ -30,7 +30,8 @@ static int vcpu_online(unsigned int cpu)
 	sprintf(dir, "cpu/%u", cpu);
 	err = xenbus_scanf(XBT_NIL, dir, "availability", "%s", state);
 	if (err != 1) {
-		printk(KERN_ERR "XENBUS: Unable to read cpu state\n");
+		if (!xen_initial_domain())
+			printk(KERN_ERR "XENBUS: Unable to read cpu state\n");
 		return err;
 	}
 
-- 
1.7.7.5

