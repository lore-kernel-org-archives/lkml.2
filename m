Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab2AQP1i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:27:38 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:29094 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754595Ab2AQP1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:27:36 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: iOEJ550VM1n0mntCtH5_EknTYUTf47GeUHZFidWP2gS02Rl
 XJgLuj5hQtg2VhcvVZ8rw73..8rV_bPbrjCL8ok_MAbnXeODnAtKcp9VyZXg
 cxWUkln7DLUV0BOeTKIUqQnouYTgGOsiBA1paM.4MEVAQgysLCaOKfoAtHa0
 xrB8kVwaoD0JWMQAa.IKNiTGfmkVyFXu4NPXKuQWw3N75mcgIbgqna4wNbju
 C5kkcPvIN1iJztSYM.Pv0LoXeymCUB0LgvKDWhW4riOuCFE9hK4_srsmsf4C
 jjxzW4pEKKNAvyUYoMjlNLqk00weXo0pHdfaxnHA46zXLbZmxwySv9o.d4qm
 Qv1a3u6Ow6YvvC_TPRMUGEAPVSa.UpNZeTclXltLrDHE.V1jLFH3bxqn.h1J
 cYUzfEPf1Yku8jVeKzMwDfV7kF493psP4iiQv
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 17 Jan 2012 09:27:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        davem <davem@davemloft.net>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, kaber@trash.net, pablo@netfilter.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, netfilter-devel@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: Re: Hung task when calling clone() due to netfilter/slab
In-Reply-To: <1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Message-ID: <alpine.DEB.2.00.1201170927020.4800@router.home>
References: <1326558605.19951.7.camel@lappy>   <1326561043.5287.24.camel@edumazet-laptop>  <1326632384.11711.3.camel@lappy> <1326648305.5287.78.camel@edumazet-laptop>  <alpine.DEB.2.00.1201170910130.4800@router.home>
 <1326813630.2259.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012, Eric Dumazet wrote:

> Buggy patch, since "goto err;" is going to up_write(&slub_lock) again.
>
> Also Christoph, you forgot to add the very much needed :
>
> Reported-by: Sasha Levin <levinsasha928@gmail.com>


Subject: slub: Do not hold slub_lock when calling sysfs_slab_add()

sysfs_slab_add() calls various sysfs functions that actually may
end up in userspace doing all sorts of things.

Release the slub_lock after adding the kmem_cache structure to the list.
At that point the address of the kmem_cache is not known so we are
guaranteed exlusive access to the following modifications to the
kmem_cache structure.

If the sysfs_slab_add fails then reacquire the slub_lock to
remove the kmem_cache structure from the list.

Reported-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2012-01-17 03:07:11.140010438 -0600
+++ linux-2.6/mm/slub.c	2012-01-17 03:26:06.799986908 -0600
@@ -3929,13 +3929,14 @@ struct kmem_cache *kmem_cache_create(con
 		if (kmem_cache_open(s, n,
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
+			up_write(&slub_lock);
 			if (sysfs_slab_add(s)) {
+				down_write(&slub_lock);
 				list_del(&s->list);
 				kfree(n);
 				kfree(s);
 				goto err;
 			}
-			up_write(&slub_lock);
 			return s;
 		}
 		kfree(n);
