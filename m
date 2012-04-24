Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2DXRQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:16:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756606Ab2DXRQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:16:22 -0400
Message-ID: <4F96DFE0.6040306@redhat.com>
Date: Tue, 24 Apr 2012 13:16:16 -0400
From: Larry Woodman <lwoodman@redhat.com>
Reply-To: lwoodman@redhat.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Thunderbird/3.1.7
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Motohiro Kosaki <mkosaki@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm V2] do_migrate_pages() calls migrate_to_node() even
 if task is already on a correct node
References: <4F96CDE1.5000909@redhat.com> <4F96D27A.2050005@gmail.com>
In-Reply-To: <4F96D27A.2050005@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090308000800040903050102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090308000800040903050102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 04/24/2012 12:19 PM, KOSAKI Motohiro wrote:
>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>> index 47296fe..6c189fa 100644
>> --- a/mm/mempolicy.c
>> +++ b/mm/mempolicy.c
>> @@ -1012,6 +1012,16 @@ int do_migrate_pages(struct mm_struct *mm,
>>          int dest = 0;
>>
>>          for_each_node_mask(s, tmp) {
>> +
>> +            /* IFF there is an equal number of source and
>> +             * destination nodes, maintain relative node distance
>> +             * even when source and destination nodes overlap.
>> +             * However, when the node weight is unequal, never move
>> +             * memory out of any destination nodes */
>
> Please use
>
> /*
>  * foo bar
>  */
>
> style comment. and this comment only explain how code work but don't 
> explain why.
> I hope the comment describe HPC usecase require to migrate if src and 
> dest have the
> same weight.
>
> Otherwise looks ok. please feel free to use my ack to your next spin.
>  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
>
>
>> +            if ((nodes_weight(*from_nodes) != 
>> nodes_weight(*to_nodes)) &&
>> +                        (node_isset(s, *to_nodes)))
>> +                continue;
>> +
>
>
> -- 
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign 
> http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
How does this look:



--------------090308000800040903050102
Content-Type: text/plain;
 name="upstream-do_migrate_pages.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="upstream-do_migrate_pages.patch"

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index f563fa3..b76b49a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1012,6 +1012,24 @@ int do_migrate_pages(struct mm_struct *mm,
 		int dest = 0;
 
 		for_each_node_mask(s, tmp) {
+
+			/*
+			 * IFF there is an equal number of source and
+			 * destination nodes, maintain relative node distance
+			 * even when source and destination nodes overlap.
+			 * However, when the node weight is unequal/there are
+			 * a different number of source and destination nodes,
+			 * never move memory out of a source node that is also
+			 * a destination node.
+			 * 
+			 * Example: [2,3,4] -> [3,4,5] moves everything.
+			 * 	    [0-7] - > [3,4,5] moves only 0,1,2,6,7.
+			 */
+
+			if ((nodes_weight(*from_nodes) != nodes_weight(*to_nodes)) && 
+						(node_isset(s, *to_nodes)))
+				continue;
+
 			d = node_remap(s, *from_nodes, *to_nodes);
 			if (s == d)
 				continue;

--------------090308000800040903050102--
