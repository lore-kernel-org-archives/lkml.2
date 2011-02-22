Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab1BVW3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:29:15 -0500
Received: from kroah.org ([198.145.64.141]:46781 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745Ab1BVWWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:41 2011
Message-Id: <20110222221841.106623698@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Octavian Purdila <opurdila@ixiacom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [41/70] net: deinit automatic LIST_HEAD
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric Dumazet <eric.dumazet@gmail.com>

commit ceaaec98ad99859ac90ac6863ad0a6cd075d8e0e upstream.

commit 9b5e383c11b08784 (net: Introduce
unregister_netdevice_many()) left an active LIST_HEAD() in
rollback_registered(), with possible memory corruption.

Even if device is freed without touching its unreg_list (and therefore
touching the previous memory location holding LISTE_HEAD(single), better
close the bug for good, since its really subtle.

(Same fix for default_device_exit_batch() for completeness)

Reported-by: Michal Hocko <mhocko@suse.cz>
Tested-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Eric W. Biderman <ebiderman@xmission.com>
Tested-by: Eric W. Biderman <ebiderman@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Octavian Purdila <opurdila@ixiacom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/core/dev.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4945,6 +4945,7 @@ static void rollback_registered(struct n
 
 	list_add(&dev->unreg_list, &single);
 	rollback_registered_many(&single);
+	list_del(&single);
 }
 
 unsigned long netdev_fix_features(unsigned long features, const char *name)
@@ -6114,6 +6115,7 @@ static void __net_exit default_device_ex
 		}
 	}
 	unregister_netdevice_many(&dev_kill_list);
+	list_del(&dev_kill_list);
 	rtnl_unlock();
 }
 


