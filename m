Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab2AMQWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 11:22:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:46497 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2AMQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 11:22:49 -0500
Date: Fri, 13 Jan 2012 16:22:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Avi Kivity <avi@redhat.com>,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Fix panic in __d_lookup with high dentry hashtable counts
Message-ID: <20120113162236.GK23916@ZenIV.linux.org.uk>
References: <20120113155237.GA25103@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120113155237.GA25103@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 09:52:37AM -0600, Dimitri Sivanich wrote:
> When the number of dentry cache hash table entries gets too high
> (2147483648 entries), use of a signed integer in the initialization
> loop prevents the dentry_hashtable from getting initialized, resulting
> in a panic in __d_lookup.  Fixing this in dcache_init and a few other
> spots for consistency.

>  static void __init dcache_init(void)
>  {
> -	int loop;
> +	long loop;

You've got to be kidding.  Note that D_HASHMASK is at most 32bit.  Use
of long here is an overkill and so's 2^31 hash buckets (that's what,
16Gb in hash list heads alone?  What kind of average chain length do
you expect, BTW?)

Can alloc_large_system_hash() produce the horrors that large, anyway?
