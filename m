Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965212Ab2I1U7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:59:46 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:41576 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033017Ab2I1Ur4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:47:56 -0400
X-Sasl-enc: 2pC5r5f2O0XnVRYc8Xx+aBvZOgCUKr9kCZc5YFhDI/Zx 1348865275
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marius Tolzmann <tolzmann@molgen.mpg.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 071/127] NFS: Fix a problem with the legacy binary mount code
Date: Fri, 28 Sep 2012 13:34:04 -0700
Message-Id: <20120928203054.183807133@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 872ece86ea5c367aa92f44689c2d01a1c767aeb3 upstream.

Apparently, am-utils is still using the legacy binary mountdata interface,
and is having trouble parsing /proc/mounts due to the 'port=' field being
incorrectly set.

The following patch should fix up the regression.

Reported-by: Marius Tolzmann <tolzmann@molgen.mpg.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1815,6 +1815,7 @@ static int nfs_validate_mount_data(void
 
 		memcpy(sap, &data->addr, sizeof(data->addr));
 		args->nfs_server.addrlen = sizeof(data->addr);
+		args->nfs_server.port = ntohs(data->addr.sin_port);
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
 
@@ -2528,6 +2529,7 @@ static int nfs4_validate_mount_data(void
 			return -EFAULT;
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
+		args->nfs_server.port = ntohs(((struct sockaddr_in *)sap)->sin_port);
 
 		if (data->auth_flavourlen) {
 			if (data->auth_flavourlen > 1)


