Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab2EIF44 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:56:56 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39203 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756911Ab2EIFxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:52 -0400
Message-Id: <20120509055048.247307094@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Metzmacher <metze@samba.org>,
        =?ISO-8859-15?q?Bj=C3=B6rn=20Jacke?= <bj@sernet.de>,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Subject: [ 135/167] [PATCH] fs/cifs: fix parsing of dfs referrals
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backport to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/cifssmb.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- linux.orig/fs/cifs/cifssmb.c
+++ linux/fs/cifs/cifssmb.c
@@ -4826,8 +4826,12 @@
 		max_len = data_end - temp;
 		node->node_name = cifs_strndup_from_ucs(temp, max_len,
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


