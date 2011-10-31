Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab1JaPJT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:09:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49966 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab1JaPJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:09:17 -0400
MIME-Version: 1.0
In-Reply-To: <4EAE5DE3.2020205@t-online.de>
References: <4EAE5DE3.2020205@t-online.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 08:08:55 -0700
X-Google-Sender-Auth: yjvE_5J67IiF2XEruUl3tlyatdc
Message-ID: <CA+55aFzuWD1xRhQNLfe0ey_-1vACwY=ofD5PXSzL_5UeDRbk8g@mail.gmail.com>
Subject: Re: [BUG] kernel 3.1.0 possible circular locking dependency detected
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added a few more people to the cc ]

On Mon, Oct 31, 2011 at 1:35 AM, Knut Petersen
<Knut_Petersen@t-online.de> wrote:
> After a " rm -r /verybigdir" (about 12G on a 25G reiserfs 3.6partition)
> I found the following report about a circular locking dependency in
> kernel 3.1.0

Heh. There is even a comment about the ordering violation:

/* We use I_MUTEX_CHILD here to silence lockdep. It's safe because xattr
 * mutation ops aren't called during rename or splace, which are the
 * only other users of I_MUTEX_CHILD. It violates the ordering, but that's
 * better than allocating another subclass just for this code. */

and apparently the comment is wrong: we *do* end up looking up xattrs
during splice, due to the security_inode_need_killpriv() thing.

So I think this needs a suid (or sgid) file that has xattrs and is removed.

That said, I suspect this is a false positive, because the actual
unlink can never happen while somebody is splicing to/from the same
file at the same time (because then the iput wouldn't be the last one
for the inode, and the file removal would be delayed until the file
has been closed for the last time).

But the hacky use of "I_MUTEX_CHILD" is basically not the proper way
to silence the lockdep splat.

Anybody?

                  Linus
