Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab2FHFQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:16:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43326 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761445Ab2FHFH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:26 -0400
Message-Id: <20120608041846.208742839@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:20 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 40/82] vfs: increment iversion when a file is truncated
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/attr.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/attr.c
+++ b/fs/attr.c
@@ -176,6 +176,11 @@
 			return -EPERM;
 	}
 
+	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
+		if (attr->ia_size != inode->i_size)
+			inode_inc_iversion(inode);
+	}
+
 	if ((ia_valid & ATTR_MODE)) {
 		mode_t amode = attr->ia_mode;
 		/* Flag setting protected by i_mutex */


