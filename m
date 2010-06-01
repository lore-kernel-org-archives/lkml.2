Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab0FARej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 13:34:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:30226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab0FAReh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 13:34:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=RjKl1Cgavowkz8TOkZNbOx35xxTa0JYM0w++z0advgV9lx6xT48LB0AwVoOfXkk5K
	AxxdZ5QQJtiR/FCfgBJdg==
MIME-Version: 1.0
In-Reply-To: <1275412748.27810.27883.camel@twins>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	<tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	<1275136178.27810.13539.camel@twins>
	<1275139902.27810.13737.camel@twins>
	<AANLkTimZkyRwP5k290rUr-DUMhsynl9fzBkS68x-57KM@mail.gmail.com>
	<1275412748.27810.27883.camel@twins>
Date: Tue, 1 Jun 2010 10:34:31 -0700
Message-ID: <AANLkTilGfY1PnNgpEeB3AQEqTNoDJQfPTxK5LNUYb7ZA@mail.gmail.com>
Subject: Re: [PATCH] rbtree: undo augmented damage -v2
From: Venkatesh Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 10:19 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2010-06-01 at 10:00 -0700, Venkatesh Pallipadi wrote:
>> I am not seeing how this can cover all the callbacks we will need to
>> maintain the augmented tree property. May be I am missing something.
>
> Yes, indeed, how about the below delta, which my eevdf code did do but I
> overlooked on the conversion to the PAT code.
>
> That removes the break as you said, but also adds code to update the
> child nodes when walking up the path.
>
> So in your rotation case:
>
>    G             P
>   / \    -->    / \
>  P   U         N   G
>  /        <--        \
> N                     U
>
> Say we take the right rotation, then the traversal up from N to P will
> find that since N was the left child of P and it has a right child (G)
> it will also update G.

Yes. This will cover all the cases on insert. But on erase, there is
still a case where a rotate of sibling node is done during the
re-coloration process. There we have a child change on sibling's
child. I am not able to think of any easy way to handle that case.

Thanks,
Venki

>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/x86/mm/pat_rbtree.c |   23 ++++++++++++-----------
>  1 files changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/mm/pat_rbtree.c b/arch/x86/mm/pat_rbtree.c
> index f537087..ca19aae 100644
> --- a/arch/x86/mm/pat_rbtree.c
> +++ b/arch/x86/mm/pat_rbtree.c
> @@ -81,20 +81,21 @@ static void update_node_max_end(struct rb_node *node)
>  /* Update 'subtree_max_end' for a node and all its ancestors */
>  static void update_path_max_end(struct rb_node *node)
>  {
> -       u64 old_max_end, new_max_end;
> +       struct rb_node *parent;
>
> -       while (node) {
> -               struct memtype *data = container_of(node, struct memtype, rb);
> -
> -               old_max_end = data->subtree_max_end;
> -               update_node_max_end(node);
> -               new_max_end = data->subtree_max_end;
> +up:
> +       update_node_max_end(node);
> +       parent = rb_parent(node);
> +       if (!parent)
> +               return;
>
> -               if (new_max_end == old_max_end)
> -                       break;
> +       if (node == parent->rb_left && parent->rb_right)
> +               update_node_max_end(parent->rb_right);
> +       else if (parent->rb_left)
> +               update_node_max_end(parent->rb_left);
>
> -               node = rb_parent(node);
> -       }
> +       node = parent;
> +       goto up;
>  }
>
>  /* Find the first (lowest start addr) overlapping range from rb tree */
>
>
