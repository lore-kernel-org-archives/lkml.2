Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2AXAy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 19:54:26 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38956 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab2AXAyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 19:54:25 -0500
Message-ID: <4F1E013E.9060009@fb.com>
Date: Mon, 23 Jan 2012 16:54:22 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Balbir Singh <bsingharora@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
References: <1326912662-18805-1-git-send-email-asharma@fb.com> <20120119114206.653b88bd.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120119114206.653b88bd.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-23_06:2012-01-24,2012-01-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/18/12 6:42 PM, KAMEZAWA Hiroyuki wrote:
>
> Hmm, then,
> 1. a new task jumped into this cgroup can see any uncleared data...
> 2. if a memcg pointer is reused, the information will be leaked.

You're suggesting mm_match_cgroup() is good enough for accounting 
purposes, but not usable for cases where its important to get the 
equality right?

> 3. If VM_UNINITALIZED is set, the process can see any data which
>     was freed by other process which doesn't know VM_UNINITALIZED at all.
>
> 4. The process will be able to see file cache data which the it has no
>     access right if it's accessed by memcg once.
>
> 3&  4 seems too danger.

Yes - these are the risks that I'm hoping we can document, so the 
cgroups admin can avoid opting-in if not everything running in the 
cgroup is trusted.

>
> Isn't it better to have this as per-task rather than per-memcg ?
> And just allow to reuse pages the page has freed ?
>

I'm worrying that the additional complexity of maintaining a per-task 
page list would be a problem. It might slow down workloads that 
alloc/free a lot because of the added code. It'll probably touch the 
kswapd as well (for reclaiming pages from the per-task free lists under 
low mem conditions).

Did you have some implementation ideas which would not have the problems 
above?

  -Arun
