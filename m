Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015Ab1CUXww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:52:52 -0400
Received: from kroah.org ([198.145.64.141]:49246 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab1CUXPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:10 2011
Message-Id: <20110321230710.084728567@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [09/87] NFS: NFSROOT should default to "proto=udp"
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit 53d4737580535e073963b91ce87d4216e434fab5 upstream.

There have been a number of recent reports that NFSROOT is no longer
working with default mount options, but fails only with certain NICs.

Brian Downing <bdowning@lavos.net> bisected to commit 56463e50 "NFS:
Use super.c for NFSROOT mount option parsing".  Among other things,
this commit changes the default mount options for NFSROOT to use TCP
instead of UDP as the underlying transport.

TCP seems less able to deal with NICs that are slow to initialize.
The system logs that have accompanied reports of problems all show
that NFSROOT attempts to establish a TCP connection before the NIC is
fully initialized, and thus the TCP connection attempt fails.

When a TCP connection attempt fails during a mount operation, the
NFS stack needs to fail the operation.  Usually user space knows how
and when to retry it.  The network layer does not report a distinct
error code for this particular failure mode.  Thus, there isn't a
clean way for the RPC client to see that it needs to retry in this
case, but not in others.

Because NFSROOT is used in some environments where it is not possible
to update the kernel command line to specify "udp", the proper thing
to do is change NFSROOT to use UDP by default, as it did before commit
56463e50.

To make it easier to see how to change default mount options for
NFSROOT and to distinguish default settings from mandatory settings,
I've adjusted a couple of areas to document the specifics.

root_nfs_cat() is also modified to deal with commas properly when
concatenating strings containing mount option lists.  This keeps
root_nfs_cat() call sites simpler, now that we may be concatenating
multiple mount option strings.

Tested-by: Brian Downing <bdowning@lavos.net>
Tested-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/nfs/nfsroot.c |   29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

--- a/fs/nfs/nfsroot.c
+++ b/fs/nfs/nfsroot.c
@@ -86,11 +86,14 @@
 /* Default path we try to mount. "%s" gets replaced by our IP address */
 #define NFS_ROOT		"/tftpboot/%s"
 
+/* Default NFSROOT mount options. */
+#define NFS_DEF_OPTIONS		"udp"
+
 /* Parameters passed from the kernel command line */
 static char nfs_root_parms[256] __initdata = "";
 
 /* Text-based mount options passed to super.c */
-static char nfs_root_options[256] __initdata = "";
+static char nfs_root_options[256] __initdata = NFS_DEF_OPTIONS;
 
 /* Address of NFS server */
 static __be32 servaddr __initdata = htonl(INADDR_NONE);
@@ -160,8 +163,14 @@ static int __init root_nfs_copy(char *de
 }
 
 static int __init root_nfs_cat(char *dest, const char *src,
-				  const size_t destlen)
+			       const size_t destlen)
 {
+	size_t len = strlen(dest);
+
+	if (len && dest[len - 1] != ',')
+		if (strlcat(dest, ",", destlen) > destlen)
+			return -1;
+
 	if (strlcat(dest, src, destlen) > destlen)
 		return -1;
 	return 0;
@@ -194,16 +203,6 @@ static int __init root_nfs_parse_options
 		if (root_nfs_cat(nfs_root_options, incoming,
 						sizeof(nfs_root_options)))
 			return -1;
-
-	/*
-	 * Possibly prepare for more options to be appended
-	 */
-	if (nfs_root_options[0] != '\0' &&
-	    nfs_root_options[strlen(nfs_root_options)] != ',')
-		if (root_nfs_cat(nfs_root_options, ",",
-						sizeof(nfs_root_options)))
-			return -1;
-
 	return 0;
 }
 
@@ -217,7 +216,7 @@ static int __init root_nfs_parse_options
  */
 static int __init root_nfs_data(char *cmdline)
 {
-	char addr_option[sizeof("nolock,addr=") + INET_ADDRSTRLEN + 1];
+	char mand_options[sizeof("nolock,addr=") + INET_ADDRSTRLEN + 1];
 	int len, retval = -1;
 	char *tmp = NULL;
 	const size_t tmplen = sizeof(nfs_export_path);
@@ -244,9 +243,9 @@ static int __init root_nfs_data(char *cm
 	 * Append mandatory options for nfsroot so they override
 	 * what has come before
 	 */
-	snprintf(addr_option, sizeof(addr_option), "nolock,addr=%pI4",
+	snprintf(mand_options, sizeof(mand_options), "nolock,addr=%pI4",
 			&servaddr);
-	if (root_nfs_cat(nfs_root_options, addr_option,
+	if (root_nfs_cat(nfs_root_options, mand_options,
 						sizeof(nfs_root_options)))
 		goto out_optionstoolong;
 


