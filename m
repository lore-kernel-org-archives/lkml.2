Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab2DXQTD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:19:03 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:37470 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab2DXQTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:19:01 -0400
Message-ID: <4F96D27A.2050005@gmail.com>
Date: Tue, 24 Apr 2012 12:19:06 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: lwoodman@redhat.com
CC: linux-mm@kvack.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Motohiro Kosaki <mkosaki@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, kosaki.motohiro@gmail.com
Subject: Re: [PATCH -mm V2] do_migrate_pages() calls migrate_to_node() even
 if task is already on a correct node
References: <4F96CDE1.5000909@redhat.com>
In-Reply-To: <4F96CDE1.5000909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 47296fe..6c189fa 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1012,6 +1012,16 @@ int do_migrate_pages(struct mm_struct *mm,
>  		int dest = 0;
>
>  		for_each_node_mask(s, tmp) {
> +
> +			/* IFF there is an equal number of source and
> +			 * destination nodes, maintain relative node distance
> +			 * even when source and destination nodes overlap.
> +			 * However, when the node weight is unequal, never move
> +			 * memory out of any destination nodes */

Please use

/*
  * foo bar
  */

style comment. and this comment only explain how code work but don't explain why.
I hope the comment describe HPC usecase require to migrate if src and dest have the
same weight.

Otherwise looks ok. please feel free to use my ack to your next spin.
  Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



> +			if ((nodes_weight(*from_nodes) != nodes_weight(*to_nodes)) &&
> +						(node_isset(s, *to_nodes)))
> +				continue;
> +


