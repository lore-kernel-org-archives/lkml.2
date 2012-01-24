Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab2AXCm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:42:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755814Ab2AXCmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:42:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:25 2012
Message-Id: <20120124023925.868037360@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:34:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Lukas Razik <linux@razik.name>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [022/129] NFS: Retry mounting NFSROOT
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2780
Lines: 88

From: Chuck Lever <chuck.lever@oracle.com>

commit 43717c7daebf10b43f12e68512484b3095bb1ba5 upstream.

Lukas Razik <linux@razik.name> reports that on his SPARC system,
booting with an NFS root file system stopped working after commit
56463e50 "NFS: Use super.c for NFSROOT mount option parsing."

We found that the network switch to which Lukas' client was attached
was delaying access to the LAN after the client's NIC driver reported
that its link was up.  The delay was longer than the timeouts used in
the NFS client during mounting.

NFSROOT worked for Lukas before commit 56463e50 because in those
kernels, the client's first operation was an rpcbind request to
determine which port the NFS server was listening on.  When that
request failed after a long timeout, the client simply selected the
default NFS port (2049).  By that time the switch was allowing access
to the LAN, and the mount succeeded.

Neither of these client behaviors is desirable, so reverting 56463e50
is really not a choice.  Instead, introduce a mechanism that retries
the NFSROOT mount request several times.  This is the same tactic that
normal user space NFS mounts employ to overcome server and network
delays.

Signed-off-by: Lukas Razik <linux@razik.name>
[ cel: match kernel coding style, add proper patch description ]
[ cel: add exponential back-off ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Lukas Razik <linux@razik.name>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 init/do_mounts.c |   35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

--- a/init/do_mounts.c
+++ b/init/do_mounts.c
@@ -398,15 +398,42 @@ out:
 }
  
 #ifdef CONFIG_ROOT_NFS
+
+#define NFSROOT_TIMEOUT_MIN	5
+#define NFSROOT_TIMEOUT_MAX	30
+#define NFSROOT_RETRY_MAX	5
+
 static int __init mount_nfs_root(void)
 {
 	char *root_dev, *root_data;
+	unsigned int timeout;
+	int try, err;
 
-	if (nfs_root_data(&root_dev, &root_data) != 0)
-		return 0;
-	if (do_mount_root(root_dev, "nfs", root_mountflags, root_data) != 0)
+	err = nfs_root_data(&root_dev, &root_data);
+	if (err != 0)
 		return 0;
-	return 1;
+
+	/*
+	 * The server or network may not be ready, so try several
+	 * times.  Stop after a few tries in case the client wants
+	 * to fall back to other boot methods.
+	 */
+	timeout = NFSROOT_TIMEOUT_MIN;
+	for (try = 1; ; try++) {
+		err = do_mount_root(root_dev, "nfs",
+					root_mountflags, root_data);
+		if (err == 0)
+			return 1;
+		if (try > NFSROOT_RETRY_MAX)
+			break;
+
+		/* Wait, in case the server refused us immediately */
+		ssleep(timeout);
+		timeout <<= 1;
+		if (timeout > NFSROOT_TIMEOUT_MAX)
+			timeout = NFSROOT_TIMEOUT_MAX;
+	}
+	return 0;
 }
 #endif
 


