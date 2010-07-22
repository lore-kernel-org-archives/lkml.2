Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0GVO5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:57:47 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:38811 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752086Ab0GVO5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:57:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFf5R0x5Lc6U/2dsb2JhbACfcXLBaoU2BA
Date: Fri, 23 Jul 2010 00:57:38 +1000
From: Nick Piggin <npiggin@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Add a dentry op to handle automounting rather
 than abusing follow_link
Message-ID: <20100722145738.GA5752@amd>
References: <20100722041554.GB3446@amd>
 <27282.1279058150@redhat.com>
 <30811.1279802187@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30811.1279802187@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:36:27PM +0100, David Howells wrote:
> Nick Piggin <npiggin@suse.de> wrote:
> 
> > > AFS is made to use this facility so that it can be tested.  Other
> > > filesystems abusing the follow_mount() inode operation will also need to
> > > be modified.
> 
> I meant follow_link() here of course...  Too many followy things:-)
> 
> > How about having a .follow_mount op, and using that instead of
> > default follow_mount in case mounted is incremented?
> 
> But what if d_mounted is not incremented, though?

Nothing?


>  That's usually the point
> you'd want to call the automount code.

I think you have it the wrong way around. If you wanted to call
the automount code, you would have incremented d_mounted.


>  Why would you want to call into the
> filesystem just to skip over possibly mounted dentries?  A dentry may have an
> elevated d_mount on it, but nothing mounted at that {vfsmount,dentry} point I
> suppose, but still jumping into the filesystem just so it can skip an already
> mounted point would seem a waste of time.

Those that don't care wouldn't set ->follow_mount though.
Following a mount is a fairly heavy operation already, it
does take a global lock (before vfs scalability patches,
anyway).

I like the flexibility of doing one's own ->follow_mount,
although Al might object to allowing filesystems to follow
mounts in ways that are not published to the core
namespace structures.

 
> > Also I would prefer the patch to add this call
> 
> Meaning i_op->follow_mount()?

Either one, just make the follow_mount/__follow_mount API
changes in one patch, and add the callback in another.

 
> > keep basically the same API as follow_mount, so if you are going to change
> > that to return an error and do the NOFOLLOW handling in there, then could
> > you do that first, as a more trivial patch?
> 
> Ummm...  I'm not sure I follow you.  I changed __follow_mount() not
> follow_mount().  I don't think changing the latter is necessary.

I meant __follow_mount.

 
> > Then your addition of the d_op should not touch outside *follow_mount.
> 
> But calling i_op->follow_mount() would, so what does this gain you?  And why
> not touch the inside of __follow_mount()?
> 
> Are you suggesting doing i_op->follow_mount() instead of or as well as
> d_op->d_automount()?  I'm not entirely sure.

Two suggestions. Firstly a d_op->d_follow_mount() (does following
a mount even make sense at the inode level?)

Secondly, just simply to split the patch so you change the
__follow_mount API in namespace first.

