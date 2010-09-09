Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab0IISPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 14:15:05 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59002 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab0IISPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 14:15:03 -0400
Date: Thu, 9 Sep 2010 20:14:54 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [REGRESSION PATCH] NFS: let NFS_V4 and NFSD_V4 enforce CRYPTO
Message-ID: <20100909181454.GB14915@pengutronix.de>
References: <20100825084912.GA10293@pengutronix.de> <1282727119-8295-1-git-send-email-u.kleine-koenig@pengutronix.de> <1284051448.6977.6.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1284051448.6977.6.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

On Thu, Sep 09, 2010 at 12:57:28PM -0400, Trond Myklebust wrote:
> On Wed, 2010-08-25 at 11:05 +0200, Uwe Kleine-König wrote:
> > This is a follow up to
> > 
> > 	df486a2 (NFS: Fix the selection of security flavours in Kconfig)
> > 
> > which broke (among others) arm/mx1_defconfig.
> > 
> > Moreover let NFS_V4 select RPCSEC_GSS_KRB5 again as it was before
> > df486a2.  This make the dependency more explicit than relying on the no
> > prompt + default y if !(NFS_V4 || NFSD_V4).
> Having looked more closely at the actual dependencies in the NFSv4
> client and server (see the changelog below), I believe the following is
> the correct patch. It ensures that the RPCSEC_GSS module is always
> selected, and does not introduce any unnecessary dependencies on CRYPTO.
Fine, works for me.  That's even better than selecting CRYPTO.

Still, wouldn't be the patch below more complete?

Best regards
Uwe

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 6c2aad4..f7e13db 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -63,6 +63,7 @@ config NFS_V3_ACL
 config NFS_V4
 	bool "NFS client support for NFS version 4"
 	depends on NFS_FS
+	select SUNRPC_GSS
 	help
 	  This option enables support for version 4 of the NFS protocol
 	  (RFC 3530) in the kernel's NFS client.
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 95932f5..4264377 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -69,6 +69,7 @@ config NFSD_V4
 	depends on NFSD && PROC_FS && EXPERIMENTAL
 	select NFSD_V3
 	select FS_POSIX_ACL
+	select SUNRPC_GSS
 	help
 	  This option enables support in your system's NFS server for
 	  version 4 of the NFS protocol (RFC 3530).
diff --git a/net/sunrpc/Kconfig b/net/sunrpc/Kconfig
index 3376d76..442efe1 100644
--- a/net/sunrpc/Kconfig
+++ b/net/sunrpc/Kconfig
@@ -20,8 +20,7 @@ config SUNRPC_XPRT_RDMA
 config RPCSEC_GSS_KRB5
 	tristate
 	depends on SUNRPC && CRYPTO
-	prompt "Secure RPC: Kerberos V mechanism" if !(NFS_V4 || NFSD_V4)
-	default y
+	prompt "Secure RPC: Kerberos V mechanism"
 	select SUNRPC_GSS
 	select CRYPTO_MD5
 	select CRYPTO_DES

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
