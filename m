Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab0FHAIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:08:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44175 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751146Ab0FHAI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:08:29 -0400
Date: Mon, 7 Jun 2010 17:08:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
cc: V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
In-Reply-To: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jun 2010, Eric Van Hensbergen wrote:
> 
> jvrao (2):
>       Add a helper function to get fsgid for a file create.
>       9p: Add a wstat after TCREATE to fix the gid.

Quite frankly, this looks rather broken.

It uses "dentry->d_parent" without locking (it so happens to likely be ok, 
since we are in "create()" and thus should be holding the parent 
semaphore). On its own, that might be excusable (if people were even 
_aware_ of the this locking rule!), but it does so just to get the inode 
pointer to that parent.

And the only thing that makes it ok to access dentry->d_parent - the fact 
that we are in v9fs_create() - is also the thing that should have made 
people look at the arguments to the function and say "hmm".

We pass in the directory inode pointer as an argument to the create 
function! The code could have used that thing directly, instead of 
mucking around with dentry pointers that it had no business looking at.

I see why it seems to have happened: v9fs does the exact same thing for 
the pre-existing "v9fs_fid_lookup()". So there is history to this 
behavior.

Maybe people weren't aware of the fact that just dereferencing 
dentry->d_parent willy-nilly isn't actually allowed. That field changes. 
Sure, there are cases where it's ok, but this is a dangerous thing to do 
in general. 

In fact, the other thing that I find doing that whole "dentry->d_parent" 
thing seems to literally be broken. If you look at v9fs_fid_lookup(), 
you'll notice how it walks up the d_parent chain, and at that point you do 
NOT own the directory i_mutex, so at that point d_parent really _can_ be 
changing wildly due to concurrent renames or whatever.

So 9pfs seems to have some preexisting bugs in this area. I'm not going to 
pull new bug-prone code. See the other discussions about being tight this 
release about really _only_ taking regressions after the merge window 
closed.

		Linus
