Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab0DGI6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:58:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:61311 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab0DGI55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:57:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,377,1267430400"; 
   d="scan'208";a="262910094"
From: xiaohui.xin@intel.com
To: mst@redhat.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, jdike@linux.intel.com,
       Xin Xiaohui <xiaohui.xin@intel.com>
Subject: Re:[PATCH 1/3] A device for zero-copy based on KVM virtio-net.
Date: Wed,  7 Apr 2010 17:00:39 +0800
Message-Id: <1270630839-19876-1-git-send-email-xiaohui.xin@intel.com>
X-Mailer: git-send-email 1.5.4.4
In-Reply-To: <20100407081532.GB9550@redhat.com>
References: <20100407081532.GB9550@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xin Xiaohui <xiaohui.xin@intel.com>

---

Michael,
Thanks a lot for the explanation. I have drafted a patch for the qemu write
after I looked into tun driver. Does it do in right way?

Thanks
Xiaohui

 drivers/vhost/mpassthru.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/vhost/mpassthru.c b/drivers/vhost/mpassthru.c
index e9449ac..1cde097 100644
--- a/drivers/vhost/mpassthru.c
+++ b/drivers/vhost/mpassthru.c
@@ -1065,6 +1065,49 @@ static unsigned int mp_chr_poll(struct file *file, poll_table * wait)
 	return mask;
 }
 
+static ssize_t mp_chr_aio_write(struct kiocb *iocb, const struct iovec *iov,
+				unsigned long count, loff_t pos)
+{
+	struct file *file = iocb->ki_filp;
+	struct mp_struct *mp = mp_get(file->private_data);
+	struct sock *sk = mp->socket.sk;
+	struct sk_buff *skb;
+	int len, err;
+	ssize_t result;
+
+	if (!mp)
+		return -EBADFD;
+
+	/* currently, async is not supported */
+	if (!is_sync_kiocb(iocb))
+		return -EFAULT;
+
+	len = iov_length(iov, count);
+	skb = sock_alloc_send_skb(sk, len + NET_IP_ALIGN,
+				  file->f_flags & O_NONBLOCK, &err);
+
+	if (!skb)
+		return -EFAULT;
+
+	skb_reserve(skb, NET_IP_ALIGN);
+	skb_put(skb, len);
+
+	if (skb_copy_datagram_from_iovec(skb, 0, iov, 0, len)) {
+		kfree_skb(skb);
+		return -EFAULT;
+	}
+	skb_set_network_header(skb, ETH_HLEN);
+	skb->protocol = *((__be16 *)(skb->data) + ETH_ALEN);
+	skb->dev = mp->dev;
+
+	dev_queue_xmit(skb);
+	mp->dev->stats.tx_packets++;
+	mp->dev->stats.tx_bytes += len;
+
+	mp_put(mp);
+	return result;
+}
+
 static int mp_chr_close(struct inode *inode, struct file *file)
 {
 	struct mp_file *mfile = file->private_data;
@@ -1084,6 +1127,8 @@ static int mp_chr_close(struct inode *inode, struct file *file)
 static const struct file_operations mp_fops = {
 	.owner  = THIS_MODULE,
 	.llseek = no_llseek,
+	.write  = do_sync_write,
+	.aio_write = mp_chr_aio_write,
 	.poll   = mp_chr_poll,
 	.unlocked_ioctl = mp_chr_ioctl,
 	.open   = mp_chr_open,
-- 
1.5.4.4

