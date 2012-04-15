Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab2DOM1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 08:27:41 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:37474 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2DOM1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 08:27:39 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, jvrao@linux.vnet.ibm.com, rusty@rustcorp.com.au
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] 9p: disconnect channel when PCI device is removed
In-Reply-To: <1334353716-19483-1-git-send-email-levinsasha928@gmail.com>
References: <1334353716-19483-1-git-send-email-levinsasha928@gmail.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sun, 15 Apr 2012 17:57:26 +0530
Message-ID: <87iph118pd.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12041512-5564-0000-0000-00000235B55B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> When a virtio_9p pci device is being removed, we should close down any
> active channels and free up resources, we're not supposed to BUG() if there's
> still an open channel since it's a valid case when removing the PCI device.
>
> Otherwise, removing the PCI device with an open channel would cause the
> following BUG():
>
...

> diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
> index 3d43206..5af18d1 100644
> --- a/net/9p/trans_virtio.c
> +++ b/net/9p/trans_virtio.c
> @@ -615,7 +615,8 @@ static void p9_virtio_remove(struct virtio_device *vdev)
>  {
>  	struct virtio_chan *chan = vdev->priv;
>
> -	BUG_ON(chan->inuse);
> +	if (chan->inuse)
> +		p9_virtio_close(chan->client);
>  	vdev->config->del_vqs(vdev);
>
>  	mutex_lock(&virtio_9p_lock);

But an umount should have resulted in p9_virtio_close ? How are you
removing the device ? Are you removing the device with file system
mounted  ?. In that case may be we should return EBUSY ?

-aneesh

