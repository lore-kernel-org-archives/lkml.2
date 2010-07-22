Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab0GVMgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:36:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37864 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755530Ab0GVMgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:36:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100722041554.GB3446@amd>
References: <20100722041554.GB3446@amd> <27282.1279058150@redhat.com>
To: Nick Piggin <npiggin@suse.de>
Cc: dhowells@redhat.com, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] Add a dentry op to handle automounting rather than abusing follow_link
Date: Thu, 22 Jul 2010 13:36:27 +0100
Message-ID: <30811.1279802187@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> wrote:

> > AFS is made to use this facility so that it can be tested.  Other
> > filesystems abusing the follow_mount() inode operation will also need to
> > be modified.

I meant follow_link() here of course...  Too many followy things:-)

> How about having a .follow_mount op, and using that instead of
> default follow_mount in case mounted is incremented?

But what if d_mounted is not incremented, though?  That's usually the point
you'd want to call the automount code.  Why would you want to call into the
filesystem just to skip over possibly mounted dentries?  A dentry may have an
elevated d_mount on it, but nothing mounted at that {vfsmount,dentry} point I
suppose, but still jumping into the filesystem just so it can skip an already
mounted point would seem a waste of time.

> Also I would prefer the patch to add this call

Meaning i_op->follow_mount()?

> keep basically the same API as follow_mount, so if you are going to change
> that to return an error and do the NOFOLLOW handling in there, then could
> you do that first, as a more trivial patch?

Ummm...  I'm not sure I follow you.  I changed __follow_mount() not
follow_mount().  I don't think changing the latter is necessary.

> Then your addition of the d_op should not touch outside *follow_mount.

But calling i_op->follow_mount() would, so what does this gain you?  And why
not touch the inside of __follow_mount()?

Are you suggesting doing i_op->follow_mount() instead of or as well as
d_op->d_automount()?  I'm not entirely sure.

David
