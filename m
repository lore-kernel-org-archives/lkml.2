Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab2I1TdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:33:12 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965459Ab2I1TBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:01:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marius Tolzmann <tolzmann@molgen.mpg.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 150/262] NFS: Fix a problem with the legacy binary mount code
Date: Fri, 28 Sep 2012 11:51:19 -0700
Message-Id: <20120928183015.753427960@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1918,6 +1918,7 @@ static int nfs23_validate_mount_data(voi
 
 		memcpy(sap, &data->addr, sizeof(data->addr));
 		args->nfs_server.addrlen = sizeof(data->addr);
+		args->nfs_server.port = ntohs(data->addr.sin_port);
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
 
@@ -2651,6 +2652,7 @@ static int nfs4_validate_mount_data(void
 			return -EFAULT;
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
+		args->nfs_server.port = ntohs(((struct sockaddr_in *)sap)->sin_port);
 
 		if (data->auth_flavourlen) {
 			if (data->auth_flavourlen > 1)


