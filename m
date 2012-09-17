Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab2IQAu7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33447 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142Ab2IQAtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:46 -0400
Message-Id: <20120917003639.235878748@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:37:59 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Trond Myklebust <Trond.Myklebust@netapp.com>,
        Marius Tolzmann <tolzmann@molgen.mpg.de>
Subject: [ 094/135] NFS: Fix a problem with the legacy binary mount code
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 872ece86ea5c367aa92f44689c2d01a1c767aeb3 upstream.

Apparently, am-utils is still using the legacy binary mountdata interface,
and is having trouble parsing /proc/mounts due to the 'port=' field being
incorrectly set.

The following patch should fix up the regression.

Reported-by: Marius Tolzmann <tolzmann@molgen.mpg.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index 239aff7..b8eda70 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1867,6 +1867,7 @@ static int nfs23_validate_mount_data(void *options,
 
 		memcpy(sap, &data->addr, sizeof(data->addr));
 		args->nfs_server.addrlen = sizeof(data->addr);
+		args->nfs_server.port = ntohs(data->addr.sin_port);
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
 
@@ -2564,6 +2565,7 @@ static int nfs4_validate_mount_data(void *options,
 			return -EFAULT;
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
+		args->nfs_server.port = ntohs(((struct sockaddr_in *)sap)->sin_port);
 
 		if (data->auth_flavourlen) {
 			if (data->auth_flavourlen > 1)


