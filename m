Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354Ab2CVTHi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:07:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759274Ab2CVTHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:07:35 -0400
Message-ID: <4F6B787B.4050109@redhat.com>
Date: Thu, 22 Mar 2012 15:07:39 -0400
From: KOSAKI Motohiro <mkosaki@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, lwoodman@redhat.com,
        linux-mm@kvack.org,
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

(3/22/12 2:51 PM), Christoph Lameter wrote:
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
>>
>> Wait.
>>
>> This may be non-optimal for cpusets, but maybe optimal migrate_pages,
>> especially
>> the usecase is HPC. I guess this is intended behavior. I think we need to hear
>> Christoph's intention.
>>
>> But, I'm not against this if he has no objection.
>
> The use case for this is if you have an app running on nodes 3,4,5 on your
> machine and now you want to shift it to 4,5,6. The expectation is that the
> location of the pages relative to the first node stay the same.
> Application may manage their locality given a range of nodes and each of
> the x .. x+n nodes has their particular purpose.
>
> If you justd copy 3 to 6 then the app may get confused when doing
> additional allocations since different types of information is now stored
> on the "first" node (which is now 4).

MPOL_INTERLEAVE is more simple situaltion. applications naturally assume the
memory is mapped intealeaving and application threads optimize for it. if we
broke intereaving, the applications may slow down.

