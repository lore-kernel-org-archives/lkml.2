Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422714Ab2I1U2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:28:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34785 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032640Ab2I1U2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:28:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Marius Tolzmann <tolzmann@molgen.mpg.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 121/218] NFS: Fix a problem with the legacy binary mount code
Date: Fri, 28 Sep 2012 13:15:38 -0700
Message-Id: <20120928201515.343310025@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1886,6 +1886,7 @@ static int nfs_validate_mount_data(void
 
 		memcpy(sap, &data->addr, sizeof(data->addr));
 		args->nfs_server.addrlen = sizeof(data->addr);
+		args->nfs_server.port = ntohs(data->addr.sin_port);
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
 
@@ -2598,6 +2599,7 @@ static int nfs4_validate_mount_data(void
 			return -EFAULT;
 		if (!nfs_verify_server_address(sap))
 			goto out_no_address;
+		args->nfs_server.port = ntohs(((struct sockaddr_in *)sap)->sin_port);
 
 		if (data->auth_flavourlen) {
 			if (data->auth_flavourlen > 1)


