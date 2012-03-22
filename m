Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759294Ab2CVTHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:07:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab2CVTHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:07:06 -0400
Message-ID: <4F6B7854.1040203@redhat.com>
Date: Thu, 22 Mar 2012 15:07:00 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home>
In-Reply-To: <alpine.DEB.2.00.1203221348470.25011@router.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 02:51 PM, Christoph Lameter wrote:
> On Thu, 22 Mar 2012, KOSAKI Motohiro wrote:
>
>> CC to Christoph.
>>
>>> While moving tasks between cpusets I noticed some strange behavior.
>>> Specifically if the nodes of the destination
>>> cpuset are a subset of the nodes of the source cpuset do_migrate_pages()
>>> will move pages that are already on a node
>>> in the destination cpuset. The reason for this is do_migrate_pages() does
>>> not check whether each node in the source
>>> nodemask is in the destination nodemask before calling migrate_to_node(). If
>>> we simply do this check and skip them
>>> when the source is in the destination moving we wont move nodes that dont
>>> need to be moved.
>>>
>>> Adding a little debug printk to migrate_to_node():
>>>
>>> Without this change migrating tasks from a cpuset containing nodes 0-7 to a
>>> cpuset containing nodes 3-4, we migrate
>>> from ALL the nodes even if they are in the both the source and destination
>>> nodesets:
>>>
>>> Migrating 7 to 4
>>> Migrating 6 to 3
>>> Migrating 5 to 4
>>> Migrating 4 to 3
>>> Migrating 1 to 4
>>> Migrating 3 to 4
>>> Migrating 0 to 3
>>> Migrating 2 to 3
>> Wait.
>>
>> This may be non-optimal for cpusets, but maybe optimal migrate_pages,
>> especially
>> the usecase is HPC. I guess this is intended behavior. I think we need to hear
>> Christoph's intention.
>>
>> But, I'm not against this if he has no objection.
> The use case for this is if you have an app running on nodes 3,4,5 on your
> machine and now you want to shift it to 4,5,6. The expectation is that the
> location of the pages relative to the first node stay the same.
> Application may manage their locality given a range of nodes and each of
> the x .. x+n nodes has their particular purpose.
So to be clear on this, in that case the intention would be move 3 to 4, 
4 to 5 and 5 to 6
to keep the node ordering the same?

Larry
> If you justd copy 3 to 6 then the app may get confused when doing
> additional allocations since different types of information is now stored
> on the "first" node (which is now 4).
>
>
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email:<a href=mailto:"dont@kvack.org">  email@kvack.org</a>

