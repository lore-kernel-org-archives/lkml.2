Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab2BVAeq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 19:34:46 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53789 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751830Ab2BVAeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 19:34:44 -0500
Message-ID: <4F443814.6050209@fb.com>
Date: Tue, 21 Feb 2012 16:34:28 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Balbir Singh <bsingharora@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
References: <1326912662-18805-1-git-send-email-asharma@fb.com> <20120119114206.653b88bd.kamezawa.hiroyu@jp.fujitsu.com> <4F1E013E.9060009@fb.com> <20120124120704.3f09b206.kamezawa.hiroyu@jp.fujitsu.com> <4F1F5EB8.3000407@fb.com>
In-Reply-To: <4F1F5EB8.3000407@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.260,0.0.0000
 definitions=2012-02-21_09:2012-02-21,2012-02-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/12 5:45 PM, Arun Sharma wrote:
> On 1/23/12 7:07 PM, KAMEZAWA Hiroyuki wrote:
>
>> You can see reduction of clear_page() cost by removing GFP_ZERO but
>> what's your application's total performance ? Is it good enough
>> considering
>> many risks ?
>
> I see 90k calls/sec to clear_page_c when running our application. I
> don't have data on the impact of GFP_ZERO alone, but an earlier
> experiment when we tuned malloc to not call madvise(MADV_DONTNEED)
> aggressively saved us 3% CPU. So I'm expecting this to be a 1-2% win.

I saw some additional measurement data today.

We were running at a lower-than-default value for the rate at which our 
malloc implementation releases unused faulted-in memory to the kernel 
via madvise(). This was done just to reduce the impact of clear_page() 
on application performance. But it cost us at least several hundred megs 
(if not more) in additional RSS.

We compared the impact of increasing the madvise rate to the default[1]. 
This used to cause a 3% CPU regression earlier. But with the patch, the 
regression was completely gone and we recovered a bunch of memory in 
terms of reduced RSS.

Hope this additional data is useful. Happy to clean up the patch and 
implement the opt-in flags.

  -Arun

[1] The default rate is 32:1, i.e. no more than 1/32th of the heap is 
unused and dirty (i.e. contributing to RSS).
