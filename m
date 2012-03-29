Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752Ab2C2SAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 14:00:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645Ab2C2SAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 14:00:43 -0400
Message-ID: <4F74A344.7070805@redhat.com>
Date: Thu, 29 Mar 2012 14:00:36 -0400
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
References: <4F6B6BFF.1020701@redhat.com> <4F6B7358.60800@gmail.com> <alpine.DEB.2.00.1203221348470.25011@router.home> <4F6B7854.1040203@redhat.com> <alpine.DEB.2.00.1203221421570.25011@router.home>
In-Reply-To: <alpine.DEB.2.00.1203221421570.25011@router.home>
Content-Type: multipart/mixed;
 boundary="------------000106060008000500010905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000106060008000500010905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/22/2012 03:30 PM, Christoph Lameter wrote:
> On Thu, 22 Mar 2012, Larry Woodman wrote:
>
>>> Application may manage their locality given a range of nodes and each of
>>> the x .. x+n nodes has their particular purpose.
>> So to be clear on this, in that case the intention would be move 3 to 4, 4 to
>> 5 and 5 to 6
>> to keep the node ordering the same?
> Yup. Have a look at do_migrate_pages and the descrition in the comment by
> there by Paul Jackson.
>
>
Christoph and others what do you think about this???



--------------000106060008000500010905
Content-Type: text/plain;
 name="upstream-do_migrate_pages.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="upstream-do_migrate_pages.patch"

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 47296fe..6c189fa 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1012,6 +1012,16 @@ int do_migrate_pages(struct mm_struct *mm,
 		int dest = 0;
 
 		for_each_node_mask(s, tmp) {
+
+			/* IFF there is an equal number of source and
+			 * destination nodes, maintain relative node distance
+			 * even when source and destination nodes overlap.
+			 * However, when the node weight is unequal, never move
+			 * memory out of any destination nodes */
+			if ((nodes_weight(*from_nodes) != nodes_weight(*to_nodes)) && 
+						(node_isset(s, *to_nodes)))
+				continue;
+
 			d = node_remap(s, *from_nodes, *to_nodes);
 			if (s == d)
 				continue;

--------------000106060008000500010905--
