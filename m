Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab2IQA47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:56:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33928 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753957Ab2IQAv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:51:28 -0400
Message-Id: <20120917003631.247940408@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:01 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 036/135] powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Blanchard <anton@samba.org>

commit 1b6ca2a6fe56e7697d57348646e07df08f43b1bb upstream.

Writing to dscr_default in sysfs doesn't actually change the DSCR -
we rely on a context switch on each CPU to do the work. There is no
guarantee we will get a context switch in a reasonable amount of time
so fire off an IPI to force an immediate change.

This issue was found with the following test case:

http://ozlabs.org/~anton/junkcode/dscr_explicit_test.c

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/kernel/sysfs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -192,6 +192,12 @@ static ssize_t show_dscr_default(struct
 	return sprintf(buf, "%lx\n", dscr_default);
 }
 
+static void update_dscr(void *dummy)
+{
+	if (!current->thread.dscr_inherit)
+		mtspr(SPRN_DSCR, dscr_default);
+}
+
 static ssize_t __used store_dscr_default(struct sysdev_class *class,
 		struct sysdev_class_attribute *attr, const char *buf,
 		size_t count)
@@ -204,6 +210,8 @@ static ssize_t __used store_dscr_default
 		return -EINVAL;
 	dscr_default = val;
 
+	on_each_cpu(update_dscr, NULL, 1);
+
 	return count;
 }
 


