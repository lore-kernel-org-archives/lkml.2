Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab1DBSZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 14:25:10 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40093 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab1DBSZI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 14:25:08 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
cc: Andy Gospodarek (supporter:BONDING DRIVER) <andy@greyhouse.net>,
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] bonding-tlb: better balance when choosing slaves
In-reply-to: <1301753395-1205-1-git-send-email-panweiping3@gmail.com>
References: <1301753395-1205-1-git-send-email-panweiping3@gmail.com>
Comments: In-reply-to =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= <panweiping3@gmail.com>
   message dated "Sat, 02 Apr 2011 22:09:54 +0800."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Sat, 02 Apr 2011 11:25:03 -0700
Message-ID: <20427.1301768703@death>
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>tlb_get_least_loaded_slave() always chooses slave from
>bonding->first_slave, that gives the beginnig slaves more chances to be used.
>
>Let tlb_get_least_loaded_slave() chooses slave from a random positon in the
>slave list, make all slaves transmit packets more balanced.

	If outgoing traffic is not being starved (i.e., connections are
being balanced such that they are stacking up on one slave but
under-utilizing another), then I don't understand what benefit this has.

	There is already some degree of randomness, as peers will be
assigned in the order that packets are transmitted to them after each
rebalance.  The busiest peers will tend to be on the earlier slaves, and
vice versa, but I'm not sure this is a bad thing.

	Does this have any real gain other than making the rx/tx
statistics for the slaves more equal over time?

	I haven't measured it, but I would expect that for small numbers
of peers, having them tend to stay on the same slaves over time is
probably a good thing.

	-J

>Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
>---
> drivers/net/bonding/bond_alb.c |   17 +++++++++++++++--
> 1 files changed, 15 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>index 9bc5de3..9fa64b0 100644
>--- a/drivers/net/bonding/bond_alb.c
>+++ b/drivers/net/bonding/bond_alb.c
>@@ -36,6 +36,7 @@
> #include <linux/if_bonding.h>
> #include <linux/if_vlan.h>
> #include <linux/in.h>
>+#include <linux/random.h>
> #include <net/ipx.h>
> #include <net/arp.h>
> #include <net/ipv6.h>
>@@ -206,15 +207,27 @@ static long long compute_gap(struct slave *slave)
> /* Caller must hold bond lock for read */
> static struct slave *tlb_get_least_loaded_slave(struct bonding *bond)
> {
>-	struct slave *slave, *least_loaded;
>+	struct slave *slave, *least_loaded, *start_slave;
> 	long long max_gap;
> 	int i;
>+	u8 n;
>
> 	least_loaded = NULL;
>+	start_slave = bond->first_slave;
> 	max_gap = LLONG_MIN;
>+        
>+	get_random_bytes(&n, 1);
>+
>+	if (bond->slave_cnt == 0)
>+		return NULL;
>+	n = n % bond->slave_cnt;
>+
>+	for (i=0; i<n; ++i) {
>+		start_slave = start_slave->next;
>+	}
>
> 	/* Find the slave with the largest gap */
>-	bond_for_each_slave(bond, slave, i) {
>+	bond_for_each_slave_from(bond, slave, i, start_slave) {
> 		if (SLAVE_IS_OK(slave)) {
> 			long long gap = compute_gap(slave);
>
>-- 
>1.7.4
>

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
