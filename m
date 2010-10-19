Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab0JSQzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:55:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45327 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab0JSQzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:55:53 -0400
Date: Tue, 19 Oct 2010 17:55:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Paris <eparis@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, david@fromorbit.com, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        mingo@elte.hu
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101019165530.GT19804@ZenIV.linux.org.uk>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
 <1287506215.2530.187.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287506215.2530.187.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 12:36:55PM -0400, Eric Paris wrote:
> I ask Al about reusing this field long ago and he indicated it had a
> very different meaning.  I can't remember what he indicated it meant off
> the top of my head but I'll take a look at it again.

> i_count, I believe, is much different.  i_count is counting the number
> of dentries in core referencing the inode, even if none of them are
> being used in any struct file or if one dentry is being referenced in
> 1000 struct files.  The IMA counters are from a higher level, they
> counts the number of struct files referencing this inode.


a) i_writecount is about VM_DENYWRITE, basically.  Reusing it for ima could
get unpleasant; when it's positive, we are fine, but it can get negative as
well.  IMA will have interesting time dealing with that.

b) i_count is simply a refcount for struct inode.  Not exactly the number
of dentries, but that's the main contributor.  Basically, that's "how many
pointers outside of inode hash chains point that that struct inode at the
moment".
