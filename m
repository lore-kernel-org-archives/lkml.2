Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab0FHAt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 20:49:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751503Ab0FHAtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 20:49:25 -0400
Date: Mon, 7 Jun 2010 17:48:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
In-Reply-To: <20100608004102.GQ31073@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1006071746150.4506@i5.linux-foundation.org>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com> <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org> <20100608004102.GQ31073@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jun 2010, Al Viro wrote:

> On Mon, Jun 07, 2010 at 05:08:19PM -0700, Linus Torvalds wrote:
> 
> > In fact, the other thing that I find doing that whole "dentry->d_parent" 
> > thing seems to literally be broken. If you look at v9fs_fid_lookup(), 
> > you'll notice how it walks up the d_parent chain, and at that point you do 
> > NOT own the directory i_mutex, so at that point d_parent really _can_ be 
> > changing wildly due to concurrent renames or whatever.
> 
> Eh...  It's bogus, all right, but i_mutex is not the correct solution.

Oh, no, I didn't imply it was. But the other sites that I saw doing 
the dentry->d_parent access already _had_ the i_mutex thing, so I was 
pointing out how this one does not (and indeed _cannot_ do that).

So I'm just saying that pretty much _all_ the dentry->d_parent use in 9p 
seems very suspect. The cases where we hold i_mutex (because the caller 
already took it) shouldn't do that whole d_parent dance, because they get 
the directory inode passed into them directly.

And the other places are just buggy.

So from a quick look, the use of d_parent in 9p is simply not a good idea. 

			Linus
