Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1HKKGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 06:06:12 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:34726 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab1HKKGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 06:06:09 -0400
Date: Thu, 11 Aug 2011 12:06:04 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Dan Carpenter <error27@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/netlabel/netlabel_kapi.c: add missing cleanup code
In-Reply-To: <Pine.LNX.4.64.1108111152130.18938@ask.diku.dk>
Message-ID: <Pine.LNX.4.64.1108111205450.18938@ask.diku.dk>
References: <1313055633-25327-1-git-send-email-julia@diku.dk>
 <20110811094407.GG3777@shale.localdomain> <Pine.LNX.4.64.1108111152130.18938@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Call cipso_v4_doi_putdef in the case of the failure of the allocation of
entry.  Reverse the order of the error handling code at the end of the
function and insert more labels in order to reduce the number of
unnecessary calls to kfree.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/netlabel/netlabel_kapi.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index 58107d0..9c24de1 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -341,11 +341,11 @@ int netlbl_cfg_cipsov4_map_add(u32 doi,
 
 	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (entry == NULL)
-		return -ENOMEM;
+		goto out_entry;
 	if (domain != NULL) {
 		entry->domain = kstrdup(domain, GFP_ATOMIC);
 		if (entry->domain == NULL)
-			goto cfg_cipsov4_map_add_failure;
+			goto out_domain;
 	}
 
 	if (addr == NULL && mask == NULL) {
@@ -354,13 +354,13 @@ int netlbl_cfg_cipsov4_map_add(u32 doi,
 	} else if (addr != NULL && mask != NULL) {
 		addrmap = kzalloc(sizeof(*addrmap), GFP_ATOMIC);
 		if (addrmap == NULL)
-			goto cfg_cipsov4_map_add_failure;
+			goto out_addrmap;
 		INIT_LIST_HEAD(&addrmap->list4);
 		INIT_LIST_HEAD(&addrmap->list6);
 
 		addrinfo = kzalloc(sizeof(*addrinfo), GFP_ATOMIC);
 		if (addrinfo == NULL)
-			goto cfg_cipsov4_map_add_failure;
+			goto out_addrinfo;
 		addrinfo->type_def.cipsov4 = doi_def;
 		addrinfo->type = NETLBL_NLTYPE_CIPSOV4;
 		addrinfo->list.addr = addr->s_addr & mask->s_addr;
@@ -374,7 +374,7 @@ int netlbl_cfg_cipsov4_map_add(u32 doi,
 		entry->type = NETLBL_NLTYPE_ADDRSELECT;
 	} else {
 		ret_val = -EINVAL;
-		goto cfg_cipsov4_map_add_failure;
+		goto out_addrmap;
 	}
 
 	ret_val = netlbl_domhsh_add(entry, audit_info);
@@ -384,11 +384,15 @@ int netlbl_cfg_cipsov4_map_add(u32 doi,
 	return 0;
 
 cfg_cipsov4_map_add_failure:
-	cipso_v4_doi_putdef(doi_def);
+	kfree(addrinfo);
+out_addrinfo:
+	kfree(addrmap);
+out_addrmap:
 	kfree(entry->domain);
+out_domain:
 	kfree(entry);
-	kfree(addrmap);
-	kfree(addrinfo);
+out_entry:
+	cipso_v4_doi_putdef(doi_def);
 	return ret_val;
 }
 

