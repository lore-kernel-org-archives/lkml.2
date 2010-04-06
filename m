Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab0DFTQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920Ab0DFTQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:16:25 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <25610.1270579965@redhat.com>
References: <25610.1270579965@redhat.com> <20100406170903.GH5288@laptop> <23428.1270570789@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: dhowells@redhat.com, paulmck@linux.vnet.ibm.com, corbet@lwn.net,
       linux-kernel@vger.kernel.org, linux-cachefs@redhat.com
Subject: Re: An incorrect assumption over radix_tree_tag_get()
Date: Tue, 06 Apr 2010 20:16:11 +0100
Message-ID: <26067.1270581371@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Nick Piggin <npiggin@suse.de> wrote:
> 
> > It is safe. Synchronization requirements for using the radix tree API
> > are documented.
> 
> I presume you mean the big comment on it in radix-tree.h.
> 
> According to that, it is not safe:
> 
>  * - any function _modifying_ the tree or tags (inserting or deleting
>  *   items, setting or clearing tags) must exclude other modifications, and
>  *   exclude any functions reading the tree.

Having said that, the next few lines, say that it is:

 * The notable exceptions to this rule are the following functions:
 * radix_tree_lookup
 * radix_tree_lookup_slot
 * radix_tree_tag_get
 * radix_tree_gang_lookup
 * radix_tree_gang_lookup_slot
 * radix_tree_gang_lookup_tag
 * radix_tree_gang_lookup_tag_slot
 * radix_tree_tagged

However, I'm not sure I agree that radix_tree_tag_get() belongs in this list.

The bug symptoms are this:

Someone is seeing is a bug with an apparently corrupt radix tree tag chain
being observed in radix_tree_tag_get().  Leastways, the BUG() on line 602 in
radix_tree_tag_get() trips once in a while:

	kernel BUG at
		/usr/src/linux-2.6-2.6.33/debian/build/source_i386_none/lib/radix-tree.c:602!
	RIP: 0010:[<ffffffff81182040>] radix_tree_tag_get+0xbc/0xe3
	 [<ffffffffa0247b67>] ? __fscache_maybe_release_page+0x42/0x115
	 [<ffffffffa0372e7d>] ? nfs_fscache_release_page+0x66/0x99 [nfs]
	 [<ffffffff810b6dee>] ? invalidate_inode_pages2_range+0x15a/0x262
	 [<ffffffffa035312f>] ? nfs_invalidate_mapping_nolock+0x18/0xb4
	 [<ffffffffa0354097>] ? nfs_revalidate_mapping+0x85/0x99 [nfs]
	 [<ffffffffa0351158>] ? nfs_file_splice_read+0x5b/0x8e [nfs]
	 [<ffffffff811043d3>] ? splice_direct_to_actor+0xbe/0x188
	 [<ffffffff81104a1c>] ? direct_splice_actor+0x0/0x1e
	 [<ffffffff81113274>] ? ep_scan_ready_list+0x132/0x151
	 [<ffffffff811044e7>] ? do_splice_direct+0x4a/0x64
	 [<ffffffff810e8fa8>] ? do_sendfile+0x12d/0x1a8
	 [<ffffffff8106685b>] ? getnstimeofday+0x55/0xaf
	 [<ffffffff810e906c>] ? sys_sendfile64+0x49/0x88
	 [<ffffffff8103145f>] ? sysenter_dispatch+0x7/0x2e

which is this:

		if (!tag_get(node, tag, offset))
			saw_unset_tag = 1;
		if (height == 1) {
			int ret = tag_get(node, tag, offset);

	-->		BUG_ON(ret && saw_unset_tag);
			return !!ret;
		}

In fs/fscache/page.c, __fscache_maybe_release_page() does a radix_tree_lookup()
with just the RCU read lock held, and then calls radix_tree_tag_get() a couple
of times.  In this case, it's the first instance, before we grab the
stores_lock spinlock (which is used to serialise alteration of the radix tree)
that is the problem:

	/* see if the page is actually undergoing storage - if so we can't get
	 * rid of it till the cache has finished with it */
	if (radix_tree_tag_get(&cookie->stores, page->index,
			       FSCACHE_COOKIE_STORING_TAG)) {
		rcu_read_unlock();
		goto page_busy;
	}

Looking at radix_tree_tag_get(), I can see that it carefully uses
rcu_dereference_raw() to protect itself against pointer modification - but
looking at radix_tree_tag_set/clear(), no pointers are modified, no nodes are
replaced.  radix_tree_tag_get()'s attempts to protect itself count for nothing
as set/clear() modify the node directly.

So, what I'm seeing is that the two calls to tag_get() on the same bit
occasionally show a different value, and, looking at the code, I can't see any
reason for the confidence displayed in the documenation that this cannot
happen.

David
