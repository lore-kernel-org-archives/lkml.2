Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab0IIQ6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:58:21 -0400
Received: from mx2.netapp.com ([216.240.18.37]:46691 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609Ab0IIQ6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:58:19 -0400
X-IronPort-AV: E=Sophos;i="4.56,340,1280732400"; 
   d="scan'208";a="446662115"
Subject: Re: [REGRESSION PATCH] NFS: let NFS_V4 and NFSD_V4 enforce CRYPTO
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <1282727119-8295-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20100825084912.GA10293@pengutronix.de>
	 <1282727119-8295-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 09 Sep 2010 12:57:28 -0400
Message-ID: <1284051448.6977.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 09 Sep 2010 16:58:18.0920 (UTC) FILETIME=[33E89280:01CB5040]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-25 at 11:05 +0200, Uwe Kleine-König wrote:
> This is a follow up to
> 
> 	df486a2 (NFS: Fix the selection of security flavours in Kconfig)
> 
> which broke (among others) arm/mx1_defconfig.
> 
> Moreover let NFS_V4 select RPCSEC_GSS_KRB5 again as it was before
> df486a2.  This make the dependency more explicit than relying on the no
> prompt + default y if !(NFS_V4 || NFSD_V4).

Hi Uwe,

Having looked more closely at the actual dependencies in the NFSv4
client and server (see the changelog below), I believe the following is
the correct patch. It ensures that the RPCSEC_GSS module is always
selected, and does not introduce any unnecessary dependencies on CRYPTO.

Cheers
  Trond

-----------------------------------------------------------------------
SUNRPC: Fix the NFSv4 and RPCSEC_GSS Kconfig dependencies

From: Trond Myklebust <Trond.Myklebust@netapp.com>

The NFSv4 client's callback server calls svc_gss_principal(), which
is defined in the auth_rpcgss.ko

The NFSv4 server has the same dependency, and in addition calls
svcauth_gss_flavor(), gss_mech_get_by_pseudoflavor(),
gss_pseudoflavor_to_service() and gss_mech_put() from the same module.

The module auth_rpcgss itself has no dependencies aside from sunrpc,
so we only need to select RPCSEC_GSS.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/Kconfig  |    1 +
 fs/nfsd/Kconfig |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)


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

