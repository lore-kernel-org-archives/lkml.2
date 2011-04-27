Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab1D0FIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 01:08:20 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62006 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1D0FIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 01:08:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KOIabXT6UrB4bgWvQbWcP8pv1FexGdJ8UWezcNRXMtfNAf3wTMjMiFDibYe0VFezH4
         rh1MVWHTzn9jg2aEZN5m3n3jsJ9CeYHcm0+VWJdJpaVMznyEUJsO9hgQhtFV5ujkIbXC
         FOq/pbGNjg0DG+LtokCBeiRlIKGg2723ekpow=
MIME-Version: 1.0
In-Reply-To: <20110427105031.db203b95.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110426181724.f8cdad57.kamezawa.hiroyu@jp.fujitsu.com>
	<20110426135934.c1992c3e.akpm@linux-foundation.org>
	<20110427105031.db203b95.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 27 Apr 2011 14:08:18 +0900
Message-ID: <BANLkTi=zDFrgqn-Mpo2R1M0F_+aMo-byZg@mail.gmail.com>
Subject: Re: [PATCH v2] fix get_scan_count for working well with small targets
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "mgorman@suse.de" <mgorman@suse.de>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kame,

On Wed, Apr 27, 2011 at 10:50 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 26 Apr 2011 13:59:34 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> What about simply removing the nr_saved_scan logic and permitting small
>> scans?  That simplifies the code and I bet it makes no measurable
>> performance difference.
>>
>
> ok, v2 here. How this looks ?
> For memcg, I think I should add select_victim_node() for direct reclaim,
> then, we'll be tune big memcg using small memory on a zone case.
>
> ==
> At memory reclaim, we determine the number of pages to be scanned
> per zone as
>        (anon + file) >> priority.
> Assume
>        scan = (anon + file) >> priority.
>
> If scan < SWAP_CLUSTER_MAX, the scan will be skipped for this time
> and priority gets higher. This has some problems.
>
>  1. This increases priority as 1 without any scan.
>     To do scan in this priority, amount of pages should be larger than 512M.
>     If pages>>priority < SWAP_CLUSTER_MAX, it's recorded and scan will be
>     batched, later. (But we lose 1 priority.)

Nice catch!  It looks to be much enhance.

>     But if the amount of pages is smaller than 16M, no scan at priority==0
>     forever.

Before reviewing the code, I have a question about this.
Now, in case of (priority = 0), we don't do shift operation with priority.
So nr_saved_scan would be the number of lru list pages. ie, 16M.
Why no-scan happens in case of (priority == 0 and 16M lru pages)?
What am I missing now?

>
>  2. If zone->all_unreclaimabe==true, it's scanned only when priority==0.
>     So, x86's ZONE_DMA will never be recoverred until the user of pages
>     frees memory by itself.
>
>  3. With memcg, the limit of memory can be small. When using small memcg,
>     it gets priority < DEF_PRIORITY-2 very easily and need to call
>     wait_iff_congested().
>     For doing scan before priorty=9, 64MB of memory should be used.

It makes sense.



-- 
Kind regards,
Minchan Kim
