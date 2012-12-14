Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab2LNW2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:28:18 -0500
Received: from mail.kernel.org ([198.145.19.201]:38387 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232Ab2LNW2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:28:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Haren Myneni <haren@us.ibm.com>
Subject: [ 21/22] powerpc: Update DSCR on all CPUs when writing sysfs dscr_default
Date: Fri, 14 Dec 2012 14:26:06 -0800
Message-Id: <20121214222254.729285780@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222249.889051473@linuxfoundation.org>
References: <20121214222249.889051473@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Haren Myneni <haren@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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
 


