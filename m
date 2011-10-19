Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab1JSSK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 14:10:57 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:52457 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab1JSSKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 14:10:54 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
cc: Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH net -v2] [BUGFIX] bonding: use flush_delayed_work_sync in bond_close
In-reply-to: <20111019081757.12455.24788.stgit@ltc219.sdl.hitachi.co.jp>
References: <20111019081757.12455.24788.stgit@ltc219.sdl.hitachi.co.jp>
Comments: In-reply-to Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
   message dated "Wed, 19 Oct 2011 17:17:57 +0900."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Wed, 19 Oct 2011 11:01:02 -0700
Message-ID: <27007.1319047262@death>
x-cbid: 11101918-3534-0000-0000-000000C3835C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com> wrote:

>The bond_close() calls cancel_delayed_work() to cancel delayed works.
>It, however, cannot cancel works that were already queued in workqueue.
>The bond_open() initializes work->data, and proccess_one_work() refers
>get_work_cwq(work)->wq->flags. The get_work_cwq() returns NULL when
>work->data has been initialized. Thus, a panic occurs.
>
>This patch uses flush_delayed_work_sync() instead of cancel_delayed_work()
>in bond_close(). It cancels delayed timer and waits for work to finish
>execution. So, it can avoid the null pointer dereference due to the
>parallel executions of proccess_one_work() and initializing proccess
>of bond_open().

	I'm setting up to test this.  I have a dim recollection that we
tried this some years ago, and there was a different deadlock that
manifested through the flush path.  Perhaps changes since then have
removed that problem.

	-J

>Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
>Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
>Cc: Jay Vosburgh <fubar@us.ibm.com>
>Cc: Andy Gospodarek <andy@greyhouse.net>
>Cc: WANG Cong <xiyou.wangcong@gmail.com>
>---
>
> drivers/net/bonding/bond_main.c |   10 +++++-----
> 1 files changed, 5 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index de3d351..a4353f9 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3504,27 +3504,27 @@ static int bond_close(struct net_device *bond_dev)
> 	write_unlock_bh(&bond->lock);
>
> 	if (bond->params.miimon) {  /* link check interval, in milliseconds. */
>-		cancel_delayed_work(&bond->mii_work);
>+		flush_delayed_work_sync(&bond->mii_work);
> 	}
>
> 	if (bond->params.arp_interval) {  /* arp interval, in milliseconds. */
>-		cancel_delayed_work(&bond->arp_work);
>+		flush_delayed_work_sync(&bond->arp_work);
> 	}
>
> 	switch (bond->params.mode) {
> 	case BOND_MODE_8023AD:
>-		cancel_delayed_work(&bond->ad_work);
>+		flush_delayed_work_sync(&bond->ad_work);
> 		break;
> 	case BOND_MODE_TLB:
> 	case BOND_MODE_ALB:
>-		cancel_delayed_work(&bond->alb_work);
>+		flush_delayed_work_sync(&bond->alb_work);
> 		break;
> 	default:
> 		break;
> 	}
>
> 	if (delayed_work_pending(&bond->mcast_work))
>-		cancel_delayed_work(&bond->mcast_work);
>+		flush_delayed_work_sync(&bond->mcast_work);
>
> 	if (bond_is_lb(bond)) {
> 		/* Must be called only after all
>

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

