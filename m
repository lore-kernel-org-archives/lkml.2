Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1KGRTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:19:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32951 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab1KGRTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:19:32 -0500
Subject: Re: [BUG] kernel 3.1.0 possible circular locking dependency detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Knut Petersen <Knut_Petersen@t-online.de>, linux-kernel@vger.kernel.org,
        reiserfs-devel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>
Date: Mon, 07 Nov 2011 18:18:27 +0100
In-Reply-To: <CA+55aFzuWD1xRhQNLfe0ey_-1vACwY=ofD5PXSzL_5UeDRbk8g@mail.gmail.com>
References: <4EAE5DE3.2020205@t-online.de>
	 <CA+55aFzuWD1xRhQNLfe0ey_-1vACwY=ofD5PXSzL_5UeDRbk8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320686307.17809.33.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 08:08 -0700, Linus Torvalds wrote:
> [ Added a few more people to the cc ]
> 
> On Mon, Oct 31, 2011 at 1:35 AM, Knut Petersen
> <Knut_Petersen@t-online.de> wrote:
> > After a " rm -r /verybigdir" (about 12G on a 25G reiserfs 3.6partition)
> > I found the following report about a circular locking dependency in
> > kernel 3.1.0
> 
> Heh. There is even a comment about the ordering violation:
> 
> /* We use I_MUTEX_CHILD here to silence lockdep. It's safe because xattr
>  * mutation ops aren't called during rename or splace, which are the
>  * only other users of I_MUTEX_CHILD. It violates the ordering, but that's
>  * better than allocating another subclass just for this code. */
> 
> and apparently the comment is wrong: we *do* end up looking up xattrs
> during splice, due to the security_inode_need_killpriv() thing.
> 
> So I think this needs a suid (or sgid) file that has xattrs and is removed.
> 
> That said, I suspect this is a false positive, because the actual
> unlink can never happen while somebody is splicing to/from the same
> file at the same time (because then the iput wouldn't be the last one
> for the inode, and the file removal would be delayed until the file
> has been closed for the last time).
> 
> But the hacky use of "I_MUTEX_CHILD" is basically not the proper way
> to silence the lockdep splat.
> 
> Anybody?

I_MUTEX_XATTR sounds like the right nesting for something called
xattr_*() but then, what do I know about filesystems.. Jeff Mahoney
wrote this, Jeff any clue?
