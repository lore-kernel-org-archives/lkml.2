Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab2BAVTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:19:36 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57579 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757418Ab2BAVTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:30 -0500
X-Sasl-enc: +5u6bb33nB9LzEwIpv4k8ztw5/44Qii7wPwhQn+HrZTU 1328131170
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:47 2012
Message-Id: <20120201210047.071272253@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Eric W. Biederman" <ebiederm@xmission.com>,
        Wolfgang Frisch <wfpub@roembden.net>
Subject: [36/89] sysfs: Complain bitterly about attempts to remove files from nonexistent directories.
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit ce597919361dcec97341151690e780eade2a9cf4 upstream.

Recently an OOPS was observed from the usb serial io_ti driver when it tried to remove
sysfs directories.  Upon investigation it turns out this driver was always buggy
and that a recent sysfs change had stopped guarding itself against removing attributes
from sysfs directories that had already been removed. :(

Historically we have been silent about attempting to files from nonexistent sysfs
directories and have politely returned error codes.  That has resulted in people writing
broken code that ignores the error codes.

Issue a kernel WARNING and a stack backtrace to make it clear in no uncertain
terms that abusing sysfs is not ok, and the callers need to fix their code.

This change transforms the io_ti OOPS into a more comprehensible error message
and stack backtrace.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Reported-by: Wolfgang Frisch <wfpub@roembden.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/sysfs/file.c  |    6 ++++++
 fs/sysfs/inode.c |    5 ++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -493,6 +493,12 @@ int sysfs_attr_ns(struct kobject *kobj,
 	const void *ns = NULL;
 	int err;
 
+	if (!dir_sd) {
+		WARN(1, KERN_ERR "sysfs: kobject %s without dirent\n",
+			kobject_name(kobj));
+		return -ENOENT;
+	}
+
 	err = 0;
 	if (!sysfs_ns_type(dir_sd))
 		goto out;
--- a/fs/sysfs/inode.c
+++ b/fs/sysfs/inode.c
@@ -318,8 +318,11 @@ int sysfs_hash_and_remove(struct sysfs_d
 	struct sysfs_addrm_cxt acxt;
 	struct sysfs_dirent *sd;
 
-	if (!dir_sd)
+	if (!dir_sd) {
+		WARN(1, KERN_WARNING "sysfs: can not remove '%s', no directory\n",
+			name);
 		return -ENOENT;
+	}
 
 	sysfs_addrm_start(&acxt, dir_sd);
 


