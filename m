Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab2K2ASG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 19:18:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab2K2ASE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 19:18:04 -0500
Date: Wed, 28 Nov 2012 16:17:59 -0800
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, bcrl@kvack.org, jmoyer@redhat.com,
        axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 12/25] aio: Refcounting cleanup
Message-ID: <20121129001759.GH18574@lenny.home.zabbo.net>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-13-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354121029-1376-13-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  struct kioctx {
>  	atomic_t		users;
> -	int			dead;
> +	atomic_t		dead;

Do we want to be paranoid and atomic_set() that to 0 when the ioctx is
allocated?

> +	while (!list_empty(&ctx->active_reqs)) {
> +		struct list_head *pos = ctx->active_reqs.next;
> +		struct kiocb *iocb = list_kiocb(pos);

I'd use list_first_entry() and ignore the list_kiocb() wrapper, I think.

> +	if (!atomic_xchg(&ctx->dead, 1)) {
> +		hlist_del_rcu(&ctx->list);
> +		synchronize_rcu();

> +	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list)
> +		if (ctx->user_id == ctx_id){
> +			BUG_ON(atomic_read(&ctx->dead));

Hmm.  Won't it be possible to race lookup and io_destroy() to hit this
BUG?

- z
