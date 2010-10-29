Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0J2Ekh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 00:40:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59273 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab0J2Ek3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 00:40:29 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4CCA50A1.8050609@np.css.fujitsu.com>
Date: Fri, 29 Oct 2010 13:42:09 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H.Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        LKLM <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] [x86, next] Add mce_ser interface in /sys/kernel/debug/mce/
 for test
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we want to test the part of mce handler for SRAO and SRAR,  we need to
have a test machine whose CPU supports MCG_SER_P. If we don't have such
machine, we can not test the part of mce handler for SRAO and SRAR.

With this interface we can test the part of mce handler for SRAO and SRAR
by setting mce_ser 1 on the machine which does not support MCG_SER_P.

Usage:
        if val == 1 or val == 0
           Set val to mce_ser.
        else
           Ser the original value to mce_ser.

Note:
    Please don't use mce_ser interface except mce test.
    Because when the real mce exception happened, the unsuitable set
    with this interface maybe change the real process of mce handler and
    lead to a different result.

This patch is tested on Intel64 on next-tree.

Signed-off-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   39 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8edb04d..ed10e76 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2158,6 +2158,8 @@ static int __init mcheck_disable(char *str)
 __setup("nomce", mcheck_disable);
 
 #ifdef CONFIG_DEBUG_FS
+static int org_mce_ser;
+
 struct dentry *mce_get_debugfs_dir(void)
 {
 	static struct dentry *dmce;
@@ -2193,9 +2195,39 @@ static int fake_panic_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(fake_panic_fops, fake_panic_get,
 			fake_panic_set, "%llu\n");
 
+/*
+ * mce_ser_get() can only get the current value of mce_ser. 
+ * The value may be not the original value of mce_ser on this machine.
+ * So please use mce_ser_set() to confirm the original value of mce_ser.
+ */
+static int mce_ser_get(void *data, u64 *val)
+{
+	*val = mce_ser;
+	return 0;
+}
+
+/* 
+ * Set the value of mce_ser with mce_ser_set().
+ * Parameter "u64 val" of mce_ser_set() :
+ *      val == 1 or 0 : mce_ser = val;
+ *      others        : set mce_ser with the original value of mce_ser.
+ */
+static int mce_ser_set(void *data, u64 val)
+{
+	if (val == 1 || val == 0)
+		mce_ser = val;
+	else
+		mce_ser = org_mce_ser;
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(mce_ser_fops, mce_ser_get,
+			mce_ser_set, "%llu\n");
+
 static int __init mcheck_debugfs_init(void)
 {
 	struct dentry *dmce, *ffake_panic;
+	struct dentry *fmce_ser = NULL;
 
 	dmce = mce_get_debugfs_dir();
 	if (!dmce)
@@ -2205,6 +2237,13 @@ static int __init mcheck_debugfs_init(void)
 	if (!ffake_panic)
 		return -ENOMEM;
 
+	org_mce_ser = mce_ser;
+
+	fmce_ser = debugfs_create_file("mce_ser", 0644, dmce, NULL,
+						&mce_ser_fops);
+	if (!fmce_ser)
+		return -ENOMEM;
+
 	return 0;
 }
 late_initcall(mcheck_debugfs_init);

