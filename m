Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab1BRI71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:59:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43998 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1BRI7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:59:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tYrb1fTEe2WCyOGJ92TfVXBf9MGEpwYMBKwKzcFHpsE+4cOJ1w8ST7bANr62yO/cK9
         QN8jYQVW2N2ZWRifoEJlO5i/5rxO9JCvRJT593C/GtGB/xjYtWpfLueXHXX8iaCHJNBm
         Ayyy/dmICcL8y3EcFSgUAAK5YtlBWMZSeRS+g=
Subject: [PATCH 2/2] net: deinit automatic LIST_HEAD
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, ebiederm@xmission.com, mingo@elte.hu,
        opurdila@ixiacom.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mhocko@suse.cz, netdev <netdev@vger.kernel.org>, stable@kernel.org
In-Reply-To: <m17hcx7wca.fsf@fess.ebiederm.org>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
	 <20110216193700.GA6377@elte.hu>
	 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
	 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
	 <20110217090910.GA3781@tiehlicka.suse.cz>
	 <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
	 <20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
	 <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
	 <m1sjvm822m.fsf@fess.ebiederm.org>
	 <AANLkTimzP0UNRXutkt1zJ+OGhmeg6ga87HFyMuZQmpMj@mail.gmail.com>
	 <m17hcx7wca.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 09:59:19 +0100
Message-ID: <1298019559.2595.92.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9b5e383c11b08784 (net: Introduce
unregister_netdevice_many()) left an active LIST_HEAD() in
rollback_registered(), with possible memory corruption.

Even if device is freed without touching its unreg_list (and therefore
touching the previous memory location holding LISTE_HEAD(single), better
close the bug for good, since its really subtle.

(Same fix for default_device_exit_batch() for completeness)

Reported-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Eric W. Biderman <ebiderman@xmission.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Octavian Purdila <opurdila@ixiacom.com>
CC: Eric W. Biderman <ebiderman@xmission.com>
CC: stable <stable@kernel.org> [.33+]
---
 net/core/dev.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index a18c164..8ae6631 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5066,6 +5066,7 @@ static void rollback_registered(struct net_device *dev)
 
 	list_add(&dev->unreg_list, &single);
 	rollback_registered_many(&single);
+	list_del(&single);
 }
 
 unsigned long netdev_fix_features(unsigned long features, const char *name)
@@ -6219,6 +6220,7 @@ static void __net_exit default_device_exit_batch(struct list_head *net_list)
 		}
 	}
 	unregister_netdevice_many(&dev_kill_list);
+	list_del(&dev_kill_list);
 	rtnl_unlock();
 }
 


