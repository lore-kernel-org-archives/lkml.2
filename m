Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab1GHFAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:00:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41483 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab1GHFAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:00:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:52 2011
Message-Id: <20110708001652.857126992@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:15:33 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [001/107] netfilter: ipset: Use proper timeout value to jiffies conversion
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

[ Upstream commit 249ddc79a38a8918ad53ac22606ca8af694344a5 ]

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/netfilter/ipset/ip_set_timeout.h |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -45,7 +45,7 @@ ip_set_timeout_test(unsigned long timeou
 {
 	return timeout != IPSET_ELEM_UNSET &&
 	       (timeout == IPSET_ELEM_PERMANENT ||
-		time_after(timeout, jiffies));
+		time_is_after_jiffies(timeout));
 }
 
 static inline bool
@@ -53,7 +53,7 @@ ip_set_timeout_expired(unsigned long tim
 {
 	return timeout != IPSET_ELEM_UNSET &&
 	       timeout != IPSET_ELEM_PERMANENT &&
-	       time_before(timeout, jiffies);
+	       time_is_before_jiffies(timeout);
 }
 
 static inline unsigned long
@@ -64,7 +64,7 @@ ip_set_timeout_set(u32 timeout)
 	if (!timeout)
 		return IPSET_ELEM_PERMANENT;
 
-	t = timeout * HZ + jiffies;
+	t = msecs_to_jiffies(timeout * 1000) + jiffies;
 	if (t == IPSET_ELEM_UNSET || t == IPSET_ELEM_PERMANENT)
 		/* Bingo! */
 		t++;
@@ -75,7 +75,8 @@ ip_set_timeout_set(u32 timeout)
 static inline u32
 ip_set_timeout_get(unsigned long timeout)
 {
-	return timeout == IPSET_ELEM_PERMANENT ? 0 : (timeout - jiffies)/HZ;
+	return timeout == IPSET_ELEM_PERMANENT ? 0 :
+		jiffies_to_msecs(timeout - jiffies)/1000;
 }
 
 #else
@@ -89,14 +90,14 @@ static inline bool
 ip_set_timeout_test(unsigned long timeout)
 {
 	return timeout == IPSET_ELEM_PERMANENT ||
-	       time_after(timeout, jiffies);
+	       time_is_after_jiffies(timeout);
 }
 
 static inline bool
 ip_set_timeout_expired(unsigned long timeout)
 {
 	return timeout != IPSET_ELEM_PERMANENT &&
-	       time_before(timeout, jiffies);
+	       time_is_before_jiffies(timeout);
 }
 
 static inline unsigned long
@@ -107,7 +108,7 @@ ip_set_timeout_set(u32 timeout)
 	if (!timeout)
 		return IPSET_ELEM_PERMANENT;
 
-	t = timeout * HZ + jiffies;
+	t = msecs_to_jiffies(timeout * 1000) + jiffies;
 	if (t == IPSET_ELEM_PERMANENT)
 		/* Bingo! :-) */
 		t++;
@@ -118,7 +119,8 @@ ip_set_timeout_set(u32 timeout)
 static inline u32
 ip_set_timeout_get(unsigned long timeout)
 {
-	return timeout == IPSET_ELEM_PERMANENT ? 0 : (timeout - jiffies)/HZ;
+	return timeout == IPSET_ELEM_PERMANENT ? 0 :
+		jiffies_to_msecs(timeout - jiffies)/1000;
 }
 #endif /* ! IP_SET_BITMAP_TIMEOUT */
 


