Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100Ab1IQF7d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 01:59:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237Ab1IQF7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 01:59:21 -0400
Subject: [net-next RFC V2 PATCH 2/5] tuntap: categorize ioctl
To: krkumar2@in.ibm.com, eric.dumazet@gmail.com, mst@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, davem@davemloft.net
From: Jason Wang <jasowang@redhat.com>
Cc: kvm@vger.kernel.org, rusty@rustcorp.com.au, qemu-devel@nongnu.org,
        mirq-linux@rere.qmqm.pl, joe@perches.com, shemminger@vyatta.com
Date: Sat, 17 Sep 2011 14:02:28 +0800
Message-ID: <20110917060228.32666.91035.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
In-Reply-To: <20110917055639.32666.89940.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
References: <20110917055639.32666.89940.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we've moved socket related structure to file->private_data, we move
the ioctls that only touch socket out of tun_chr_ioctl() as it don't
need hold rtnl lock.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/tun.c |   52 ++++++++++++++++++++++++++++++++++------------------
 1 files changed, 34 insertions(+), 18 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index b64ad05..dc768e0 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1238,10 +1238,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun;
 	void __user* argp = (void __user*)arg;
-	struct sock_fprog fprog;
 	struct ifreq ifr;
-	int sndbuf;
-	int vnet_hdr_sz;
 	int ret;
 
 	if (cmd == TUNSETIFF || _IOC_TYPE(cmd) == 0x89)
@@ -1346,14 +1343,6 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		ret = set_offload(tun, arg);
 		break;
 
-	case TUNSETTXFILTER:
-		/* Can be set only for TAPs */
-		ret = -EINVAL;
-		if ((tfile->flags & TUN_TYPE_MASK) != TUN_TAP_DEV)
-			break;
-		ret = update_filter(&tfile->txflt, (void __user *)arg);
-		break;
-
 	case SIOCGIFHWADDR:
 		/* Get hw address */
 		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev->dev_addr, ETH_ALEN);
@@ -1370,6 +1359,37 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);
 		break;
 
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+unlock:
+	rtnl_unlock();
+	if (tun)
+		tun_put(tun);
+	return ret;
+}
+
+static long __tun_socket_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg, int ifreq_len)
+{
+	struct tun_file *tfile = file->private_data;
+	void __user* argp = (void __user*)arg;
+	struct sock_fprog fprog;
+	int sndbuf;
+	int vnet_hdr_sz;
+	int ret = 0;
+
+	switch (cmd) {
+	case TUNSETTXFILTER:
+		/* Can be set only for TAPs */
+		ret = -EINVAL;
+		if ((tfile->flags & TUN_TYPE_MASK) != TUN_TAP_DEV)
+			break;
+		ret = update_filter(&tfile->txflt, (void __user *)arg);
+		break;
+
 	case TUNGETSNDBUF:
 		sndbuf = tfile->socket.sk->sk_sndbuf;
 		if (copy_to_user(argp, &sndbuf, sizeof(sndbuf)))
@@ -1425,21 +1445,17 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		break;
 
 	default:
-		ret = -EINVAL;
+		ret = __tun_chr_ioctl(file, cmd, arg, ifreq_len);
 		break;
 	}
 
-unlock:
-	rtnl_unlock();
-	if (tun)
-		tun_put(tun);
 	return ret;
 }
 
 static long tun_chr_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long arg)
 {
-	return __tun_chr_ioctl(file, cmd, arg, sizeof (struct ifreq));
+	return __tun_socket_ioctl(file, cmd, arg, sizeof (struct ifreq));
 }
 
 #ifdef CONFIG_COMPAT
@@ -1467,7 +1483,7 @@ static long tun_chr_compat_ioctl(struct file *file,
 	 * driver are compatible though, we don't need to convert the
 	 * contents.
 	 */
-	return __tun_chr_ioctl(file, cmd, arg, sizeof(struct compat_ifreq));
+	return __tun_socket_ioctl(file, cmd, arg, sizeof(struct compat_ifreq));
 }
 #endif /* CONFIG_COMPAT */
 

