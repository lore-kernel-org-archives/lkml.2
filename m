Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096Ab2FGEm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:42:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62777 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388Ab2FGESQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:18:16 -0400
Message-Id: <20120607040342.033014165@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:15 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 39/82] vfs: increment iversion when a file is truncated
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>

commit 799243a389bde0de10fa21ca1ca453d2fe538b85 upstream.

When a file is truncated with truncate()/ftruncate() and then closed,
iversion is not updated.  This patch uses ATTR_SIZE flag as an indication
to increment iversion.

Mimi said:

On fput(), i_version is used to detect and flag files that have changed
and need to be re-measured in the IMA measurement policy.  When a file
is truncated with truncate()/ftruncate() and then closed, i_version is
not updated.  As a result, although the file has changed, it will not be
re-measured and added to the IMA measurement list on subsequent access.

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Acked-by: Mimi Zohar <zohar@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/attr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,6 +176,11 @@ int notify_change(struct dentry * dentry
 			return -EPERM;
 	}
 
+	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
+		if (attr->ia_size != inode->i_size)
+			inode_inc_iversion(inode);
+	}
+
 	if ((ia_valid & ATTR_MODE)) {
 		umode_t amode = attr->ia_mode;
 		/* Flag setting protected by i_mutex */


