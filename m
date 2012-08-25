Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2HYVws (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 17:52:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38501 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2HYVwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 17:52:45 -0400
Date: Sat, 25 Aug 2012 22:52:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 1/9] procfs: Move /proc/pid/fd[info] handling code to
 fd.[ch]
Message-ID: <20120825215239.GW23464@ZenIV.linux.org.uk>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.592602491@openvz.org>
 <20120825171605.GT23464@ZenIV.linux.org.uk>
 <20120825173958.GC19184@moon>
 <20120825175504.GU23464@ZenIV.linux.org.uk>
 <20120825185829.GE19184@moon>
 <20120825191218.GV23464@ZenIV.linux.org.uk>
 <20120825194325.GG19184@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825194325.GG19184@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 11:43:25PM +0400, Cyrill Gorcunov wrote:

> Would the patch below improve the code? Look, I've not dropped
> find_inode_number call since it's a bit unclear for me what
> would happen if !child case hit
> 
> 	child = d_lookup(dir, &qname);
> 	if (!child) {
> 		struct dentry *new = d_alloc(dir, &qname);
> 		if (new) {
> 			child = instantiate(dir->d_inode, new, task, ptr);
> 			if (child)
> 				dput(new);
> 			else
> 				child = new;
> 		}
> 	}
> 
> can we be sure that i_ino won't be zero here?

First of all, ->i_ino is not going to be zero for any procfs inode.
As for !child case, that's possible only if d_lookup() returns NULL
*and* d_alloc() fails.  In that case find_inode_number() will call
d_hash_and_lookup(), which will call d_lookup(), get NULL from it and
return NULL to find_inode_number().  Which will return 0 to the
caller.

AFAICS, if find_inode_number() is called there at all, it will return 0.
IOW, this if (!ino) ino = find_inode_number(...); is a no-op.
