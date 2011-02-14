Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab1BNQlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:41:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab1BNQls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:41:48 -0500
Date: Mon, 14 Feb 2011 11:41:39 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2] Avoid preferential treatment of groups that aren't
 backlogged
Message-ID: <20110214164139.GC13097@redhat.com>
References: <20110211193930.5454.5874.stgit@neat.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211193930.5454.5874.stgit@neat.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 11, 2011 at 11:39:30AM -0800, Chad Talbott wrote:

[..]
>  static struct cfq_group *cfq_get_next_cfqg(struct cfq_data *cfqd);
> @@ -873,18 +877,13 @@ cfq_group_service_tree_add(struct cfq_data *cfqd, struct cfq_group *cfqg)
>  	if (!RB_EMPTY_NODE(&cfqg->rb_node))
>  		return;
>  
> -	/*
> -	 * Currently put the group at the end. Later implement something
> -	 * so that groups get lesser vtime based on their weights, so that
> -	 * if group does not loose all if it was not continously backlogged.
> -	 */
> -	n = rb_last(&st->rb);
> -	if (n) {
> -		__cfqg = rb_entry_cfqg(n);
> -		cfqg->vdisktime = __cfqg->vdisktime + CFQ_IDLE_DELAY;
> -	} else
> +	if (cfqd->active_generation > cfqg->generation_num)
>  		cfqg->vdisktime = st->min_vdisktime;
> -
> +	else
> +		/* We assume that vdisktime was not modified when the task
> +		   was off the service tree.
> +		 */
> +		cfqg->vdisktime = max(st->min_vdisktime, cfqg->vdisktime);

I think above usage of max() also will give wrong results upon wrapping.
So how about using max_vdisktime() instead? I know that results are not
catastrophic when it happens, still lets use the right thing.

Thanks
Vivek
