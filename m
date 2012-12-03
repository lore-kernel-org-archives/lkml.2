Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab2LCKCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:02:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291Ab2LCKCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:02:17 -0500
Message-ID: <50BC7896.4010504@redhat.com>
Date: Mon, 03 Dec 2012 18:01:58 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [net-next rfc v7 2/3] virtio_net: multiqueue support
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com> <1354011360-39479-3-git-send-email-jasowang@redhat.com> <87vccjj3hj.fsf@rustcorp.com.au> <20845723.CY8SZ4xV0F@jason-thinkpad-t430s> <20121203094735.GA23009@redhat.com>
In-Reply-To: <20121203094735.GA23009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 05:47 PM, Michael S. Tsirkin wrote:
> On Mon, Dec 03, 2012 at 02:05:27PM +0800, Jason Wang wrote:
>> On Monday, December 03, 2012 12:34:08 PM Rusty Russell wrote:
>>> Jason Wang <jasowang@redhat.com> writes:
>>>> +static const struct ethtool_ops virtnet_ethtool_ops;
>>>> +
>>>> +/*
>>>> + * Converting between virtqueue no. and kernel tx/rx queue no.
>>>> + * 0:rx0 1:tx0 2:cvq 3:rx1 4:tx1 ... 2N+1:rxN 2N+2:txN
>>>> + */
>>>> +static int vq2txq(struct virtqueue *vq)
>>>> +{
>>>> +	int index = virtqueue_get_queue_index(vq);
>>>> +	return index == 1 ? 0 : (index - 2) / 2;
>>>> +}
>>>> +
>>>> +static int txq2vq(int txq)
>>>> +{
>>>> +	return txq ? 2 * txq + 2 : 1;
>>>> +}
>>>> +
>>>> +static int vq2rxq(struct virtqueue *vq)
>>>> +{
>>>> +	int index = virtqueue_get_queue_index(vq);
>>>> +	return index ? (index - 1) / 2 : 0;
>>>> +}
>>>> +
>>>> +static int rxq2vq(int rxq)
>>>> +{
>>>> +	return rxq ? 2 * rxq + 1 : 0;
>>>> +}
>>>> +
>>> I thought MST changed the proposed spec to make the control queue always
>>> the last one, so this logic becomes trivial.
>> But it may break the support of legacy guest. If we boot a legacy single queue 
>> guest on a 2 queue virtio-net device. It may think vq 2 is cvq which is indeed 
>> rx1.
> Legacy guyest support should be handled by host using feature
> bits in the usual way: host should detect legacy guest
> by checking the VIRTIO_NET_F_RFS feature.
>
> If VIRTIO_NET_F_RFS is acked, cvq is vq max_virtqueue_pairs * 2.
> If it's not acked, cvq is vq 2.
>

We could, but we didn't gain much from this. Furthermore, we need also do the dynamic creation/destroying of virtqueues during feature negotiation which seems not supported in qemu now.
