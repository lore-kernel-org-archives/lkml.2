Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab2HaQXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:23:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64972 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab2HaQXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:23:03 -0400
Message-ID: <5040E4E5.6040905@gmail.com>
Date: Fri, 31 Aug 2012 10:23:01 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [perf] Account the nr_entries in rblist properly
References: <20120831070834.14806.87398.stgit@suzukikp.in.ibm.com>
In-Reply-To: <20120831070834.14806.87398.stgit@suzukikp.in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/12 1:09 AM, Suzuki K. Poulose wrote:
> The nr_entries in rblist is never decremented when an element
> is deleted. Also, use rblist__remove_node to delete a node in
> rblist__delete(). This would keep the nr_entries sane.
>
> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
> Cc: David S. Ahern <dsahern@gmail.com>
> ---
>
>   tools/perf/util/rblist.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/util/rblist.c b/tools/perf/util/rblist.c
> index 0171fb6..a16cdd2 100644
> --- a/tools/perf/util/rblist.c
> +++ b/tools/perf/util/rblist.c
> @@ -44,6 +44,7 @@ int rblist__add_node(struct rblist *rblist, const void *new_entry)
>   void rblist__remove_node(struct rblist *rblist, struct rb_node *rb_node)
>   {
>   	rb_erase(rb_node, &rblist->entries);
> +	--rblist->nr_entries;
>   	rblist->node_delete(rblist, rb_node);
>   }

nice catch.

>
> @@ -87,8 +88,7 @@ void rblist__delete(struct rblist *rblist)
>   		while (next) {
>   			pos = next;
>   			next = rb_next(pos);
> -			rb_erase(pos, &rblist->entries);
> -			rblist->node_delete(rblist, pos);
> +			rblist__remove_node(rblist, pos);
>   		}
>   		free(rblist);
>   	}

Acked-by: David Ahern <dsahern@gmail.com>

