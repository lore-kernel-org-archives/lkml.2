Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529Ab1FWO1N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:27:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59895 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758232Ab1FWO1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:27:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=bjHE9HR9ZloFxwOPcvFuhIGo7JeFLobxTPz/Ys3G8ikDd8kt2zrdL6uanTQM14RGFF
         F7HDmNaLJoOz14UmiwlpOYW1zARaeyBsFjWF8hWZG3UIFGblFDq4qx2cbSu+ZsvviYJY
         wOZe812/itbP7L/WDoU1JGgHeVIHrcg8U9mGA=
MIME-Version: 1.0
In-Reply-To: <20110623133524.GJ31593@tiehlicka.suse.cz>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616125633.9b9fa703.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623133524.GJ31593@tiehlicka.suse.cz>
Date: Thu, 23 Jun 2011 23:27:10 +0900
Message-ID: <BANLkTinBnnNMf_BmP=K4GafznW1jijQS8Q@mail.gmail.com>
Subject: Re: [PATCH 6/7] memcg: calc NUMA node's weight for scan.
From: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/23 Michal Hocko <mhocko@suse.cz>:
> On Thu 16-06-11 12:56:33, KAMEZAWA Hiroyuki wrote:
>> From fb8aaa2c5f7fd99dfcb5d2ecb3c1226a58caafea Mon Sep 17 00:00:00 2001
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Date: Thu, 16 Jun 2011 10:05:46 +0900
>> Subject: [PATCH 6/7] memcg: calc NUMA node's weight for scan.
>>
>> Now, by commit 889976, numa node scan of memcg is in round-robin.
>> As commit log says, "a better algorithm is needed".
>>
>> for implementing some good scheduling, one of required things is
>> defining importance of each node at LRU scanning.
>>
>> This patch defines each node's weight for scan as
>>
>> swappiness = (memcg's swappiness)? memcg's swappiness : 1
>> FILE = inactive_file + (inactive_file_is_low)? active_file : 0
>> ANON = inactive_anon + (inactive_anon_is_low)? active_anon : 0
>>
>> weight = (FILE * (200-swappiness) + ANON * swappiness)/200.
>
> Shouldn't we consider the node size?

Above one cheks FILE+ANON....it's size of node.

> If we have a node which is almost full with file cache and then other
> node wich is much bigger and it is mostly occupied by anonymous memory
> than the other node might end up with higher weight.

I used a porportional fair scheduling in the next patch and I expect I'll not
see heavy starvation of node balancing. And if inactive_anon_is_low(),
the weight of anon-only-node will jump up.

But yes, other "weight" calculation is possible. The point of this patch
series is introducing a scheduler which can handle "weight" of value.

Thanks,
-Kame
