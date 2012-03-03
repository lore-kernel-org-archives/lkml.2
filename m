Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2CCKGZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 05:06:25 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32994 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2CCKGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 05:06:23 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6637"; a="168841506"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 2/2] coccinelle: semantic patch for simple_open()
Date: Sat,  3 Mar 2012 02:06:20 -0800
Message-Id: <1330769180-22354-3-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.9.2.315.g25a78
In-Reply-To: <1330769180-22354-1-git-send-email-sboyd@codeaurora.org>
References: <1330769180-22354-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find instances of an open-coded simple_open() and replace them
with calls to simple_open().

Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This seems to eat the definition of simple_open() as well. Is there
a way to say only remove both the function and the reference to
the function so that libfs survives?

 scripts/coccinelle/api/simple_open.cocci |   34 ++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 scripts/coccinelle/api/simple_open.cocci

diff --git a/scripts/coccinelle/api/simple_open.cocci b/scripts/coccinelle/api/simple_open.cocci
new file mode 100644
index 0000000..956d04d
--- /dev/null
+++ b/scripts/coccinelle/api/simple_open.cocci
@@ -0,0 +1,34 @@
+// This removes an open coded simple_open() function
+// and replaces file operations references to the function
+// with simple_open() instead.
+//
+
+virtual patch
+virtual context
+
+@ open @
+identifier open_f;
+identifier i, f;
+@@
+-int open_f(struct inode *i, struct file *f)
+-{
+(
+-if (i->i_private)
+-f->private_data = i->i_private;
+|
+-f->private_data = i->i_private;
+)
+-return 0;
+-}
+
+@ has_open depends on open @
+identifier fops;
+identifier open.open_f;
+@@
+struct file_operations fops = {
+...
+-.open = open_f,
++.open = simple_open,
+...
+};
+
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

