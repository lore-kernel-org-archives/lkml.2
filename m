Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab2AQRla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:41:30 -0500
Received: from relay3.sgi.com ([192.48.152.1]:57530 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750870Ab2AQRl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:41:29 -0500
Date: Tue, 17 Jan 2012 11:41:26 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk,
        eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, paulmck@linux.vnet.ibm.com,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        jkosina@suse.cz, avi@redhat.com, linux-fsdevel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] Fix panic in __d_lookup with high dentry hashtable
 counts
Message-ID: <20120117174126.GA18982@sgi.com>
References: <20120113155237.GA25103@sgi.com>
 <20120113162236.GK23916@ZenIV.linux.org.uk>
 <20120117171352.GA18738@sgi.com>
 <20120117.122229.323838457367599504.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117.122229.323838457367599504.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 12:22:29PM -0500, David Miller wrote:
> From: Dimitri Sivanich <sivanich@sgi.com>
> Date: Tue, 17 Jan 2012 11:13:52 -0600
> 
> > When the number of dentry cache hash table entries gets too high
> > (2147483648 entries), as happens by default on a 16TB system, use
> > of a signed integer in the dcache_init() initialization loop prevents
> > the dentry_hashtable from getting initialized, causing a panic in
> > __d_lookup().
> > 
> > In addition, the _hash_mask returned from alloc_large_system_hash() does
> > not support more than a 32 bit hash table size.
> > 
> > Changing the _hash_mask size returned from alloc_large_system_hash() to
> > support larger hash table sizes in the future, and changing loop counter
> > sizes appropriately.
> > 
> > Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> To be honest I think this is overkill.

I'm not going to flat-out disagree with you.  These would be huge hash
tables.  The thought was to make this __init code as flexible as possible.

> 
> Supporting anything larger than a 32-bit hash mask is not even close
> to being reasonable.  Nobody needs a 4GB hash table, not for anything.

Yes, at this point that is likely true.

> 
> Instead I would just make sure everything is "unsigned int" or "u32"
> and calculations use things like "((u32) 1) << shift", and enforce an
> upper bounds of 0x80000000 or similar unconditionally in the hash
> allocator itself (rather than conditionally in the networking code).

OK.  I had mentioned capping the value in alloc_large_system_hash() to
32 bits, but got no response to that proposal.  I'll create a proper
patch.

> 
> All of this "long" stuff is madness, what the heck is a long?  It's a
> non-fixed type, yet you put constants in your code (0x80000000) which
> depend upon that type's size.
