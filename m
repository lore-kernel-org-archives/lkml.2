Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab2C2UCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 16:02:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759350Ab2C2UCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 16:02:03 -0400
Message-ID: <4F74BFB6.5090204@redhat.com>
Date: Thu, 29 Mar 2012 16:01:58 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com> <alpine.DEB.2.00.1203221421570.25011@router.home> <4F74A344.7070805@redhat.com> <4F74BB67.30703@gmail.com>
In-Reply-To: <4F74BB67.30703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2012 03:43 PM, KOSAKI Motohiro wrote:
> (3/29/12 2:00 PM), Larry Woodman wrote:
>> On 03/22/2012 03:30 PM, Christoph Lameter wrote:
>>> On Thu, 22 Mar 2012, Larry Woodman wrote:
>>>
>>>>> Application may manage their locality given a range of nodes and 
>>>>> each of
>>>>> the x .. x+n nodes has their particular purpose.
>>>> So to be clear on this, in that case the intention would be move 3 
>>>> to 4, 4 to
>>>> 5 and 5 to 6
>>>> to keep the node ordering the same?
>>> Yup. Have a look at do_migrate_pages and the descrition in the 
>>> comment by
>>> there by Paul Jackson.
>>>
>>>
>> Christoph and others what do you think about this???
>>
>>
>>         for_each_node_mask(s, tmp) {
>> +
>> +            /* IFF there is an equal number of source and
>> +             * destination nodes, maintain relative node distance
>> +             * even when source and destination nodes overlap.
>> +             * However, when the node weight is unequal, never move
>> +             * memory out of any destination nodes */
>> +            if ((nodes_weight(*from_nodes) != 
>> nodes_weight(*to_nodes)) &&
>> +                        (node_isset(s, *to_nodes)))
>> +                continue;
>> +
>>             d = node_remap(s, *from_nodes, *to_nodes);
>>             if (s == d)
>>                 continue;
>
> I'm confused. Could you please explain why you choose nodes_weight()? 
> On my first impression,
> it seems almostly unrelated factor.

nodes_weight() tells us the number of nodes in the cpuset so if you are 
migrating
from say 2, 3 &4 to 3, 4 &5 we wont go from 2 to 5 and call it done like 
the original
patch did.  With this patch we will preserve the migrating of 2, 3 &4 to 
3, 4 &5  yet
if we are migrating from 0-7 to 3-4 we wont do this:

Migrating 7 to 4
Migrating 6 to 3
Migrating 5 to 4
Migrating 4 to 3
Migrating 1 to 4
Migrating 3 to 4
Migrating 0 to 3
Migrating 2 to 3

Instead, will do this:

Migrating 7 to 4
Migrating 6 to 3
Migrating 5 to 4
Migrating 1 to 4
Migrating 0 to 3
Migrating 2 to 3

Larry

>
>
> -- 
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign 
> http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

