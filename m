Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0KLNe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 08:34:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42253 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621Ab0KLNeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 08:34:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lQBzJzzJ7XeMVwAY4vIptiLgMi1phBNYSUZ3JHy/952V7WjvYTb3sm3prrCA8WDQFE
         Z3Rt7+VM4ZNpcwecz4xQPrhjNOnx/4GqtBqnSkMvd2FRH7LU9MTIMokF0vA+UJVVdlb9
         zjMduWv6I267UslVbkXg6V0bp4JptE0CopZoc=
Subject: [PATCH net-next-2.6] igmp: RCU conversion of in_dev->mc_list
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Cypher Wu <cypher.w@gmail.com>, linux-kernel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
In-Reply-To: <1289553759.3185.1.camel@edumazet-laptop>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <20101112071323.GB5660@cr0.nay.redhat.com>
	 <1289546874.17691.1774.camel@edumazet-laptop>
	 <20101112081945.GA5949@cr0.nay.redhat.com>
	 <1289553759.3185.1.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 14:34:18 +0100
Message-ID: <1289568858.3185.252.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 10:22 +0100, Eric Dumazet a écrit :
> Le vendredi 12 novembre 2010 à 16:19 +0800, Américo Wang a écrit :
> > On Fri, Nov 12, 2010 at 08:27:54AM +0100, Eric Dumazet wrote:
> 
> > >A RCU conversion is far more complex.
> > >
> > 
> > Yup.
> 
> 
> Well, actually this is easy in this case.
> 
> I'll post a patch to do this RCU conversion.
> 
> 

Note : compile tested only, I'll appreciate if someone can test it ;)

Note: one patch from net-2.6 is not yet included in net-next-2.6, so
please make sure you have it before testing ;)

( http://git.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commitdiff;h=18943d292facbc70e6a36fc62399ae833f64671b )


Thanks

[PATCH net-next-2.6] igmp: RCU conversion of in_dev->mc_list

in_dev->mc_list is protected by one rwlock (in_dev->mc_list_lock).

This can easily be converted to a RCU protection.

Writers hold RTNL, so mc_list_lock is removed, not replaced by a
spinlock.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Cypher Wu <cypher.w@gmail.com>
Cc: Américo Wang <xiyou.wangcong@gmail.com>
---
 include/linux/igmp.h       |   12 +
 include/linux/inetdevice.h |    5 
 include/net/inet_sock.h    |    2 
 net/ipv4/igmp.c            |  223 ++++++++++++++++-------------------
 4 files changed, 115 insertions(+), 127 deletions(-)

diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index 93fc244..7d16467 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -167,10 +167,10 @@ struct ip_sf_socklist {
  */
 
 struct ip_mc_socklist {
-	struct ip_mc_socklist	*next;
+	struct ip_mc_socklist __rcu *next_rcu;
 	struct ip_mreqn		multi;
 	unsigned int		sfmode;		/* MCAST_{INCLUDE,EXCLUDE} */
-	struct ip_sf_socklist	*sflist;
+	struct ip_sf_socklist __rcu	*sflist;
 	struct rcu_head		rcu;
 };
 
@@ -186,11 +186,14 @@ struct ip_sf_list {
 struct ip_mc_list {
 	struct in_device	*interface;
 	__be32			multiaddr;
+	unsigned int		sfmode;
 	struct ip_sf_list	*sources;
 	struct ip_sf_list	*tomb;
-	unsigned int		sfmode;
 	unsigned long		sfcount[2];
-	struct ip_mc_list	*next;
+	union {
+		struct ip_mc_list *next;
+		struct ip_mc_list __rcu *next_rcu;
+	};
 	struct timer_list	timer;
 	int			users;
 	atomic_t		refcnt;
@@ -201,6 +204,7 @@ struct ip_mc_list {
 	char			loaded;
 	unsigned char		gsquery;	/* check source marks? */
 	unsigned char		crcount;
+	struct rcu_head		rcu;
 };
 
 /* V3 exponential field decoding */
diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index ccd5b07..380ba6b 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -52,9 +52,8 @@ struct in_device {
 	atomic_t		refcnt;
 	int			dead;
 	struct in_ifaddr	*ifa_list;	/* IP ifaddr chain		*/
-	rwlock_t		mc_list_lock;
-	struct ip_mc_list	*mc_list;	/* IP multicast filter chain    */
-	int			mc_count;	          /* Number of installed mcasts	*/
+	struct ip_mc_list __rcu	*mc_list;	/* IP multicast filter chain    */
+	int			mc_count;	/* Number of installed mcasts	*/
 	spinlock_t		mc_tomb_lock;
 	struct ip_mc_list	*mc_tomb;
 	unsigned long		mr_v1_seen;
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 1989cfd..8945f9f 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -141,7 +141,7 @@ struct inet_sock {
 				nodefrag:1;
 	int			mc_index;
 	__be32			mc_addr;
-	struct ip_mc_socklist	*mc_list;
+	struct ip_mc_socklist __rcu	*mc_list;
 	struct {
 		unsigned int		flags;
 		unsigned int		fragsize;
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 08d0d81..ff4e5fd 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -149,11 +149,17 @@ static void ip_mc_clear_src(struct ip_mc_list *pmc);
 static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 			 int sfcount, __be32 *psfsrc, int delta);
 
+
+static void ip_mc_list_reclaim(struct rcu_head *head)
+{
+	kfree(container_of(head, struct ip_mc_list, rcu));
+}
+
 static void ip_ma_put(struct ip_mc_list *im)
 {
 	if (atomic_dec_and_test(&im->refcnt)) {
 		in_dev_put(im->interface);
-		kfree(im);
+		call_rcu(&im->rcu, ip_mc_list_reclaim);
 	}
 }
 
@@ -163,7 +169,7 @@ static void ip_ma_put(struct ip_mc_list *im)
  *	Timer management
  */
 
-static __inline__ void igmp_stop_timer(struct ip_mc_list *im)
+static void igmp_stop_timer(struct ip_mc_list *im)
 {
 	spin_lock_bh(&im->lock);
 	if (del_timer(&im->timer))
@@ -496,14 +502,24 @@ empty_source:
 	return skb;
 }
 
+#define for_each_pmc_rcu(in_dev, pmc)				\
+	for (pmc = rcu_dereference(in_dev->mc_list);		\
+	     pmc != NULL;					\
+	     pmc = rcu_dereference(pmc->next_rcu))
+
+#define for_each_pmc_rtnl(in_dev, pmc)				\
+	for (pmc = rtnl_dereference(in_dev->mc_list);		\
+	     pmc != NULL;					\
+	     pmc = rtnl_dereference(pmc->next_rcu))
+
 static int igmpv3_send_report(struct in_device *in_dev, struct ip_mc_list *pmc)
 {
 	struct sk_buff *skb = NULL;
 	int type;
 
 	if (!pmc) {
-		read_lock(&in_dev->mc_list_lock);
-		for (pmc=in_dev->mc_list; pmc; pmc=pmc->next) {
+		rcu_read_lock();
+		for_each_pmc_rcu(in_dev, pmc) {
 			if (pmc->multiaddr == IGMP_ALL_HOSTS)
 				continue;
 			spin_lock_bh(&pmc->lock);
@@ -514,7 +530,7 @@ static int igmpv3_send_report(struct in_device *in_dev, struct ip_mc_list *pmc)
 			skb = add_grec(skb, pmc, type, 0, 0);
 			spin_unlock_bh(&pmc->lock);
 		}
-		read_unlock(&in_dev->mc_list_lock);
+		rcu_read_unlock();
 	} else {
 		spin_lock_bh(&pmc->lock);
 		if (pmc->sfcount[MCAST_EXCLUDE])
@@ -556,7 +572,7 @@ static void igmpv3_send_cr(struct in_device *in_dev)
 	struct sk_buff *skb = NULL;
 	int type, dtype;
 
-	read_lock(&in_dev->mc_list_lock);
+	rcu_read_lock();
 	spin_lock_bh(&in_dev->mc_tomb_lock);
 
 	/* deleted MCA's */
@@ -593,7 +609,7 @@ static void igmpv3_send_cr(struct in_device *in_dev)
 	spin_unlock_bh(&in_dev->mc_tomb_lock);
 
 	/* change recs */
-	for (pmc=in_dev->mc_list; pmc; pmc=pmc->next) {
+	for_each_pmc_rcu(in_dev, pmc) {
 		spin_lock_bh(&pmc->lock);
 		if (pmc->sfcount[MCAST_EXCLUDE]) {
 			type = IGMPV3_BLOCK_OLD_SOURCES;
@@ -616,7 +632,7 @@ static void igmpv3_send_cr(struct in_device *in_dev)
 		}
 		spin_unlock_bh(&pmc->lock);
 	}
-	read_unlock(&in_dev->mc_list_lock);
+	rcu_read_unlock();
 
 	if (!skb)
 		return;
@@ -813,14 +829,14 @@ static void igmp_heard_report(struct in_device *in_dev, __be32 group)
 	if (group == IGMP_ALL_HOSTS)
 		return;
 
-	read_lock(&in_dev->mc_list_lock);
-	for (im=in_dev->mc_list; im!=NULL; im=im->next) {
+	rcu_read_lock();
+	for_each_pmc_rcu(in_dev, im) {
 		if (im->multiaddr == group) {
 			igmp_stop_timer(im);
 			break;
 		}
 	}
-	read_unlock(&in_dev->mc_list_lock);
+	rcu_read_unlock();
 }
 
 static void igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
@@ -906,8 +922,8 @@ static void igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 	 * - Use the igmp->igmp_code field as the maximum
 	 *   delay possible
 	 */
-	read_lock(&in_dev->mc_list_lock);
-	for (im=in_dev->mc_list; im!=NULL; im=im->next) {
+	rcu_read_lock();
+	for_each_pmc_rcu(in_dev, im) {
 		int changed;
 
 		if (group && group != im->multiaddr)
@@ -925,7 +941,7 @@ static void igmp_heard_query(struct in_device *in_dev, struct sk_buff *skb,
 		if (changed)
 			igmp_mod_timer(im, max_delay);
 	}
-	read_unlock(&in_dev->mc_list_lock);
+	rcu_read_unlock();
 }
 
 /* called in rcu_read_lock() section */
@@ -1110,8 +1126,8 @@ static void igmpv3_clear_delrec(struct in_device *in_dev)
 		kfree(pmc);
 	}
 	/* clear dead sources, too */
-	read_lock(&in_dev->mc_list_lock);
-	for (pmc=in_dev->mc_list; pmc; pmc=pmc->next) {
+	rcu_read_lock();
+	for_each_pmc_rcu(in_dev, pmc) {
 		struct ip_sf_list *psf, *psf_next;
 
 		spin_lock_bh(&pmc->lock);
@@ -1123,7 +1139,7 @@ static void igmpv3_clear_delrec(struct in_device *in_dev)
 			kfree(psf);
 		}
 	}
-	read_unlock(&in_dev->mc_list_lock);
+	rcu_read_unlock();
 }
 #endif
 
@@ -1209,7 +1225,7 @@ void ip_mc_inc_group(struct in_device *in_dev, __be32 addr)
 
 	ASSERT_RTNL();
 
-	for (im=in_dev->mc_list; im; im=im->next) {
+	for_each_pmc_rtnl(in_dev, im) {
 		if (im->multiaddr == addr) {
 			im->users++;
 			ip_mc_add_src(in_dev, &addr, MCAST_EXCLUDE, 0, NULL, 0);
@@ -1217,7 +1233,7 @@ void ip_mc_inc_group(struct in_device *in_dev, __be32 addr)
 		}
 	}
 
-	im = kmalloc(sizeof(*im), GFP_KERNEL);
+	im = kzalloc(sizeof(*im), GFP_KERNEL);
 	if (!im)
 		goto out;
 
@@ -1227,26 +1243,18 @@ void ip_mc_inc_group(struct in_device *in_dev, __be32 addr)
 	im->multiaddr = addr;
 	/* initial mode is (EX, empty) */
 	im->sfmode = MCAST_EXCLUDE;
-	im->sfcount[MCAST_INCLUDE] = 0;
 	im->sfcount[MCAST_EXCLUDE] = 1;
-	im->sources = NULL;
-	im->tomb = NULL;
-	im->crcount = 0;
 	atomic_set(&im->refcnt, 1);
 	spin_lock_init(&im->lock);
 #ifdef CONFIG_IP_MULTICAST
-	im->tm_running = 0;
 	setup_timer(&im->timer, &igmp_timer_expire, (unsigned long)im);
 	im->unsolicit_count = IGMP_Unsolicited_Report_Count;
-	im->reporter = 0;
-	im->gsquery = 0;
 #endif
-	im->loaded = 0;
-	write_lock_bh(&in_dev->mc_list_lock);
-	im->next = in_dev->mc_list;
-	in_dev->mc_list = im;
+
+	im->next_rcu = in_dev->mc_list;
 	in_dev->mc_count++;
-	write_unlock_bh(&in_dev->mc_list_lock);
+	rcu_assign_pointer(in_dev->mc_list, im);
+
 #ifdef CONFIG_IP_MULTICAST
 	igmpv3_del_delrec(in_dev, im->multiaddr);
 #endif
@@ -1287,17 +1295,18 @@ EXPORT_SYMBOL(ip_mc_rejoin_group);
 
 void ip_mc_dec_group(struct in_device *in_dev, __be32 addr)
 {
-	struct ip_mc_list *i, **ip;
+	struct ip_mc_list *i;
+	struct ip_mc_list __rcu **ip;
 
 	ASSERT_RTNL();
 
-	for (ip=&in_dev->mc_list; (i=*ip)!=NULL; ip=&i->next) {
+	for (ip = &in_dev->mc_list;
+	     (i = rtnl_dereference(*ip)) != NULL;
+	     ip = &i->next_rcu) {
 		if (i->multiaddr == addr) {
 			if (--i->users == 0) {
-				write_lock_bh(&in_dev->mc_list_lock);
-				*ip = i->next;
+				*ip = i->next_rcu;
 				in_dev->mc_count--;
-				write_unlock_bh(&in_dev->mc_list_lock);
 				igmp_group_dropped(i);
 
 				if (!in_dev->dead)
@@ -1316,34 +1325,34 @@ EXPORT_SYMBOL(ip_mc_dec_group);
 
 void ip_mc_unmap(struct in_device *in_dev)
 {
-	struct ip_mc_list *i;
+	struct ip_mc_list *pmc;
 
 	ASSERT_RTNL();
 
-	for (i = in_dev->mc_list; i; i = i->next)
-		igmp_group_dropped(i);
+	for_each_pmc_rtnl(in_dev, pmc)
+		igmp_group_dropped(pmc);
 }
 
 void ip_mc_remap(struct in_device *in_dev)
 {
-	struct ip_mc_list *i;
+	struct ip_mc_list *pmc;
 
 	ASSERT_RTNL();
 
-	for (i = in_dev->mc_list; i; i = i->next)
-		igmp_group_added(i);
+	for_each_pmc_rtnl(in_dev, pmc)
+		igmp_group_added(pmc);
 }
 
 /* Device going down */
 
 void ip_mc_down(struct in_device *in_dev)
 {
-	struct ip_mc_list *i;
+	struct ip_mc_list *pmc;
 
 	ASSERT_RTNL();
 
-	for (i=in_dev->mc_list; i; i=i->next)
-		igmp_group_dropped(i);
+	for_each_pmc_rtnl(in_dev, pmc)
+		igmp_group_dropped(pmc);
 
 #ifdef CONFIG_IP_MULTICAST
 	in_dev->mr_ifc_count = 0;
@@ -1374,7 +1383,6 @@ void ip_mc_init_dev(struct in_device *in_dev)
 	in_dev->mr_qrv = IGMP_Unsolicited_Report_Count;
 #endif
 
-	rwlock_init(&in_dev->mc_list_lock);
 	spin_lock_init(&in_dev->mc_tomb_lock);
 }
 
@@ -1382,14 +1390,14 @@ void ip_mc_init_dev(struct in_device *in_dev)
 
 void ip_mc_up(struct in_device *in_dev)
 {
-	struct ip_mc_list *i;
+	struct ip_mc_list *pmc;
 
 	ASSERT_RTNL();
 
 	ip_mc_inc_group(in_dev, IGMP_ALL_HOSTS);
 
-	for (i=in_dev->mc_list; i; i=i->next)
-		igmp_group_added(i);
+	for_each_pmc_rtnl(in_dev, pmc);
+		igmp_group_added(pmc);
 }
 
 /*
@@ -1405,17 +1413,13 @@ void ip_mc_destroy_dev(struct in_device *in_dev)
 	/* Deactivate timers */
 	ip_mc_down(in_dev);
 
-	write_lock_bh(&in_dev->mc_list_lock);
-	while ((i = in_dev->mc_list) != NULL) {
-		in_dev->mc_list = i->next;
+	while ((i = rtnl_dereference(in_dev->mc_list)) != NULL) {
+		in_dev->mc_list = i->next_rcu;
 		in_dev->mc_count--;
-		write_unlock_bh(&in_dev->mc_list_lock);
+
 		igmp_group_dropped(i);
 		ip_ma_put(i);
-
-		write_lock_bh(&in_dev->mc_list_lock);
 	}
-	write_unlock_bh(&in_dev->mc_list_lock);
 }
 
 /* RTNL is locked */
@@ -1513,18 +1517,18 @@ static int ip_mc_del_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 
 	if (!in_dev)
 		return -ENODEV;
-	read_lock(&in_dev->mc_list_lock);
-	for (pmc=in_dev->mc_list; pmc; pmc=pmc->next) {
+	rcu_read_lock();
+	for_each_pmc_rcu(in_dev, pmc) {
 		if (*pmca == pmc->multiaddr)
 			break;
 	}
 	if (!pmc) {
 		/* MCA not found?? bug */
-		read_unlock(&in_dev->mc_list_lock);
+		rcu_read_unlock();
 		return -ESRCH;
 	}
 	spin_lock_bh(&pmc->lock);
-	read_unlock(&in_dev->mc_list_lock);
+	rcu_read_unlock();
 #ifdef CONFIG_IP_MULTICAST
 	sf_markstate(pmc);
 #endif
@@ -1685,18 +1689,18 @@ static int ip_mc_add_src(struct in_device *in_dev, __be32 *pmca, int sfmode,
 
 	if (!in_dev)
 		return -ENODEV;
-	read_lock(&in_dev->mc_list_lock);
-	for (pmc=in_dev->mc_list; pmc; pmc=pmc->next) {
+	rcu_read_lock();
+	for_each_pmc_rcu(in_dev, pmc) {
 		if (*pmca == pmc->multiaddr)
 			break;
 	}
 	if (!pmc) {
 		/* MCA not found?? bug */
-		read_unlock(&in_dev->mc_list_lock);
+		rcu_read_unlock();
 		return -ESRCH;
 	}
 	spin_lock_bh(&pmc->lock);
-	read_unlock(&in_dev->mc_list_lock);
+	rcu_read_unlock();
 
 #ifdef CONFIG_IP_MULTICAST
 	sf_markstate(pmc);
@@ -1793,7 +1797,7 @@ int ip_mc_join_group(struct sock *sk , struct ip_mreqn *imr)
 
 	err = -EADDRINUSE;
 	ifindex = imr->imr_ifindex;
-	for (i = inet->mc_list; i; i = i->next) {
+	for_each_pmc_rtnl(inet, i) {
 		if (i->multi.imr_multiaddr.s_addr == addr &&
 		    i->multi.imr_ifindex == ifindex)
 			goto done;
@@ -1807,7 +1811,7 @@ int ip_mc_join_group(struct sock *sk , struct ip_mreqn *imr)
 		goto done;
 
 	memcpy(&iml->multi, imr, sizeof(*imr));
-	iml->next = inet->mc_list;
+	iml->next_rcu = inet->mc_list;
 	iml->sflist = NULL;
 	iml->sfmode = MCAST_EXCLUDE;
 	rcu_assign_pointer(inet->mc_list, iml);
@@ -1821,17 +1825,14 @@ EXPORT_SYMBOL(ip_mc_join_group);
 
 static void ip_sf_socklist_reclaim(struct rcu_head *rp)
 {
-	struct ip_sf_socklist *psf;
-
-	psf = container_of(rp, struct ip_sf_socklist, rcu);
+	kfree(container_of(rp, struct ip_sf_socklist, rcu));
 	/* sk_omem_alloc should have been decreased by the caller*/
-	kfree(psf);
 }
 
 static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 			   struct in_device *in_dev)
 {
-	struct ip_sf_socklist *psf = iml->sflist;
+	struct ip_sf_socklist *psf = rtnl_dereference(iml->sflist);
 	int err;
 
 	if (psf == NULL) {
@@ -1851,11 +1852,8 @@ static int ip_mc_leave_src(struct sock *sk, struct ip_mc_socklist *iml,
 
 static void ip_mc_socklist_reclaim(struct rcu_head *rp)
 {
-	struct ip_mc_socklist *iml;
-
-	iml = container_of(rp, struct ip_mc_socklist, rcu);
+	kfree(container_of(rp, struct ip_mc_socklist, rcu));
 	/* sk_omem_alloc should have been decreased by the caller*/
-	kfree(iml);
 }
 
 
@@ -1866,7 +1864,8 @@ static void ip_mc_socklist_reclaim(struct rcu_head *rp)
 int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 {
 	struct inet_sock *inet = inet_sk(sk);
-	struct ip_mc_socklist *iml, **imlp;
+	struct ip_mc_socklist *iml;
+	struct ip_mc_socklist __rcu **imlp;
 	struct in_device *in_dev;
 	struct net *net = sock_net(sk);
 	__be32 group = imr->imr_multiaddr.s_addr;
@@ -1876,7 +1875,9 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 	rtnl_lock();
 	in_dev = ip_mc_find_dev(net, imr);
 	ifindex = imr->imr_ifindex;
-	for (imlp = &inet->mc_list; (iml = *imlp) != NULL; imlp = &iml->next) {
+	for (imlp = &inet->mc_list;
+	     (iml = rtnl_dereference(*imlp)) != NULL;
+	     imlp = &iml->next_rcu) {
 		if (iml->multi.imr_multiaddr.s_addr != group)
 			continue;
 		if (ifindex) {
@@ -1888,7 +1889,7 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 
 		(void) ip_mc_leave_src(sk, iml, in_dev);
 
-		rcu_assign_pointer(*imlp, iml->next);
+		*imlp = iml->next_rcu;
 
 		if (in_dev)
 			ip_mc_dec_group(in_dev, group);
@@ -1934,7 +1935,7 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 	}
 	err = -EADDRNOTAVAIL;
 
-	for (pmc=inet->mc_list; pmc; pmc=pmc->next) {
+	for_each_pmc_rtnl(inet, pmc) {
 		if ((pmc->multi.imr_multiaddr.s_addr ==
 		     imr.imr_multiaddr.s_addr) &&
 		    (pmc->multi.imr_ifindex == imr.imr_ifindex))
@@ -1958,7 +1959,7 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 		pmc->sfmode = omode;
 	}
 
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	if (!add) {
 		if (!psl)
 			goto done;	/* err = -EADDRNOTAVAIL */
@@ -2077,7 +2078,7 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 		goto done;
 	}
 
-	for (pmc=inet->mc_list; pmc; pmc=pmc->next) {
+	for_each_pmc_rtnl(inet, pmc) {
 		if (pmc->multi.imr_multiaddr.s_addr == msf->imsf_multiaddr &&
 		    pmc->multi.imr_ifindex == imr.imr_ifindex)
 			break;
@@ -2107,7 +2108,7 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 		(void) ip_mc_add_src(in_dev, &msf->imsf_multiaddr,
 				     msf->imsf_fmode, 0, NULL, 0);
 	}
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	if (psl) {
 		(void) ip_mc_del_src(in_dev, &msf->imsf_multiaddr, pmc->sfmode,
 			psl->sl_count, psl->sl_addr, 0);
@@ -2155,7 +2156,7 @@ int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 	}
 	err = -EADDRNOTAVAIL;
 
-	for (pmc=inet->mc_list; pmc; pmc=pmc->next) {
+	for_each_pmc_rtnl(inet, pmc) {
 		if (pmc->multi.imr_multiaddr.s_addr == msf->imsf_multiaddr &&
 		    pmc->multi.imr_ifindex == imr.imr_ifindex)
 			break;
@@ -2163,7 +2164,7 @@ int ip_mc_msfget(struct sock *sk, struct ip_msfilter *msf,
 	if (!pmc)		/* must have a prior join */
 		goto done;
 	msf->imsf_fmode = pmc->sfmode;
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	rtnl_unlock();
 	if (!psl) {
 		len = 0;
@@ -2208,7 +2209,7 @@ int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
 
 	err = -EADDRNOTAVAIL;
 
-	for (pmc=inet->mc_list; pmc; pmc=pmc->next) {
+	for_each_pmc_rtnl(inet, pmc) {
 		if (pmc->multi.imr_multiaddr.s_addr == addr &&
 		    pmc->multi.imr_ifindex == gsf->gf_interface)
 			break;
@@ -2216,7 +2217,7 @@ int ip_mc_gsfget(struct sock *sk, struct group_filter *gsf,
 	if (!pmc)		/* must have a prior join */
 		goto done;
 	gsf->gf_fmode = pmc->sfmode;
-	psl = pmc->sflist;
+	psl = rtnl_dereference(pmc->sflist);
 	rtnl_unlock();
 	count = psl ? psl->sl_count : 0;
 	copycount = count < gsf->gf_numsrc ? count : gsf->gf_numsrc;
@@ -2257,7 +2258,7 @@ int ip_mc_sf_allow(struct sock *sk, __be32 loc_addr, __be32 rmt_addr, int dif)
 		goto out;
 
 	rcu_read_lock();
-	for (pmc=rcu_dereference(inet->mc_list); pmc; pmc=rcu_dereference(pmc->next)) {
+	for_each_pmc_rcu(inet, pmc) {
 		if (pmc->multi.imr_multiaddr.s_addr == loc_addr &&
 		    pmc->multi.imr_ifindex == dif)
 			break;
@@ -2265,7 +2266,7 @@ int ip_mc_sf_allow(struct sock *sk, __be32 loc_addr, __be32 rmt_addr, int dif)
 	ret = inet->mc_all;
 	if (!pmc)
 		goto unlock;
-	psl = pmc->sflist;
+	psl = rcu_dereference(pmc->sflist);
 	ret = (pmc->sfmode == MCAST_EXCLUDE);
 	if (!psl)
 		goto unlock;
@@ -2300,10 +2301,10 @@ void ip_mc_drop_socket(struct sock *sk)
 		return;
 
 	rtnl_lock();
-	while ((iml = inet->mc_list) != NULL) {
+	while ((iml = rtnl_dereference(inet->mc_list)) != NULL) {
 		struct in_device *in_dev;
-		rcu_assign_pointer(inet->mc_list, iml->next);
 
+		inet->mc_list = iml->next_rcu;
 		in_dev = inetdev_by_index(net, iml->multi.imr_ifindex);
 		(void) ip_mc_leave_src(sk, iml, in_dev);
 		if (in_dev != NULL) {
@@ -2323,8 +2324,8 @@ int ip_check_mc(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u16 p
 	struct ip_sf_list *psf;
 	int rv = 0;
 
-	read_lock(&in_dev->mc_list_lock);
-	for (im=in_dev->mc_list; im; im=im->next) {
+	rcu_read_lock();
+	for_each_pmc_rcu(in_dev, im) {
 		if (im->multiaddr == mc_addr)
 			break;
 	}
@@ -2345,7 +2346,7 @@ int ip_check_mc(struct in_device *in_dev, __be32 mc_addr, __be32 src_addr, u16 p
 		} else
 			rv = 1; /* unspecified source; tentatively allow */
 	}
-	read_unlock(&in_dev->mc_list_lock);
+	rcu_read_unlock();
 	return rv;
 }
 
@@ -2371,13 +2372,11 @@ static inline struct ip_mc_list *igmp_mc_get_first(struct seq_file *seq)
 		in_dev = __in_dev_get_rcu(state->dev);
 		if (!in_dev)
 			continue;
-		read_lock(&in_dev->mc_list_lock);
-		im = in_dev->mc_list;
+		im = rcu_dereference(in_dev->mc_list);
 		if (im) {
 			state->in_dev = in_dev;
 			break;
 		}
-		read_unlock(&in_dev->mc_list_lock);
 	}
 	return im;
 }
@@ -2385,11 +2384,9 @@ static inline struct ip_mc_list *igmp_mc_get_first(struct seq_file *seq)
 static struct ip_mc_list *igmp_mc_get_next(struct seq_file *seq, struct ip_mc_list *im)
 {
 	struct igmp_mc_iter_state *state = igmp_mc_seq_private(seq);
-	im = im->next;
-	while (!im) {
-		if (likely(state->in_dev != NULL))
-			read_unlock(&state->in_dev->mc_list_lock);
 
+	im = rcu_dereference(im->next_rcu);
+	while (!im) {
 		state->dev = next_net_device_rcu(state->dev);
 		if (!state->dev) {
 			state->in_dev = NULL;
@@ -2398,8 +2395,7 @@ static struct ip_mc_list *igmp_mc_get_next(struct seq_file *seq, struct ip_mc_li
 		state->in_dev = __in_dev_get_rcu(state->dev);
 		if (!state->in_dev)
 			continue;
-		read_lock(&state->in_dev->mc_list_lock);
-		im = state->in_dev->mc_list;
+		im = rcu_dereference(state->in_dev->mc_list);
 	}
 	return im;
 }
@@ -2435,10 +2431,8 @@ static void igmp_mc_seq_stop(struct seq_file *seq, void *v)
 	__releases(rcu)
 {
 	struct igmp_mc_iter_state *state = igmp_mc_seq_private(seq);
-	if (likely(state->in_dev != NULL)) {
-		read_unlock(&state->in_dev->mc_list_lock);
-		state->in_dev = NULL;
-	}
+
+	state->in_dev = NULL;
 	state->dev = NULL;
 	rcu_read_unlock();
 }
@@ -2460,7 +2454,7 @@ static int igmp_mc_seq_show(struct seq_file *seq, void *v)
 		querier = "NONE";
 #endif
 
-		if (state->in_dev->mc_list == im) {
+		if (rcu_dereference(state->in_dev->mc_list) == im) {
 			seq_printf(seq, "%d\t%-10s: %5d %7s\n",
 				   state->dev->ifindex, state->dev->name, state->in_dev->mc_count, querier);
 		}
@@ -2519,8 +2513,7 @@ static inline struct ip_sf_list *igmp_mcf_get_first(struct seq_file *seq)
 		idev = __in_dev_get_rcu(state->dev);
 		if (unlikely(idev == NULL))
 			continue;
-		read_lock(&idev->mc_list_lock);
-		im = idev->mc_list;
+		im = rcu_dereference(idev->mc_list);
 		if (likely(im != NULL)) {
 			spin_lock_bh(&im->lock);
 			psf = im->sources;
@@ -2531,7 +2524,6 @@ static inline struct ip_sf_list *igmp_mcf_get_first(struct seq_file *seq)
 			}
 			spin_unlock_bh(&im->lock);
 		}
-		read_unlock(&idev->mc_list_lock);
 	}
 	return psf;
 }
@@ -2545,9 +2537,6 @@ static struct ip_sf_list *igmp_mcf_get_next(struct seq_file *seq, struct ip_sf_l
 		spin_unlock_bh(&state->im->lock);
 		state->im = state->im->next;
 		while (!state->im) {
-			if (likely(state->idev != NULL))
-				read_unlock(&state->idev->mc_list_lock);
-
 			state->dev = next_net_device_rcu(state->dev);
 			if (!state->dev) {
 				state->idev = NULL;
@@ -2556,8 +2545,7 @@ static struct ip_sf_list *igmp_mcf_get_next(struct seq_file *seq, struct ip_sf_l
 			state->idev = __in_dev_get_rcu(state->dev);
 			if (!state->idev)
 				continue;
-			read_lock(&state->idev->mc_list_lock);
-			state->im = state->idev->mc_list;
+			state->im = rcu_dereference(state->idev->mc_list);
 		}
 		if (!state->im)
 			break;
@@ -2603,10 +2591,7 @@ static void igmp_mcf_seq_stop(struct seq_file *seq, void *v)
 		spin_unlock_bh(&state->im->lock);
 		state->im = NULL;
 	}
-	if (likely(state->idev != NULL)) {
-		read_unlock(&state->idev->mc_list_lock);
-		state->idev = NULL;
-	}
+	state->idev = NULL;
 	state->dev = NULL;
 	rcu_read_unlock();
 }


