Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2EUGPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 02:15:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2EUGPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 02:15:44 -0400
Message-ID: <4FB9DD87.2060204@redhat.com>
Date: Mon, 21 May 2012 14:15:35 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shirley Ma <mashirle@us.ibm.com>
CC: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        davem@davemloft.net
Subject: Re: [V2 PATCH 2/9] macvtap: zerocopy: fix truesize underestimation
References: <20120502033901.11782.13157.stgit@amd-6168-8-1.englab.nay.redhat.com>  <20120502034144.11782.88947.stgit@amd-6168-8-1.englab.nay.redhat.com>  <1337102809.8220.10.camel@oc3660625478.ibm.com>  <4FB3192E.4030803@redhat.com>  <1337180585.10741.6.camel@oc3660625478.ibm.com>  <4FB469A1.3040507@redhat.com>  <1337268512.10741.53.camel@oc3660625478.ibm.com>  <4FB62009.2050900@redhat.com> <1337354551.12999.6.camel@oc3660625478.ibm.com>
In-Reply-To: <1337354551.12999.6.camel@oc3660625478.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 11:22 PM, Shirley Ma wrote:
> On Fri, 2012-05-18 at 18:10 +0800, Jason Wang wrote:
>>> On Thu, 2012-05-17 at 10:59 +0800, Jason Wang wrote:
>>>> Didn't see how this affact skb->len. And for truesize, I think they
>>>> are
>>>> different, when the offset were not zero, the data in this vector
>>>> were
>>>> divided into two parts. First part is copied into skb directly, and
>>>> the
>>>> second were pinned from a whole userspace page by
>>>> get_user_pages_fast(),
>>>> so we need count the whole page to the socket limit to prevent evil
>>>> application.
>>> What I meant that the code for skb->truesize has double added the
>> first
>>> offset if any left from that vector (partically copied into skb
>>> directly, and then count pagesize which includes the offset
>> (truesize +=
>>> PAGE_SIZE)).
>> Yes, I get you mean. There's no difference between first frag and
>> others: it's also possible for other frags that didn't occupy the
>> whole
>> page. Since we pin the whole user page, better to count the whole
>> page
>> size to prevent evil application.
> The difference between first frags and others is other frags might not
> occupy the whole page, but the first frags extra offset was doubled
> added in skb truesize.
>
> So it's ok for skb->truesize to be bigger than all the skb pinned pages
> here?

I think it's ok here and we could find other example such as virtio_net 
driver.
>
> Thanks
> Shirley
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

