Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab2AQPMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 10:12:52 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:36013 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754306Ab2AQPMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 10:12:50 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SjMgG00VM1kYslN0ftH1ESqhjsm3HRdcFDUFhUwUwx4E4iP
 ARMTLH08FxkvqgYC3sml3lQxTz1XAUi.gDl74KWWqTsDL4p.Xe0.avQvUWFF
 ybOyUpoSjjYUmnhfYrG_TLKXgtpW5t5ovUhK1scFMa5mg9K5jdqIe0akt0cn
 0bMbwRKM9l.JdUNDBNFJWjJfBTLEUpDe1uxJexsf8Y5Lf1q.rJ855y.Upcse
 Mx0TGsTw8cEQX0ohAN50K9AhCmBY_NlaIeU559H4u8MYqo5CaaQiXhl_TEOF
 VDejzbORXYJNuNMgSMe8FTRiBhimIOCNkwJuH7SloGEAJVRUjqOMtLeNxMrI
 fweGigRoYKTfU1fuRkl.8yATZD6zJFymNJKpUPTjLl6tuTkfPc68sSBXN5Ci
 s3tsDcWOkIH95Bwyv39vy0z69yx9HiKu4NZHA
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 17 Jan 2012 09:12:33 -0600 (CST)
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
In-Reply-To: <1326648305.5287.78.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1201170910130.4800@router.home>
References: <1326558605.19951.7.camel@lappy>  <1326561043.5287.24.camel@edumazet-laptop> <1326632384.11711.3.camel@lappy> <1326648305.5287.78.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jan 2012, Eric Dumazet wrote:

> As soon as the slub_lock is released, another thread can come and find
> the new kmem_cache.

Slabs are not looked up by name. A pointer to kmem_cache is passed to slab
functions and that pointer is returned from kmem_cache_create(). The risk
is someone traversing the kmem_cach list which is only done from within slub.


Subject: slub: Do not hold slub_lock when calling sysfs_slab_add()

sysfs_slab_add() calls various sysfs functions that actually may
end up in userspace doing all sorts of things.

Release the slub_lock after adding the kmem_cache structure to the list.
At that point the address of the kmem_cache is not known so we are
guaranteed exlusive access to the following modifications to the
kmem_cache structure.

If the sysfs_slab_add fails then reacquire the slub_lock to
remove the kmem_cache structure from the list.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2012-01-17 03:07:11.140010438 -0600
+++ linux-2.6/mm/slub.c	2012-01-17 03:07:19.532010264 -0600
@@ -3929,13 +3929,15 @@ struct kmem_cache *kmem_cache_create(con
 		if (kmem_cache_open(s, n,
 				size, align, flags, ctor)) {
 			list_add(&s->list, &slab_caches);
+			up_write(&slub_lock);
 			if (sysfs_slab_add(s)) {
+				down_write(&slub_lock);
 				list_del(&s->list);
+				up_write(&slub_lock);
 				kfree(n);
 				kfree(s);
 				goto err;
 			}
-			up_write(&slub_lock);
 			return s;
 		}
 		kfree(n);
