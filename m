Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab0GYIZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 04:25:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49649 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887Ab0GYIZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 04:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=BQc7y1zVxquxIekm/kp4JSvJhA3qyPwqJN4PCnHqbdxWaZ3Wu5MyfRYoE7lS587wgz
         0PQlH8kWqEVf1ByhtQh5HSYAKXwtTFxaYAzQUHUsEfxbxh7Xw2mOoPmYYJb5xmQg9KqC
         i3HLCIDfrynqb5NaIJIKpZbGtkAsTfp2rRmvM=
MIME-Version: 1.0
In-Reply-To: <20100723154638.88C8.A69D9226@jp.fujitsu.com>
References: <20100716191256.736C.A69D9226@jp.fujitsu.com>
	<20100722053113.GL14369@balbir.in.ibm.com>
	<20100723154638.88C8.A69D9226@jp.fujitsu.com>
Date: Sun, 25 Jul 2010 13:55:32 +0530
X-Google-Sender-Auth: o9f-JaHJ4zLzuGLDK5VGQ7lY1_4
Message-ID: <AANLkTikpZ8iH1oO1k84kvo2qYYS96LYuNmmw6xJL-1QV@mail.gmail.com>
Subject: Re: [PATCH 1/7] memcg: sc.nr_to_reclaim should be initialized
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 1:03 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> * KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2010-07-16 19:13:31]:
>>
>> > Currently, mem_cgroup_shrink_node_zone() initialize sc.nr_to_reclaim as 0.
>> > It mean shrink_zone() only scan 32 pages and immediately return even if
>> > it doesn't reclaim any pages.
>> >
>> > This patch fixes it.
>> >
>> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > ---
>> >  mm/vmscan.c |    1 +
>> >  1 files changed, 1 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/mm/vmscan.c b/mm/vmscan.c
>> > index 1691ad0..bd1d035 100644
>> > --- a/mm/vmscan.c
>> > +++ b/mm/vmscan.c
>> > @@ -1932,6 +1932,7 @@ unsigned long mem_cgroup_shrink_node_zone(struct mem_cgroup *mem,
>> >                                             struct zone *zone, int nid)
>> >  {
>> >     struct scan_control sc = {
>> > +           .nr_to_reclaim = SWAP_CLUSTER_MAX,
>> >             .may_writepage = !laptop_mode,
>> >             .may_unmap = 1,
>> >             .may_swap = !noswap,
>>
>> Could you please do some additional testing on
>>
>> 1. How far does this push pages (in terms of when limit is hit)?
>
> 32 pages per mem_cgroup_shrink_node_zone().
>
> That said, the algorithm is here.
>
> 1. call mem_cgroup_largest_soft_limit_node()
>   calculate largest cgroup
> 2. call mem_cgroup_shrink_node_zone() and shrink 32 pages
> 3. goto 1 if limit is still exceed.
>
> If it's not your intention, can you please your intended algorithm?

We set it to 0, since we care only about a single page reclaim on
hitting the limit. IIRC, in the past we saw an excessive pushback on
reclaiming SWAP_CLUSTER_MAX pages, just wanted to check if you are
seeing the same behaviour even now after your changes.

Balbir
