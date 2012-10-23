Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab2JWSXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:23:52 -0400
Received: from mx2.netapp.com ([216.240.18.37]:22869 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756836Ab2JWSXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:23:51 -0400
X-IronPort-AV: E=Sophos;i="4.80,637,1344236400"; 
   d="scan'208";a="703347257"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Nix <nix@esperi.org.uk>
CC: "J. Bruce Fields" <bfields@fieldses.org>, "Ted Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Schumaker, Bryan" <Bryan.Schumaker@netapp.com>,
        Peng Tao <bergwolf@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: Re: Heads-up: 3.6.2 / 3.6.3 NFS server oops: 3.6.2+ regression?
 (also an unrelated ext4 data loss bug)
Thread-Topic: Heads-up: 3.6.2 / 3.6.3 NFS server oops: 3.6.2+ regression?
 (also an unrelated ext4 data loss bug)
Thread-Index: AQHNsUTm4bFApwWkDUaJq39XtFx3BJfHKAYwgAB6eYCAAAdlgA==
Date: Tue, 23 Oct 2012 18:23:48 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA90928CF49@SACEXCMBX04-PRD.hq.netapp.com>
References: <87objupjlr.fsf@spindle.srvr.nix>
	 <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	 <20121023143019.GA3040@fieldses.org>	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	 <20121023164621.GC3040@fieldses.org>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA90928CA6F@SACEXCMBX04-PRD.hq.netapp.com>
	 <87vce1w241.fsf@spindle.srvr.nix> <87r4opw0og.fsf@spindle.srvr.nix>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA90928CD7F@SACEXCMBX04-PRD.hq.netapp.com>
	 <1351015039.4622.23.camel@lade.trondhjem.org>
In-Reply-To: <1351015039.4622.23.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6145FE006FD2664BBE6E6C7760C396BF@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9NINvBk005111

On Tue, 2012-10-23 at 13:57 -0400, Trond Myklebust wrote:
> On Tue, 2012-10-23 at 17:44 +0000, Myklebust, Trond wrote:
> > You can't hold a spinlock while sleeping. Both mutex_lock() and nsm_create() can definitely sleep.
> > 
> > The correct way to do this is to grab the spinlock and recheck the value of ln->nsm_users inside the 'if (!IS_ERR())' condition. If it is still zero, bump it and set ln->nsm_clnt, otherwise bump it, get the existing ln->nsm_clnt and call rpc_shutdown_clnt() on the redundant nsm client after dropping the spinlock.
> > 
> > Cheers
> >   Trond
> 
> Can you please check if the following patch fixes the issue?
> 
> Cheers
>   Trond
> 
Meh... This one gets rid of the 100% redundant mutex...

8<-----------------------------------------------------------
>From 4187c816a15df12544ebcfa6b961fce96458e244 Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 23 Oct 2012 13:51:58 -0400
Subject: [PATCH] LOCKD: fix races in nsm_client_get

Commit e9406db20fecbfcab646bad157b4cfdc7cadddfb (lockd: per-net
NSM client creation and destruction helpers introduced) contains
a nasty race on initialisation of the per-net NSM client because
it doesn't check whether or not the client is set after grabbing
the nsm_create_mutex.

Reported-by: Nix <nix@esperi.org.uk>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: stable@vger.kernel.org
---
 fs/lockd/mon.c | 43 ++++++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 17 deletions(-)

diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
index e4fb3ba..fe69560 100644
--- a/fs/lockd/mon.c
+++ b/fs/lockd/mon.c
@@ -85,29 +85,38 @@ static struct rpc_clnt *nsm_create(struct net *net)
 	return rpc_create(&args);
 }
 
+static struct rpc_clnt *nsm_client_set(struct lockd_net *ln,
+		struct rpc_clnt *clnt)
+{
+	spin_lock(&ln->nsm_clnt_lock);
+	if (ln->nsm_users == 0) {
+		if (clnt == NULL)
+			goto out;
+		ln->nsm_clnt = clnt;
+	}
+	clnt = ln->nsm_clnt;
+	ln->nsm_users++;
+out:
+	spin_unlock(&ln->nsm_clnt_lock);
+	return clnt;
+}
+
 static struct rpc_clnt *nsm_client_get(struct net *net)
 {
-	static DEFINE_MUTEX(nsm_create_mutex);
-	struct rpc_clnt	*clnt;
+	struct rpc_clnt	*clnt, *new;
 	struct lockd_net *ln = net_generic(net, lockd_net_id);
 
-	spin_lock(&ln->nsm_clnt_lock);
-	if (ln->nsm_users) {
-		ln->nsm_users++;
-		clnt = ln->nsm_clnt;
-		spin_unlock(&ln->nsm_clnt_lock);
+	clnt = nsm_client_set(ln, NULL);
+	if (clnt != NULL)
 		goto out;
-	}
-	spin_unlock(&ln->nsm_clnt_lock);
 
-	mutex_lock(&nsm_create_mutex);
-	clnt = nsm_create(net);
-	if (!IS_ERR(clnt)) {
-		ln->nsm_clnt = clnt;
-		smp_wmb();
-		ln->nsm_users = 1;
-	}
-	mutex_unlock(&nsm_create_mutex);
+	clnt = new = nsm_create(net);
+	if (IS_ERR(clnt))
+		goto out;
+
+	clnt = nsm_client_set(ln, new);
+	if (clnt != new)
+		rpc_shutdown_client(new);
 out:
 	return clnt;
 }
-- 
1.7.11.7


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
