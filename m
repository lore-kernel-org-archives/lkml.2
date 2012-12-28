Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab2L1Fb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 00:31:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab2L1Fby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 00:31:54 -0500
Message-ID: <50DD2EC5.8010308@redhat.com>
Date: Fri, 28 Dec 2012 13:31:49 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] vhost_net: correct error hanlding in vhost_net_set_backend()
References: <20121227131442.GF20595@redhat.com>
In-Reply-To: <20121227131442.GF20595@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2012 09:14 PM, Michael S. Tsirkin wrote:
> On Thu, Dec 27, 2012 at 02:39:19PM +0800, Jason Wang wrote:
>> Fix the leaking of oldubufs and fd refcnt when fail to initialized used ring.
>>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  drivers/vhost/net.c |   14 +++++++++++---
>>  1 files changed, 11 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
>> index ebd08b2..629d6b5 100644
>> --- a/drivers/vhost/net.c
>> +++ b/drivers/vhost/net.c
>> @@ -834,8 +834,10 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>>  		vhost_net_enable_vq(n, vq);
>>  
>>  		r = vhost_init_used(vq);
>> -		if (r)
>> -			goto err_vq;
>> +		if (r) {
>> +			sock = NULL;
>> +			goto err_used;
>> +		}
>>  
>>  		n->tx_packets = 0;
>>  		n->tx_zcopy_err = 0;
>> @@ -859,8 +861,14 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
>>  	mutex_unlock(&n->dev.mutex);
>>  	return 0;
>>  
>> +err_used:
>> +	if (oldubufs)
>> +		vhost_ubuf_put_and_wait(oldubufs);
>> +	if (oldsock)
>> +		fput(oldsock->file);
>>  err_ubufs:
>> -	fput(sock->file);
>> +	if (sock)
>> +		fput(sock->file);
>>  err_vq:
>>  	mutex_unlock(&vq->mutex);
>>  err:
> I think it's a real bug, but I don't see how the fix
> makes sense.
> We are returning an error, so we ideally
> revert to the state before the faulty
> operation. So this should put sock and ubufs,
> not oldsock/oldubufs.

Agree.
>
> The best way is probably to change
> vhost_init_used so that it gets private data
> pointer as a parameter.
>
> We can then call it before ubuf alloc.
> You can then add err_used right after err_ubufs
> with no extra logic.
>

Make more sense, thanks.
>
>

