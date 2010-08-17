Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190Ab0HQVXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:23:44 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:43621 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746Ab0HQVXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:23:37 -0400
Subject: Re: linux-next: Tree for August 9 (nfs)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-nfs@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C643136.5090808@oracle.com>
References: <20100809132314.789e13f3.sfr@canb.auug.org.au>
	 <20100809100856.b03a9bc1.randy.dunlap@oracle.com>
	 <20100812091842.6a3b84b9.randy.dunlap@oracle.com>
	 <1281634268.14329.18.camel@heimdal.trondhjem.org>
	 <4C643136.5090808@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 17:23:28 -0400
Message-ID: <1282080208.12506.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 8 sum msgs/h 2 total rcpts 850 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8F357681791EDE69F846D23E96C1BA8C8F1FB7DE
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 326 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-12 at 10:36 -0700, Randy Dunlap wrote:
> On 08/12/10 10:31, Trond Myklebust wrote:
> > On Thu, 2010-08-12 at 09:18 -0700, Randy Dunlap wrote:
> >> On Mon, 9 Aug 2010 10:08:56 -0700 Randy Dunlap wrote:
> >>
> >> ping??
> > 
> > Hi Randy,
> > 
> > I'm sorry. A heavy travel schedule is affecting my response time at the
> > moment. I'll try to take care of this by Tuesday (when I get back home)
> > if not before.
> 
> No problem.  Just wanted to make sure that it's not lost.

Hi Randy,

How about the following fix?

Cheers
  Trond

------------------------------------------------------------------------------------
Subject: [PATCH] NFS: Fix the selection of security flavours in Kconfig
From: Trond Myklebust <Trond.Myklebust@netapp.com>

Randy Dunlap reports:

ERROR: "svc_gss_principal" [fs/nfs/nfs.ko] undefined!


because in fs/nfs/Kconfig, NFS_V4 selects RPCSEC_GSS_KRB5
and/or in fs/nfsd/Kconfig, NFSD_V4 selects RPCSEC_GSS_KRB5.

RPCSEC_GSS_KRB5 does 5 selects, but none of these is enforced/followed
by the fs/nfs[d]/Kconfig configs:

	select SUNRPC_GSS
	select CRYPTO
	select CRYPTO_MD5
	select CRYPTO_DES
	select CRYPTO_CBC

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/Kconfig     |    1 -
 fs/nfsd/Kconfig    |    1 -
 net/sunrpc/Kconfig |    9 +++++----
 3 files changed, 5 insertions(+), 6 deletions(-)


diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index cc1bb33..2ddc384 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -63,7 +63,6 @@ config NFS_V3_ACL
 config NFS_V4
 	bool "NFS client support for NFS version 4"
 	depends on NFS_FS
-	select RPCSEC_GSS_KRB5
 	help
 	  This option enables support for version 4 of the NFS protocol
 	  (RFC 3530) in the kernel's NFS client.
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 503b9da..95932f5 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -69,7 +69,6 @@ config NFSD_V4
 	depends on NFSD && PROC_FS && EXPERIMENTAL
 	select NFSD_V3
 	select FS_POSIX_ACL
-	select RPCSEC_GSS_KRB5
 	help
 	  This option enables support in your system's NFS server for
 	  version 4 of the NFS protocol (RFC 3530).
diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index 443c161..3376d76 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -18,10 +18,11 @@ config SUNRPC_XPRT_RDMA
 	  If unsure, say N.
 
 config RPCSEC_GSS_KRB5
-	tristate "Secure RPC: Kerberos V mechanism (EXPERIMENTAL)"
-	depends on SUNRPC && EXPERIMENTAL
+	tristate
+	depends on SUNRPC && CRYPTO
+	prompt "Secure RPC: Kerberos V mechanism" if !(NFS_V4 || NFSD_V4)
+	default y
 	select SUNRPC_GSS
-	select CRYPTO
 	select CRYPTO_MD5
 	select CRYPTO_DES
 	select CRYPTO_CBC
@@ -34,7 +35,7 @@ config RPCSEC_GSS_KRB5
 	  available from http://linux-nfs.org/.  In addition, user-space
 	  Kerberos support should be installed.
 
-	  If unsure, say N.
+	  If unsure, say Y.
 
 config RPCSEC_GSS_SPKM3
 	tristate "Secure RPC: SPKM3 mechanism (EXPERIMENTAL)"


