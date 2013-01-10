Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343Ab3AJO12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 09:27:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab3AJO10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 09:27:26 -0500
Message-ID: <50EECFC8.9020402@redhat.com>
Date: Thu, 10 Jan 2013 22:27:20 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Moore <pmoore@redhat.com>
Subject: Re: [PATCH] tun: avoid owner checks on IFF_ATTACH_QUEUE
References: <20130110113108.GF13451@redhat.com> <50EECB43.8020405@redhat.com> <20130110141939.GA30557@redhat.com>
In-Reply-To: <20130110141939.GA30557@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2013 10:19 PM, Michael S. Tsirkin wrote:
> On Thu, Jan 10, 2013 at 10:08:03PM +0800, Jason Wang wrote:
>> On 01/10/2013 07:31 PM, Michael S. Tsirkin wrote:
>>> At the moment, we check owner when we enable queue in tun.
>>> This seems redundant and will break some valid uses
>>> where fd is passed around: I think TUNSETOWNER is there
>>> to prevent others from attaching to a persistent device not
>>> owned by them. Here the fd is already attached,
>>> enabling/disabling queue is more like read/write.
>> It also change the number of queues of the tuntap, maybe we should limit
>> this.
> Number of active queues? Why does it matter?
> Max number of queues is already limited by SETIFF.

Yes the number of active(real) queues in the kernel net device and this
changing may introduce other events such uevent. With this patch, even
if a owner is set for tap, every user could change the number of real
queues which I don't think is not expected. Without this patch, we can
limit a user that just do read and write.
>
>> Note that if management layer does not call TUNSETOWNER, the check
>> is just a nop. So if management layer want to limit the behavior, it's
>> its duty to do this correctly.
> The point is that management limits tun to allow SETIFF from libvirt
> only, then passes the fds to qemu.

Yes, but looks like libvirt does not call TUNSETOWNER before passing it
to qemu, so we're ok even without this patch. And if libvirt want to do
this, it can just call TUNSETOWNER to the user of qemu.
>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>>
>>> ---
>>>
>>> Note: this is unrelated to Stefan's bugfix.
>>>
>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>> index fbd106e..78e3225 100644
>>> --- a/drivers/net/tun.c
>>> +++ b/drivers/net/tun.c
>>> @@ -1789,10 +1792,8 @@ static int tun_set_queue(struct file *file, struct ifreq *ifr)
>>>  		tun = tfile->detached;
>>>  		if (!tun)
>>>  			ret = -EINVAL;
>>> -		else if (tun_not_capable(tun))
>>> -			ret = -EPERM;
>>>  		else
>>>  			ret = tun_attach(tun, file);
>>>  	} else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
>>>  		tun = rcu_dereference_protected(tfile->tun,
>>>  						lockdep_rtnl_is_held());
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

