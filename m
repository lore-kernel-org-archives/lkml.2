Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab1KWAeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:34:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759021Ab1KWAeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:34:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:07 2011
Message-Id: <20111123002207.287522277@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:20:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [03/25] NFS/sunrpc: dont use a credential with extra groups.
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1289
Lines: 39

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
 


