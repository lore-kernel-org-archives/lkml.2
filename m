Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab2ENQlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 12:41:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490Ab2ENQlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 12:41:11 -0400
Date: Mon, 14 May 2012 12:41:06 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Fedora Kernel Team <kernel-team@fedoraproject.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, Paul Mackerras <paulus@samba.org>
Subject: Remove empty /proc/device-tree when no openfirmware exists.
Message-ID: <20120514164106.GB4439@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Fedora Kernel Team <kernel-team@fedoraproject.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Paul Mackerras <paulus@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

distribution kernels might want to build in support for /proc/device-tree
for kernels that might end up running on hardware that doesn't support openfirmware.
This results in an empty /proc/device-tree existing.
Remove it if the OFW root node doesn't exist.

[This situation actually confuses grub2, resulting in install failures.
 grub2 sees the /proc/device-tree and picks the wrong install target
 cf. http://bzr.savannah.gnu.org/lh/grub/trunk/grub/annotate/4300/util/grub-install.in#L311
 grub should be more robust, but still, leaving an empty proc dir seems pointless. ]

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index 927cbd1..f060f28 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -233,6 +233,7 @@ void __init proc_device_tree_init(void)
 		return;
 	root = of_find_node_by_path("/");
 	if (root == NULL) {
+		remove_proc_entry("device-tree", NULL);
 		pr_debug("/proc/device-tree: can't find root\n");
 		return;
 	}
