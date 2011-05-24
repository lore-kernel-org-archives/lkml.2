Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933476Ab1EXVd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:33:29 -0400
Received: from outmail020.snc4.facebook.com ([66.220.144.152]:46145 "EHLO
	mx-out.facebook.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932627Ab1EXVd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:33:27 -0400
Date: Tue, 24 May 2011 14:33:27 -0700
From: Arun Sharma <asharma@fb.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arun Sharma <asharma@fb.com>, Maximilian Engelhardt <maxi@daemonizer.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        StuStaNet Vorstand <vorstand@stusta.mhn.de>
Subject: Re: Kernel crash after using new Intel NIC (igb)
Message-ID: <20110524213327.GA3917@dev1756.snc6.facebook.com>
References: <201104250033.03401.maxi@daemonizer.de>
 <1303878240.2699.41.camel@edumazet-laptop>
 <1303878771.2699.44.camel@edumazet-laptop>
 <201104271352.00601.maxi@daemonizer.de>
 <20110512211033.GA3468@dev1756.snc6.facebook.com>
 <1305234953.2831.2.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305234953.2831.2.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 11:15:53PM +0200, Eric Dumazet wrote:
> 
> Probably not.
> 
> What gives slub_nomerge=1   for you ?
> 

It took me a while to get a new kernel on a large enough sample
of machines to get some data.

Like you observed in the other thread, this is unlikely to be a random
memory corruption.

The panics stopped after we moved the list_empty() check under the lock.

--- a/net/ipv4/inetpeer.c
+++ b/net/ipv4/inetpeer.c
@@ -154,11 +154,11 @@ void __init inet_initpeers(void)
 /* Called with or without local BH being disabled. */
 static void unlink_from_unused(struct inet_peer *p)
 {
+	spin_lock_bh(&unused_peers.lock);
 	if (!list_empty(&p->unused)) {
-		spin_lock_bh(&unused_peers.lock);
 		list_del_init(&p->unused);
-		spin_unlock_bh(&unused_peers.lock);
 	}
+	spin_unlock_bh(&unused_peers.lock);
 }
 
 static int addr_compare(const struct inetpeer_addr *a,

The idea being that the list gets corrupted under some kind of a race
condition. Two threads racing on list_empty() and executing
list_del_init() seems harmless.

There is probably a different race condition that is mitigated by doing
the list_empty() check under the lock.

 -Arun
