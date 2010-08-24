Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab0HXC3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 22:29:23 -0400
Received: from mtoichi12.ns.itscom.net ([219.110.2.182]:45070 "EHLO
	mtoichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0HXC3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 22:29:20 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [PATCH 14/39] union-mount: Union mounts documentation
To: Valerie Aurora <vaurora@redhat.com>
Cc: Neil Brown <neilb@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20100824000505.GA20909@shell>
References: <1281282776-5447-1-git-send-email-vaurora@redhat.com> <1281282776-5447-15-git-send-email-vaurora@redhat.com> <20100810085641.2b9a714c@notabene> <20100817204430.GE5556@shell> <6820.1282094632@jrobl> <20100818185542.GA10850@shell> <16318.1282181699@jrobl> <20100824000505.GA20909@shell>
Date: Tue, 24 Aug 2010 11:28:37 +0900
Message-ID: <6881.1282616917@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thank you for explanation, very much.

Valerie Aurora:
> First, my theory when writing any file system code is that whenever Al
> Viro says, "You can deadlock easily" or "It violates the locking
> rules" that I have to understand the problem and fix it.  I understand
> why union mounts doesn't have the problems unionfs had when Al wrote
> this email (because lower layers are not writable).  But since aufs
> allows directories on lower layers to be renamed in the way that
> creates the problems Al describes, I assume it has this same problem
> until the author understands the unionfs problem and can describe why
> aufs didn't inherit it (or fixed it, or whatever).

Basically agreed.


> Second, why isn't the most strict level of lookup the only option?  It
> seems like anything else is a bug.

Because users can hide the layers (such like UnionMount) if they want,
and it totally prohibits bypassing aufs. Additionally they modify on the
layer directly (bypassing aufs) only when it is really necessary. So the
default value of the option is not a strict one. And users can change
the option dynamically.


> Start with parent_dir1/child_dir1 covering parent_dir2/child_dir2
>  thread 1 does a union lookup and gets:
>   parent_dir1 covering parent_dir2
>   child_dir1 covering child_dir2
>   parent_dir1 parent of child_dir1
>   parent_dir2 parent of child_dir2
>  thread 2 swaps parent_dir2 with child_dir2 (using rename and a tmp dir)
>   now lower fs looks like: child_dir2/parent_dir2
>
> Who inherits what?  Does thread 1 see parent_dir2 as a descendant of
> child_dir2 which is a descendant of parent_dir2 through the union with
> parent_dir1?  Can you sanely define the behavior here?

When a rename happens on a layer directly, aufs receives a
inotify/fsnotify event. Following the event type, aufs makes the cached
dentry/inode obsoleted and they will be lookup-ed again in the
succeeding access. Finally aufs will know the upper parent_dir1 is not
covering the lower parent_dir2 anymore.
This notification is the main purpose of the strict option which is
called "udba=notify" (User's Direct Branch Access).


> Fourth, you have a potential deadlock now.  Say thread 1 is operating
	:::

No, deadlock will not happen since aufs knows the new parent-child
relationship. By using inotify/hinotify in above answer, I hope you
would agree with that.


> > Then I'd say it is an expected behaviour. Simply the upper file hides
> > the lower.
>
> I am not arguing with you and I agree that this is the expected
> behavior.  I wrote about this case just to show that there is a case
> in which what the user "wants" in an upgrade situation is impossible
> to do automatically in the file system.  So you need to have a smart
> tool to do an upgrade of the lower layer file system.  And I argue
> that smart tool should deal with all cases of a file copied up to the
> topmost file system that covers an updated file on the lower file
> system, instead of putting this policy decision into the VFS.

I am afraid that still I may not understand what you wrote well.
Do you mean that upgrading a package involves updating seveal files and
their version have to be matched with each other within the package, and
upgrading different package in both of upper and lower layer directly
causes mismatch among those files?

Although I don't think you are talking about an aufs utility aubrsync
which runs rsync between layers, I don't understand about "putting this
policy decision into the VFS". The simple rule "the upper file hides the
lower" is out of VFS.


J. R. Okajima
