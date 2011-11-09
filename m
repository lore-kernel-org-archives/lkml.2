Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936141Ab1KJDsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:48:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45168 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966037Ab1KJDsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:42 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:05 2011
Message-Id: <20111109213205.049578197@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [224/264] NFS/sunrpc: dont use a credential with extra groups.
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit dc6f55e9f8dac4b6479be67c5c9128ad37bb491f upstream.

The sunrpc layer keeps a cache of recently used credentials and
'unx_match' is used to find the credential which matches the current
process.

However unx_match allows a match when the cached credential has extra
groups at the end of uc_gids list which are not in the process group list.

So if a process with a list of (say) 4 group accesses a file and gains
access because of the last group in the list, then another process
with the same uid and gid, and a gid list being the first tree of the
gids of the original process tries to access the file, it will be
granted access even though it shouldn't as the wrong rpc credential
will be used.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/sunrpc/auth_unix.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -129,6 +129,9 @@ unx_match(struct auth_cred *acred, struc
 	for (i = 0; i < groups ; i++)
 		if (cred->uc_gids[i] != GROUP_AT(acred->group_info, i))
 			return 0;
+	if (groups < NFS_NGROUPS &&
+	    cred->uc_gids[groups] != NOGROUP)
+		return 0;
 	return 1;
 }
 


