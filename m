Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965388Ab2C3VPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:15:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965345Ab2C3VPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:15:37 -0400
Message-Id: <20120330194901.714510309@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Weston Andros Adamson <dros@netapp.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 130/149] NFSv4: Fix two infinite loops in the mount code
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 05e9cfb408b24debb3a85fd98edbfd09dd148881 upstream.

We can currently loop forever in nfs4_lookup_root() and in
nfs41_proc_secinfo_no_name(), if the first iteration returns a
NFS4ERR_DELAY or something else that causes exception.retry to get
set.

Reported-by: Weston Andros Adamson <dros@netapp.com>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/nfs4proc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -2242,11 +2242,12 @@ static int nfs4_lookup_root(struct nfs_s
 		switch (err) {
 		case 0:
 		case -NFS4ERR_WRONGSEC:
-			break;
+			goto out;
 		default:
 			err = nfs4_handle_exception(server, err, &exception);
 		}
 	} while (exception.retry);
+out:
 	return err;
 }
 
@@ -6099,11 +6100,12 @@ nfs41_proc_secinfo_no_name(struct nfs_se
 		case 0:
 		case -NFS4ERR_WRONGSEC:
 		case -NFS4ERR_NOTSUPP:
-			break;
+			goto out;
 		default:
 			err = nfs4_handle_exception(server, err, &exception);
 		}
 	} while (exception.retry);
+out:
 	return err;
 }
 


