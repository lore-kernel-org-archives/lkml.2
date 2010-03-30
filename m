Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292Ab0CaABI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:01:08 -0400
Received: from kroah.org ([198.145.64.141]:45439 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932306Ab0C3XSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:50 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:57:01 2010
Message-Id: <20100330225701.071894302@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:56:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Patrick McHardy <kaber@trash.net>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [093/116] netfilter: xt_recent: fix regression in rules using a zero hit_count
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Patrick McHardy <kaber@trash.net>

commit ef1691504c83ba3eb636c0cfd3ed33f7a6d0b4ee upstream.

Commit 8ccb92ad (netfilter: xt_recent: fix false match) fixed supposedly
false matches in rules using a zero hit_count. As it turns out there is
nothing false about these matches and people are actually using entries
with a hit_count of zero to make rules dependant on addresses inserted
manually through /proc.

Since this slipped past the eyes of three reviewers, instead of
reverting the commit in question, this patch explicitly checks
for a hit_count of zero to make the intentions more clear.

Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/netfilter/xt_recent.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -260,7 +260,7 @@ recent_mt(const struct sk_buff *skb, con
 		for (i = 0; i < e->nstamps; i++) {
 			if (info->seconds && time_after(time, e->stamps[i]))
 				continue;
-			if (info->hit_count && ++hits >= info->hit_count) {
+			if (!info->hit_count || ++hits >= info->hit_count) {
 				ret = !ret;
 				break;
 			}


