Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1EJCXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 22:23:15 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36264 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1EJCXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 22:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J+R4EkElW0csVL9LS4rC9DHg3RfOiFYRw2VamoSdVmmR+AcB3iXbQQh+crQPPYbSXO
         F1DB6ttG+pkjSbrIyk0Dp2QET6BYP6FEwwRgKCyAFr2b+GNRHG+ZAAAco7h7szrkwLFT
         OneMJMrAys+K+ZIOI+p6vcaCHUBjFFvlN2roQ=
Subject: Re: 2.6.39-rc6-mmotm0506 - another lockdep splat (networking this
 time)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <6954.1304989523@localhost>
References: <6954.1304989523@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 04:23:08 +0200
Message-ID: <1304994188.3050.17.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 09 mai 2011 à 21:05 -0400, Valdis.Kletnieks@vt.edu a écrit :
> Seen during boot this afternoon:
> 
> [   43.309549] 
> [   43.309550] ===================================================
> [   43.309553] [ INFO: suspicious rcu_dereference_check() usage. ]
> [   43.309555] ---------------------------------------------------
> [   43.309558] include/linux/inetdevice.h:226 invoked rcu_dereference_check() without protection!
> [   43.309560] 
> [   43.309561] other info that might help us debug this:
> [   43.309561] 
> [   43.309563] 
> [   43.309564] rcu_scheduler_active = 1, debug_locks = 1
> [   43.309567] 2 locks held by ip/1193:
> [   43.309568]  #0:  (nlk->cb_mutex){+.+...}, at: [<ffffffff81426c1d>] netlink_dump+0x45/0x1d0
> [   43.309579]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff8141b9b9>] rtnl_dump_ifinfo+0x0/0x156

strange : rcu_read_lock() is correctly held at this point

> [   43.309587] 
> [   43.309587] stack backtrace:
> [   43.309590] Pid: 1193, comm: ip Not tainted 2.6.39-rc6-mmotm0506 #1
> [   43.309592] Call Trace:
> [   43.309599]  [<ffffffff81066b6e>] lockdep_rcu_dereference+0x9a/0xa2
> [   43.309604]  [<ffffffff81468d41>] __in_dev_get_rtnl+0x3c/0x47
> [   43.309607]  [<ffffffff81468ef0>] inet_fill_link_af+0x12/0x5b
> [   43.309611]  [<ffffffff8141b8fc>] rtnl_fill_ifinfo+0x665/0x710
> [   43.309616]  [<ffffffff8141ba76>] rtnl_dump_ifinfo+0xbd/0x156
> [   43.309620]  [<ffffffff81426c37>] netlink_dump+0x5f/0x1d0
> [   43.309624]  [<ffffffff81404e3e>] ? consume_skb+0x8a/0x8f
> [   43.309628]  [<ffffffff81426fc8>] netlink_recvmsg+0x1dd/0x31d
> [   43.309632]  [<ffffffff813ff21f>] ? rcu_read_unlock+0x21/0x23
> [   43.309636]  [<ffffffff813fab57>] sock_recvmsg+0xed/0x112
> [   43.309641]  [<ffffffff810d1ebf>] ? might_fault+0x4e/0x9e
> [   43.309645]  [<ffffffff81068816>] ? __lock_release+0x93/0x9c
> [   43.309649]  [<ffffffff810d1ebf>] ? might_fault+0x4e/0x9e
> [   43.309652]  [<ffffffff810d1f08>] ? might_fault+0x97/0x9e
> [   43.309656]  [<ffffffff814065f8>] ? copy_from_user+0x3c/0x44
> [   43.309660]  [<ffffffff813fc047>] __sys_recvmsg+0x16c/0x224
> [   43.309665]  [<ffffffff81059240>] ? up_read+0x23/0x27
> [   43.309669]  [<ffffffff81065165>] ? arch_local_irq_save+0x9/0xc
> [   43.309673]  [<ffffffff810f736b>] ? fcheck_files+0xb4/0xeb
> [   43.309676]  [<ffffffff810f79f3>] ? fget_light+0x35/0x96
> [   43.309680]  [<ffffffff813fdded>] sys_recvmsg+0x3d/0x5b
> [   43.309686]  [<ffffffff815705bb>] system_call_fastpath+0x16/0x1b
> [   44.437679] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   44.488363] e1000e 0000:00:19.0: irq 46 for MSI/MSI-X
> [   44.494680] ADDRCONF(NETDEV_UP): eth0: link is not ready
> 
> 

Thanks for the report, I am taking a look how to fix this.

I am testing following patch, I'll provide an official one when
validated.



diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index cd9ca08..6b1eb92 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1369,7 +1369,7 @@ errout:
 
 static size_t inet_get_link_af_size(const struct net_device *dev)
 {
-	struct in_device *in_dev = __in_dev_get_rtnl(dev);
+	struct in_device *in_dev = __in_dev_get_rcu(dev);
 
 	if (!in_dev)
 		return 0;
@@ -1379,7 +1379,7 @@ static size_t inet_get_link_af_size(const struct net_device *dev)
 
 static int inet_fill_link_af(struct sk_buff *skb, const struct net_device *dev)
 {
-	struct in_device *in_dev = __in_dev_get_rtnl(dev);
+	struct in_device *in_dev = __in_dev_get_rcu(dev);
 	struct nlattr *nla;
 	int i;
 


