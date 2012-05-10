Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760520Ab2EJRt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:49:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52483 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760266Ab2EJRdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:51 -0400
Message-Id: <20120510173133.834919024@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:31:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Metzmacher <metze@samba.org>,
        =?UTF-8?q?Bj=C3=B6rn=20Jacke?= <bj@sernet.de>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 10/52] fs/cifs: fix parsing of dfs referrals
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

commit d8f2799b105a24bb0bbd3380a0d56e6348484058 upstream.

The problem was that the first referral was parsed more than once
and so the caller tried the same referrals multiple times.

The problem was introduced partly by commit
066ce6899484d9026acd6ba3a8dbbedb33d7ae1b,
where 'ref += le16_to_cpu(ref->Size);' got lost,
but that was also wrong...

Signed-off-by: Stefan Metzmacher <metze@samba.org>
Tested-by: Björn Jacke <bj@sernet.de>
Reviewed-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/cifs/cifssmb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -4831,8 +4831,12 @@ parse_DFS_referrals(TRANSACTION2_GET_DFS
 		max_len = data_end - temp;
 		node->node_name = cifs_strndup_from_utf16(temp, max_len,
 						is_unicode, nls_codepage);
-		if (!node->node_name)
+		if (!node->node_name) {
 			rc = -ENOMEM;
+			goto parse_DFS_referrals_exit;
+		}
+
+		ref++;
 	}
 
 parse_DFS_referrals_exit:


