Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2LCKbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:31:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754067Ab2LCKbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:31:12 -0500
Message-ID: <50BC7F59.301@redhat.com>
Date: Mon, 03 Dec 2012 18:30:49 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: rusty@rustcorp.com.au, krkumar2@in.ibm.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bhutchings@solarflare.com, jwhan@filewood.snu.ac.kr, shiyer@redhat.com
Subject: Re: [net-next rfc v7 2/3] virtio_net: multiqueue support
References: <1354011360-39479-1-git-send-email-jasowang@redhat.com> <1354011360-39479-3-git-send-email-jasowang@redhat.com> <20121203101436.GB23009@redhat.com>
In-Reply-To: <20121203101436.GB23009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2012 06:14 PM, Michael S. Tsirkin wrote:
> On Tue, Nov 27, 2012 at 06:15:59PM +0800, Jason Wang wrote:
>> > -	if (!try_fill_recv(&vi->rq, GFP_KERNEL))
>> > -		schedule_delayed_work(&vi->rq.refill, 0);
>> > +	for (i = 0; i < vi->max_queue_pairs; i++)
>> > +		if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
>> > +			schedule_delayed_work(&vi->rq[i].refill, 0);
>> >  
>> >  	mutex_lock(&vi->config_lock);
>> >  	vi->config_enable = true;
>> >  	mutex_unlock(&vi->config_lock);
>> >  
>> > +	BUG_ON(virtnet_set_queues(vi));
>> > +
>> >  	return 0;
>> >  }
>> >  #endif
> Also crashing on device nack of command is also not nice.
> In this case it seems we can just switch to
> single-queue mode which should always be safe.

Not sure it's safe. It depends on the reason why this call fails. If we
left a state that the driver only use single queue but the device use
multi queues, we may still lost the network.
