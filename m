Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0KERim (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 13:38:42 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54138 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab0KERik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:38:40 -0400
Subject: Re: [PATCH 0/4] IMA: making i_readcount a first class inode citizen
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, eparis@redhat.com,
        viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>
In-Reply-To: <20101105162811.GA3270@fieldses.org>
References: <1288303325-9628-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101105011227.GB4320@fieldses.org>
	 <1288955286.3135.9.camel@localhost.localdomain>
	 <20101105162811.GA3270@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 13:38:05 -0400
Message-ID: <1288978685.3135.135.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-05 at 12:28 -0400, J. Bruce Fields wrote: 
> On Fri, Nov 05, 2010 at 07:08:06AM -0400, Mimi Zohar wrote:

> > Right, like the ima_file_check(), which is after the __dentry_open().
> > Al, is it possible to move the break_lease() in may_open() to later?
> 
> That would still leave a race like:
> 
> 			check count
> 	bump count
> 	break lease
> 			set lease
> 
> But we could extend the i_lock to prevent the lease being bumped between
> the two steps on the right-hand side.

The latest i_readcount patchset, i_readcount is atomic and doesn't
require i_lock, at least for IMA.  Have to think about this more ....

> At that point I think we'd be done?  We're assured the count is still
> zero while the lease is added to the inode, so anyone in the process of
> doing an open has yet to reach the break_lease, which will see the newly
> added lease.
> 
> That leaves the problem that leases really should be broken on anything
> that changes the attributes or the dentries pointing to the inode:
> setattr, link, unlink, rename, at least.

For this reason, IMA is now taking i_mutex, preventing file metadata
from changing.

> One approach: add another counter to the inode named disable_leases, and
> have any of those operations do something like:
> 
> 	disable_lease++
> 	break_lease
> 	... do operation ...
> 	disable_lease--
> 
> ?
> 
> --b.

lol, getting i_readcount was was hard enough. 

Mimi

