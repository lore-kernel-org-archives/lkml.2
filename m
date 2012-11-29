Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab2K2Fr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab2K2Fr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:47:56 -0500
From: Jason Wang <jasowang@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>,
        ML netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, rmilasan@suse.cz,
        Jiri Slaby <jirislaby@gmail.com>, maxk@qualcomm.com,
        vtun@office.satix.net
Subject: Re: "tuntap: multiqueue support" causes udev fork bombs
Date: Thu, 29 Nov 2012 13:47:04 +0800
Message-ID: <4146845.d5imC0scLB@jason-thinkpad-t430s>
User-Agent: KMail/4.9.2 (Linux/3.7.0-rc6+; KDE/4.9.2; x86_64; ; )
In-Reply-To: <50B5E6A5.6040009@suse.cz>
References: <50B5E6A5.6040009@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 28, 2012 11:25:41 AM Jiri Slaby wrote:
> Hi,
> 
> with this commit:
> commit c8d68e6be1c3b242f1c598595830890b65cea64a
> Author: Jason Wang <jasowang@redhat.com>
> Date:   Wed Oct 31 19:46:00 2012 +0000
> 
>     tuntap: multiqueue support
> 
> 
> I see fork bombs from udev. It is trying to create 2048 processes. 1024
> for tx, 1024 for rx. OOM killer indeed steps in and kills everything.

Hi, thanks for the reporting, could you pls try the following patch?

---

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index b44d7b7..cc3f878 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -492,9 +492,6 @@ static int tun_attach(struct tun_struct *tun, struct file *file)
 
 	tun_set_real_num_queues(tun);
 
-	if (tun->numqueues == 1)
-		netif_carrier_on(tun->dev);
-
 	/* device is allowed to go away first, so no need to hold extra
 	 * refcnt.
 	 */
@@ -1611,6 +1608,10 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 			TUN_USER_FEATURES;
 		dev->features = dev->hw_features;
 
+		err = tun_attach(tun, file);
+		if (err < 0)
+			goto err_free_dev;
+
 		err = register_netdevice(tun->dev);
 		if (err < 0)
 			goto err_free_dev;
@@ -1620,9 +1621,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		    device_create_file(&tun->dev->dev, &dev_attr_group))
 			pr_err("Failed to create tun sysfs files\n");
 
-		err = tun_attach(tun, file);
-		if (err < 0)
-			goto err_free_dev;
+		netif_carrier_on(tun->dev);
 	}
 
 	tun_debug(KERN_INFO, tun, "tun_set_iff\n");

