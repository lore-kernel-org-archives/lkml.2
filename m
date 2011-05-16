Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1EPJUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:20:35 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:41927 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab1EPJUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:20:33 -0400
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: kernel-janitors@vger.kernel.org, Vipin Mehta <vmehta@atheros.com>,
        Joe Perches <joe@perches.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        Naveen Singh <nsingh@atheros.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/staging/ath6kl/os/linux/cfg80211.c: Add missing call to cfg80211_put_bss
Date: Mon, 16 May 2011 11:20:29 +0200
Message-Id: <1305537629-29876-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

A call to cfg80211_get_bss hould be accompanied by a call to
cfg80211_put_bss in error-handling code.

A simplified version of the semantic match that finds this problem is:
(http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression struct cfg80211_bss * x;
expression ra,rr;
position p1,p2;
@@

x = cfg80211_get_bss@p1(...)
...  when != x = rr
     when != cfg80211_put_bss(x,...)
     when != if (...) { ... cfg80211_put_bss(x,...) ...}
if(...) { ... when != x = ra
     when forall
     when != cfg80211_put_bss(x,...)
 \(return <+...x...+>; \| return@p2...; \) }

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

cocci.print_main("cfg80211_get_bss",p1)
cocci.print_secs("return",p2)

// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
I don't really understand the use of the bss variable later.  Afterwards,
along the normal execution path, there is also a call to cfg80211_put_bss,
but at this point bss has been redefined, and I don't have the impression
that it still points to the same value.

 drivers/staging/ath6kl/os/linux/cfg80211.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/ath6kl/os/linux/cfg80211.c b/drivers/staging/ath6kl/os/linux/cfg80211.c
index efd4ae5..1e6a343 100644
--- a/drivers/staging/ath6kl/os/linux/cfg80211.c
+++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
@@ -545,6 +545,7 @@ ar6k_cfg80211_connect_event(struct ar6_softc *ar, u16 channel,
     if(!ieeemgmtbuf) {
             AR_DEBUG_PRINTF(ATH_DEBUG_ERR,
                             ("%s: ieeeMgmtbuf alloc error\n", __func__));
+	    cfg80211_put_bss(bss);
             return;
     }
 

