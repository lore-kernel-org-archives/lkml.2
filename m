Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1FFLtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:49:12 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60964 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1FFLtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:49:10 -0400
Message-ID: <4DECBEA3.6070408@ahsoftware.de>
Date: Mon, 06 Jun 2011 13:48:51 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>, netdev@vger.kernel.org
Subject: Re: bridge/netfilter: regression in 2.6.39.1
References: <4DE93422.3070000@ahsoftware.de> <20110606111507.GA1000@hmsreliant.think-freely.org>
In-Reply-To: <20110606111507.GA1000@hmsreliant.think-freely.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.06.2011 13:15, schrieb Neil Horman:
> On Fri, Jun 03, 2011 at 09:21:06PM +0200, Alexander Holler wrote:
>> Hello,
>>
>> I'm getting a oops in the bridge code in br_change_mtu() with
>> 2.6.39.1. The patch below seems to fix that.
>>
>> I'm not sure about the usage of dst_cow_metrics_generic() in
>> fake_dst_ops, but after having a quick look at it seems to be ok to
>> use that here.
>>
>> Regards,
>>
>> Alexander
>>
> How did the flags of the dst entry on which we're callnig dst_entry_write_ptr
> wind up getting the  READ_ONLY flag set on it?  I don't see how we'er falling
> into that clause in which we call cow_metrics when we call dst_metric_set.  It
> seems like that flag is set erroneously.  perhaps we should just update
> fake_rtable.dst to have the correct flags?
> Neil

It is set by that change:

--------
@@ -124,7 +128,7 @@ void br_netfilter_rtable_init(struct net_bridge *br)
  	atomic_set(&rt->dst.__refcnt, 1);
  	rt->dst.dev = br->dev;
  	rt->dst.path = &rt->dst;
-	dst_metric_set(&rt->dst, RTAX_MTU, 1500);
+	dst_init_metrics(&rt->dst, br_dst_default_metrics, true);
  	rt->dst.flags	= DST_NOXFRM;
  	rt->dst.ops = &fake_dst_ops;
  }
--------

The true in dst_init_metrics() is responsible for that flag.

Regards,

Alexander
