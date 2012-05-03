Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225Ab2ECJIJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:08:09 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44381 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757181Ab2ECJIF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:08:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120503084115.GM8266@redhat.com>
References: <CAFgQCTtKWR6F3D_mPcGe69HvZbYmmAdXreSWLZQrdi+0T3i2ag@mail.gmail.com>
	<20120503084115.GM8266@redhat.com>
Date: Thu, 3 May 2012 17:08:04 +0800
Message-ID: <CAFgQCTuUmwWF3vumXLZ=BZKLToypaYE_sL44-iFrXp5Qtwze2Q@mail.gmail.com>
Subject: Re: vhost-net: is there a race for sock in handle_tx/rx?
From: Liu ping fan <kernelfans@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, got it. It is a very interesting implement.

Thanks and regards,
pingfan

On Thu, May 3, 2012 at 4:41 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> On Thu, May 03, 2012 at 04:33:55PM +0800, Liu ping fan wrote:
>> Hi,
>>
>> During reading the vhost-net code, I find the following,
>>
>> static void handle_tx(struct vhost_net *net)
>> {
>>       struct vhost_virtqueue *vq = &net->dev.vqs[VHOST_NET_VQ_TX];
>>       unsigned out, in, s;
>>       int head;
>>       struct msghdr msg = {
>>               .msg_name = NULL,
>>               .msg_namelen = 0,
>>               .msg_control = NULL,
>>               .msg_controllen = 0,
>>               .msg_iov = vq->iov,
>>               .msg_flags = MSG_DONTWAIT,
>>       };
>>       size_t len, total_len = 0;
>>       int err, wmem;
>>       size_t hdr_size;
>>       struct socket *sock;
>>       struct vhost_ubuf_ref *uninitialized_var(ubufs);
>>       bool zcopy;
>>
>>       /* TODO: check that we are running from vhost_worker? */
>>       sock = rcu_dereference_check(vq->private_data, 1);
>>       if (!sock)
>>               return;
>>
>>            --------------------------------> Qemu calls
>> vhost_net_set_backend() to set a new backend fd, and close
>> @oldsock->file. And  sock->file refcnt==0.
>>
>>                                               Can vhost_worker prevent
>> itself from such situation? And how?
>>
>>       wmem = atomic_read(&sock->sk->sk_wmem_alloc);
>>        .........................................................................
>>
>> Is it a race?
>>
>> Thanks and regards,
>> pingfan
>
> See comment before void __rcu *private_data in vhost.h
>
>
