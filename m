Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab2AHUst (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 15:48:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50774 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492Ab2AHUsq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 15:48:46 -0500
Message-ID: <1326055714.13595.309.camel@deadeye>
Subject: [PATCH 1/2] topology: Check for missing CPU devices
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Thorsten Glaser <tg@mirbsd.de>,
        Debian kernel team <debian-kernel@lists.debian.org>,
        linux-m68k@vger.kernel.org, debian-68k@lists.debian.org
Date: Sun, 08 Jan 2012 20:48:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ccbc60d3e19a1b6ae66ca0d89b3da02dde62088b ('topology: Provide
CPU topology in sysfs in !SMP configurations') causes a crash at boot
on a several architectures.  The topology sysfs code assumes that
there is a CPU device for each online CPU whereas some architectures
that do not support SMP or cpufreq do not register any CPU devices.
Check for this before trying to use a device.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/base/topology.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index ae989c5..4467c85 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -147,6 +147,8 @@ static int __cpuinit topology_add_dev(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
 
+	if (!dev)
+		return -ENODEV;
 	return sysfs_create_group(&dev->kobj, &topology_attr_group);
 }
 
@@ -154,7 +156,8 @@ static void __cpuinit topology_remove_dev(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
 
-	sysfs_remove_group(&dev->kobj, &topology_attr_group);
+	if (dev)
+		sysfs_remove_group(&dev->kobj, &topology_attr_group);
 }
 
 static int __cpuinit topology_cpu_callback(struct notifier_block *nfb,
-- 
1.7.8.2



