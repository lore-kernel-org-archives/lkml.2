Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759459Ab1FWOKO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 10:10:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab1FWOKM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 10:10:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SW+/LeYcVjCSWLVsCaxz0VZY69xPH0/Yx1ZwomrzDDFhgMD3l61+KLiaj81ll4boYN
         s0wkXeNt3XYVdn5kJXZ24I47sn5L7Az/3jipeXROZ9mrSEqUfW9Yy3zZgFYQf74SlDmH
         WL8pTkK4F5HNDCMfGTTZu/PmHDYDON4f2Teig=
MIME-Version: 1.0
In-Reply-To: <20110623134850.GK31593@tiehlicka.suse.cz>
References: <20110616124730.d6960b8b.kamezawa.hiroyu@jp.fujitsu.com>
	<20110616125741.c3d6a802.kamezawa.hiroyu@jp.fujitsu.com>
	<20110623134850.GK31593@tiehlicka.suse.cz>
Date: Thu, 23 Jun 2011 23:10:11 +0900
Message-ID: <BANLkTin0zMftnK2a+ex07JNdbwvEMCjXXQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] memcg: proportional fair vicitm node selection
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/23 Michal Hocko <mhocko@suse.cz>:
> On Thu 16-06-11 12:57:41, KAMEZAWA Hiroyuki wrote:
>> From 4fbd49697456c227c86f1d5b46f2cd2169bf1c5b Mon Sep 17 00:00:00 2001
>> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> Date: Thu, 16 Jun 2011 11:25:23 +0900
>> Subject: [PATCH 7/7] memcg: proportional fair node vicitm selection
>>
>> commit 889976 implements a round-robin scan of numa nodes for
>> LRU scanning of memcg at hitting limit.
>> But, round-robin is not very good.
>>
>> This patch implements a proportionally fair victim selection of nodes
>> rather than round-robin. The logic is fair against each node's weight.
>>
>> Each node's weight is calculated periodically and we build an node's
>> scheduling entity as
>>
>>      total_ticket = 0;
>>      for_each_node(node)
>>       node->ticket_start =  total_ticket;
>>         node->ticket_end   =  total_ticket + this_node's_weight()
>>         total_ticket = node->ticket_end;
>>
>> Then, each nodes has some amounts of tickets in proportion to its own weight.
>>
>> At selecting victim, a random number is selected and the node which contains
>> the random number in [ticket_start, ticket_end) is selected as vicitm.
>> This is a lottery scheduling algorithm.
>>
>> For quick search of victim, this patch uses bsearch().
>>
>> Test result:
>>   on 8cpu box with 2 nodes.
>>   limit memory to be 300MB and run httpd for 4096files/600MB working set.
>>   do (normalized) random access by apache-bench and see scan_stat.
>>   The test makes 40960 request. and see scan_stat.
>>   (Because a httpd thread just use 10% cpu, the number of threads will
>>    not be balanced between nodes. Then, file caches will not be balanced
>>    between nodes.)
>
> Have you also tried to test with balanced nodes? I mean, is there any
> measurable overhead?
>

Not enough yet. I checked OOM trouble this week :).

I may need to make another fake_numa setup + cpuset
to measurements. In usual path, new overhead is random32() and
bsearch().  I'll do some.

Thanks,
-Kame
