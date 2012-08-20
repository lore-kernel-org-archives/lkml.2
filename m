Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab2HTWRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 18:17:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38962 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2HTWRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 18:17:12 -0400
Date: Mon, 20 Aug 2012 15:17:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: riel@redhat.com, peterz@infradead.org, daniel.santos@pobox.com,
        aarcange@redhat.com, dwmw2@infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH v3 2/9] rbtree: add __rb_change_child() helper function
Message-Id: <20120820151710.eeed9bcf.akpm@linux-foundation.org>
In-Reply-To: <1345500331-10546-3-git-send-email-walken@google.com>
References: <1345500331-10546-1-git-send-email-walken@google.com>
	<1345500331-10546-3-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012 15:05:24 -0700
Michel Lespinasse <walken@google.com> wrote:

> Add __rb_change_child() as an inline helper function to replace code that
> would otherwise be duplicated 4 times in the source.
> 
> No changes to binary size or speed.
> 
> ...
>
> --- a/lib/rbtree.c
> +++ b/lib/rbtree.c
> @@ -66,6 +66,19 @@ static inline struct rb_node *rb_red_parent(struct rb_node *red)
>  	return (struct rb_node *)red->__rb_parent_color;
>  }
>  
> +static inline void
> +__rb_change_child(struct rb_node *old, struct rb_node *new,
> +		  struct rb_node *parent, struct rb_root *root)
> +{
> +	if (parent) {
> +		if (parent->rb_left == old)
> +			parent->rb_left = new;
> +		else
> +			parent->rb_right = new;
> +	} else
> +		root->rb_node = new;
> +}

I'm inclined to agree with Peter here - "inline" is now a vague,
pathetic and useless thing.  The problem is that the reader just
doesn't *know* whether or not the writer really wanted it to be
inlined.

If we have carefully made a decision to inline a function, we should
(now) use __always_inline.

If we have carefully made a decision to not inline a function, we
should use noinline.

If we don't care, we should omit all such markings.

This leaves no place for "inline"?


Marking it noinline shrinks the text by 60-odd bytes.  Given the number
of args, my gut feel is that this will be slower, despite the cache
benefit.  But that might be wrong.

