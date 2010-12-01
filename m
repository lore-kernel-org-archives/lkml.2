Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0LALht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:37:49 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33345 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0LALhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lI+cazJjDWOUUl515kRgal172UtxCXsmy+IJDStpvLUUQfH7b25OIJHyyxBHALBlA5
         iAX+bU4kH2vUfbync1hkgjUSby6hDEVc3Gvi/mIBkgpO6AKbhnmiEIIZY0OyVCLslglb
         7tkEEwifYSY4FXC1T3HZFUzVEtV32l62NdZqc=
Subject: [PATCH net-next-2.6] : __in_dev_get_rtnl() can use
 rtnl_dereference()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
In-Reply-To: <1291202476.2856.584.camel@edumazet-laptop>
References: <1291202063-6239-1-git-send-email-amwang@redhat.com>
	 <1291202476.2856.584.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Dec 2010 12:37:42 +0100
Message-ID: <1291203462.2856.607.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 01 décembre 2010 à 12:21 +0100, Eric Dumazet a écrit :

> Same here. RTNL is held. Please use __in_dev_get_rtnl()

By the way we can use rtnl_dereference() in __in_dev_get_rtnl()

[PATCH net-next-2.6] : __in_dev_get_rtnl() can use rtnl_dereference()

If caller holds RTNL, we dont need a memory barrier
(smp_read_barrier_depends) included in rcu_dereference().

Just use rtnl_dereference() to properly document the assertions.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/inetdevice.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index 2b86eaf..ae8fdc5 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -222,7 +222,7 @@ static inline struct in_device *in_dev_get(const struct net_device *dev)
 
 static inline struct in_device *__in_dev_get_rtnl(const struct net_device *dev)
 {
-	return rcu_dereference_check(dev->ip_ptr, lockdep_rtnl_is_held());
+	return rtnl_dereference(dev->ip_ptr);
 }
 
 extern void in_dev_finish_destroy(struct in_device *idev);


