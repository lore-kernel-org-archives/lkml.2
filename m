Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab2ILXea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:34:30 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:59246 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab2ILXeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:34:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 078/108] powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
Date: Wed, 12 Sep 2012 16:29:16 -0700
Message-Id: <20120912232458.687292206@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/sysfs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/powerpc/kernel/sysfs.c
+++ b/arch/powerpc/kernel/sysfs.c
@@ -194,6 +194,12 @@ static ssize_t show_dscr_default(struct
 	return sprintf(buf, "%lx\n", dscr_default);
 }
 
+static void update_dscr(void *dummy)
+{
+	if (!current->thread.dscr_inherit)
+		mtspr(SPRN_DSCR, dscr_default);
+}
+
 static ssize_t __used store_dscr_default(struct device *dev,
 		struct device_attribute *attr, const char *buf,
 		size_t count)
@@ -206,6 +212,8 @@ static ssize_t __used store_dscr_default
 		return -EINVAL;
 	dscr_default = val;
 
+	on_each_cpu(update_dscr, NULL, 1);
+
 	return count;
 }
 


