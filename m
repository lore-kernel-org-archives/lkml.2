Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab0CPN6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 09:58:31 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:43450 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab0CPN63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 09:58:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=D8LpwU4AyThnbV27mo25aQqt1XNxDGrDGOQbQEzzJsf2R9vqk4eAuleWO7jxtC8S7p
         O5mRNjRXI5IqDSdS3qvGCNHyE4XDp/y6TxWJU1lHzXhuS6+DQZEkzMkRIRHmmsm8mZMe
         J/Ir2l9cSZa/nJKgam+/jkQfPgmfRJ55wa+j4=
Message-ID: <4B9F8E7F.7070709@gmail.com>
Date: Tue, 16 Mar 2010 14:58:23 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.2pre) Gecko/20100308 SUSE/3.1b1-5.4 Thunderbird/3.1b1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: locking issue in vhost_net_set_backend
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Stanse found a locking problem in the following function:

static long vhost_net_set_backend(struct vhost_net *n, unsigned index, 
int fd)
{
         struct socket *sock, *oldsock;
         struct vhost_virtqueue *vq;
         int r;

         mutex_lock(&n->dev.mutex);
         r = vhost_dev_check_owner(&n->dev);
         if (r)
                 goto err;

         if (index >= VHOST_NET_VQ_MAX) {
                 r = -ENOBUFS;
                 goto err;
         }
         vq = n->vqs + index;
         mutex_lock(&vq->mutex);        <---  locked

         /* Verify that ring has been setup correctly. */
         if (!vhost_vq_access_ok(vq)) {
                 r = -EFAULT;
                 goto err;              <--- not unlocked
         }
         sock = get_socket(fd);
         if (IS_ERR(sock)) {
                 r = PTR_ERR(sock);
                 goto err;              <--- not unlocked
         }

         /* start polling new socket */
         oldsock = vq->private_data;
         if (sock == oldsock)
                 goto done;             <--- not unlocked

         vhost_net_disable_vq(n, vq);
         rcu_assign_pointer(vq->private_data, sock);
         vhost_net_enable_vq(n, vq);
         mutex_unlock(&vq->mutex);
done:
         if (oldsock) {
                 vhost_net_flush_vq(n, index);
                 fput(oldsock->file);
         }
err:
         mutex_unlock(&n->dev.mutex);
         return r;
}


I don't see how the lock is unlocked on the error paths and as it is not 
on none of the them maybe I'm missing something?

thanks,
-- 
js
