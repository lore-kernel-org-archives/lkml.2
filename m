Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825Ab2CDHnr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 02:43:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41411 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab2CDHnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 02:43:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.204.152.219 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Message-ID: <4F531D2C.7090105@openvz.org>
Date: Sun, 04 Mar 2012 11:43:40 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 3.3] memcg: fix GPF when cgroup removal races with last
 exit
References: <alpine.LSU.2.00.1203021030140.2094@eggly.anvils> <4F51E4B1.4010607@openvz.org>
In-Reply-To: <4F51E4B1.4010607@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Khlebnikov wrote:
> Hugh Dickins wrote:
>>
>> Konstantin, I've not yet looked into how this patch affects your
>> patchsets; but I do know that this surreptitious-switch-to-root
>> behaviour seemed nightmarish when I was doing per-memcg per-zone
>> locking (particularly inside something like __activate_page(), where
>> we del and add under a single lock), and unnecessary once you and I
>> secure the memcg differently.  So you may just want to revert this in
>> patches for linux-next; but I've a suspicion that now we understand
>> it better, this technique might still be usable, and more efficient.
>
> Yes, something like that. But, I  must fix my "isolated-pages" counters first,
> otherwise I just reintroduce this bug again.
>

I have thought little more and invented better approach: we can keep isolated pages
counted in lruvec->lru_size[] and vmstat counters. Thus isolated pages will prevent
removing it's memory cgroup. This method is more complicated than your tricky pushing
pages to root lruvec, but it more generic and does not adds new page-counters.
