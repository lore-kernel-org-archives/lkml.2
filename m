Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761Ab2AQR0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:26:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:55747 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2AQR02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:26:28 -0500
Date: Tue, 17 Jan 2012 12:22:29 -0500 (EST)
Message-Id: <20120117.122229.323838457367599504.davem@davemloft.net>
To: sivanich@sgi.com
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        jkosina@suse.cz, avi@redhat.com, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Fix panic in __d_lookup with high dentry hashtable
 counts
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120117171352.GA18738@sgi.com>
References: <20120113155237.GA25103@sgi.com>
	<20120113162236.GK23916@ZenIV.linux.org.uk>
	<20120117171352.GA18738@sgi.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 17 Jan 2012 09:22:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dimitri Sivanich <sivanich@sgi.com>
Date: Tue, 17 Jan 2012 11:13:52 -0600

> When the number of dentry cache hash table entries gets too high
> (2147483648 entries), as happens by default on a 16TB system, use
> of a signed integer in the dcache_init() initialization loop prevents
> the dentry_hashtable from getting initialized, causing a panic in
> __d_lookup().
> 
> In addition, the _hash_mask returned from alloc_large_system_hash() does
> not support more than a 32 bit hash table size.
> 
> Changing the _hash_mask size returned from alloc_large_system_hash() to
> support larger hash table sizes in the future, and changing loop counter
> sizes appropriately.
> 
> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

To be honest I think this is overkill.

Supporting anything larger than a 32-bit hash mask is not even close
to being reasonable.  Nobody needs a 4GB hash table, not for anything.

Instead I would just make sure everything is "unsigned int" or "u32"
and calculations use things like "((u32) 1) << shift", and enforce an
upper bounds of 0x80000000 or similar unconditionally in the hash
allocator itself (rather than conditionally in the networking code).

All of this "long" stuff is madness, what the heck is a long?  It's a
non-fixed type, yet you put constants in your code (0x80000000) which
depend upon that type's size.
