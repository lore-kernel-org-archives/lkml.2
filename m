Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816Ab2EDVB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:01:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34670 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab2EDUs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:48:28 -0400
Message-Id: <20120504204245.112426672@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:42:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 03/47] NFSv4: Ensure that we check lock exclusive/shared type against open modes
In-Reply-To: <20120504204307.GA13761@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 55725513b5ef9d462aa3e18527658a0362aaae83 upstream.

Since we may be simulating flock() locks using NFS byte range locks,
we can't rely on the VFS having checked the file open mode for us.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4558,6 +4558,20 @@ nfs4_proc_lock(struct file *filp, int cm
 
 	if (state == NULL)
 		return -ENOLCK;
+	/*
+	 * Don't rely on the VFS having checked the file open mode,
+	 * since it won't do this for flock() locks.
+	 */
+	switch (request->fl_type & (F_RDLCK|F_WRLCK|F_UNLCK)) {
+	case F_RDLCK:
+		if (!(filp->f_mode & FMODE_READ))
+			return -EBADF;
+		break;
+	case F_WRLCK:
+		if (!(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+	}
+
 	do {
 		status = nfs4_proc_setlk(state, cmd, request);
 		if ((status != -EAGAIN) || IS_SETLK(cmd))


