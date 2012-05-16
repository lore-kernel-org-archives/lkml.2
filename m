Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab2EPWMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:12:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab2EPWMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:12:22 -0400
Date: Wed, 16 May 2012 15:12:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Ledford <dledford@redhat.com>
Cc: manfred@colorfullife.com, levinsasha928@gmail.com, npiggin@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch] ipc/mqueue: add rbtree node caching support
Message-Id: <20120516151219.e4d55c81.akpm@linux-foundation.org>
In-Reply-To: <34c33c51dbd2ab946a19563b790b5e1be8f751d2.1337196473.git.dledford@redhat.com>
References: <34c33c51dbd2ab946a19563b790b5e1be8f751d2.1337196473.git.dledford@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2012 15:28:56 -0400
Doug Ledford <dledford@redhat.com> wrote:

> When I wrote the first patch that added the rbtree support for message
> queue insertion, it sped up the case where the queue was very full
> drastically from the original code.  It, however, slowed down the
> case where the queue was empty (not drastically though).
> 
> This patch caches the last freed rbtree node struct so we can quickly
> reuse it when we get a new message.  This is the common path for any
> queue that very frequently goes from 0 to 1 then back to 0 messages
> in queue.
> 
> Andrew Morton didn't like that we were doing a GFP_ATOMIC allocation
> in msg_insert, so this patch attempts to speculatively allocate a
> new node struct outside of the spin lock when we know we need it, but
> will still fall back to a GFP_ATOMIC allocation if it has to.
> 
> Once I added the caching, the necessary various ret = ; spin_unlock
> gyrations in mq_timedsend were getting pretty ugly, so this also slightly
> refactors that function to streamline the flow of the code and the
> function exit.
> 
> Finally, while working on getting performance back I made sure that all
> of the node structs were always fully initialized when they were first
> used, rendering the use of kzalloc unnecessary and a waste of CPU cycles.
> 
> The net result of all of this is:
> 
> 1) We will avoid a GFP_ATOMIC allocation when possible, but fall back on
> it when necessary.
> 2) We will speculatively allocate a node struct using GFP_KERNEL if our
> cache is empty (and save the struct to our cache if it's still empty after
> we have obtained the spin lock).
> 3) The performance of the common queue empty case has significantly
> improved and is now much more in line with the older performance for
> this case.
> 
> The performance changes are:
> 
>             Old mqueue      new mqueue      new mqueue + caching
> queue empty
> send/recv   305/288ns       349/318ns       310/322ns
> 
> I don't think we'll ever be able to get the recv performance back, but
> that's because the old recv performance was a direct result and consequence
> of the old methods abysmal send performance.  The recv path simply must
> do more so that the send path does not incur such a penalty under higher
> queue depths.
> 
> As it turns out, the new caching code also sped up the various queue full
> cases relative to my last patch.  That could be because of the difference
> between the syscall path in 3.3.4-rc5 and 3.3.4-rc6, or because of the
> change in code flow in the mq_timedsend routine.  Regardless, I'll take
> it.  It wasn't huge, and I *would* say it was within the margin for error,
> but after many repeated runs what I'm seeing is that the old numbers
> trend slightly higher (about 10 to 20ns depending on which test is the
> one running).
> 

LGTM.  Here be some coding-style fixes:

--- a/ipc/mqueue.c~ipc-mqueue-add-rbtree-node-caching-support-fix
+++ a/ipc/mqueue.c
@@ -141,16 +141,18 @@ static int msg_insert(struct msg_msg *ms
 	} else if (new_leaf) {
 		leaf = *new_leaf;
 		*new_leaf = NULL;
-	} else
+	} else {
 		leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
+	}
 	if (!leaf)
 		return -ENOMEM;
 	if (!info->node_cache) {
 		rb_init_node(&leaf->rb_node);
 		INIT_LIST_HEAD(&leaf->msg_list);
 		info->qsize += sizeof(*leaf);
-	} else
+	} else {
 		info->node_cache = NULL;
+	}
 	leaf->priority = msg->m_type;
 	rb_link_node(&leaf->rb_node, parent, p);
 	rb_insert_color(&leaf->rb_node, &info->msg_tree);
@@ -196,8 +198,9 @@ try_again:
 		if (info->node_cache) {
 			info->qsize -= sizeof(*leaf);
 			kfree(leaf);
-		} else
+		} else {
 			info->node_cache = leaf;
+		}
 		goto try_again;
 	} else {
 		msg = list_first_entry(&leaf->msg_list,
@@ -208,8 +211,9 @@ try_again:
 			if (info->node_cache) {
 				info->qsize -= sizeof(*leaf);
 				kfree(leaf);
-			} else
+			} else {
 				info->node_cache = leaf;
+			}
 		}
 	}
 	info->attr.mq_curmsgs--;
@@ -1033,9 +1037,11 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 	msg_ptr->m_ts = msg_len;
 	msg_ptr->m_type = msg_prio;
 
-	/* msg_insert really wants us to have a valid, spare node struct so
-	 * it doesn't have to kmalloc a GFP_ATOMIC allocation, but it will
-	 * fall back to that if necessary. */
+	/*
+	 * msg_insert really wants us to have a valid, spare node struct so it
+	 * doesn't have to kmalloc a GFP_ATOMIC allocation, but it will fall
+	 * back to that if necessary.
+	 */
 	if (!info->node_cache)
 		new_leaf = kmalloc(sizeof(*new_leaf), GFP_KERNEL);
 
@@ -1058,8 +1064,10 @@ SYSCALL_DEFINE5(mq_timedsend, mqd_t, mqd
 			wait.msg = (void *) msg_ptr;
 			wait.state = STATE_NONE;
 			ret = wq_sleep(info, SEND, timeout, &wait);
-			/* wq_sleep must be called with info->lock held, and
-			 * returns with the lock released */
+			/*
+			 * wq_sleep must be called with info->lock held, and
+			 * returns with the lock released
+			 */
 			goto out_free;
 		}
 	} else {
@@ -1136,9 +1144,11 @@ SYSCALL_DEFINE5(mq_timedreceive, mqd_t, 
 		goto out_fput;
 	}
 
-	/* msg_insert really wants us to have a valid, spare node struct so
-	 * it doesn't have to kmalloc a GFP_ATOMIC allocation, but it will
-	 * fall back to that if necessary. */
+	/*
+	 * msg_insert really wants us to have a valid, spare node struct so it
+	 * doesn't have to kmalloc a GFP_ATOMIC allocation, but it will fall
+	 * back to that if necessary.
+	 */
 	if (!info->node_cache)
 		new_leaf = kmalloc(sizeof(*new_leaf), GFP_KERNEL);
 


> @@ -132,15 +134,24 @@ static int msg_insert(struct msg_msg *msg, struct mqueue_inode_info *info)
>  		else
>  			p = &(*p)->rb_right;
>  	}
> -	leaf = kzalloc(sizeof(*leaf), GFP_ATOMIC);
> +	if (info->node_cache) {
> +		leaf = info->node_cache;
> +	} else if (new_leaf) {
> +		leaf = *new_leaf;
> +		*new_leaf = NULL;
> +	} else
> +		leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
>  	if (!leaf)
>  		return -ENOMEM;
> -	rb_init_node(&leaf->rb_node);
> -	INIT_LIST_HEAD(&leaf->msg_list);
> +	if (!info->node_cache) {
> +		rb_init_node(&leaf->rb_node);
> +		INIT_LIST_HEAD(&leaf->msg_list);
> +		info->qsize += sizeof(*leaf);
> +	} else
> +		info->node_cache = NULL;

So you have

: 	if (info->node_cache) {
: 		leaf = info->node_cache;
: 	} else if (new_leaf) {
: 		leaf = *new_leaf;
: 		*new_leaf = NULL;
: 	} else {
: 		leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
: 	}
: 	if (!leaf)
: 		return -ENOMEM;
: 	if (!info->node_cache) {
: 		rb_init_node(&leaf->rb_node);
: 		INIT_LIST_HEAD(&leaf->msg_list);
: 		info->qsize += sizeof(*leaf);
: 	} else {
: 		info->node_cache = NULL;
:	}
 
But I think it's a bit simpler to do

: 	if (info->node_cache) {
: 		leaf = info->node_cache;
: 		info->node_cache = NULL;
: 	} else {
: 		if (new_leaf) {
: 			leaf = *new_leaf;
: 			*new_leaf = NULL;
: 		} else {
: 			leaf = kmalloc(sizeof(*leaf), GFP_ATOMIC);
: 			if (!leaf)
: 				return -ENOMEM;
: 		}
: 		rb_init_node(&leaf->rb_node);
: 		INIT_LIST_HEAD(&leaf->msg_list);
: 		info->qsize += sizeof(*leaf);
: 	}

and my version generates 25 bytes less text.

But why did we need to initialise *leaf's fields if the caller passed
us something in *new_leaf?  sys_mq_timedsend() already initialised the
fields for us?


