Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1GQEjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 00:39:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328Ab1GQEjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 00:39:51 -0400
MIME-Version: 1.0
In-Reply-To: <20110716211618.GA2717@thunk.org>
References: <4DFB7E1C.3010509@halfdog.net> <20110716211618.GA2717@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 16 Jul 2011 21:39:28 -0700
Message-ID: <CA+55aFyDwAQE5ig6+yqzcVphGcrarVG2eP_aMyPxpzGo25s+VA@mail.gmail.com>
Subject: Re: Possible ext2/3/4 filesysystem iov_length integer overflow and
 strange behavior on large writes
To: "Ted Ts'o" <tytso@mit.edu>, halfdog <me@halfdog.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 2:16 PM, Ted Ts'o <tytso@mit.edu> wrote:
>
> Your questions about what happens if someone is trying to perform a
> Denial of Service attack and send a writev of 1 TB is a interesting
> one.

We *should* be pretty good about this at the VFS layer at least, since
we tend to use things like "lock_page_killable()" and friends. IOW,
the thing may not be "interruptible" in the sense that we don't allow
signals (for all the historical reasons: user programs *should* be
able to handle interrupted file accesses since they do happen with NFS
if you mount things with "-o intr" etc, but nobody has really dared
say that it can happen in general). But we generally allow a signal
that kills a process to interrupt a read or write.

There may be cases where we don't do the "_killable()" version,
though. And filesystems that do their own routines (eg writes on
filesystems with logs etc) rather than use the VFS helper ones would
be more likely to have that issue.

Of course, we already say "screw posix" if somebody tries to write
really big chunks, and the VFS layer will say "I will truncate writes
bigger than 2GB, and better handle partial writes if you do big
chunks". That's partly due to security issues with drivers/filesystems
with overflow issues, and partly just because anything else would be
crazy. We could easily also say that "big writes are always
interruptible", for some random definition of "big" (ie
multi-megabyte). Exactly because of the DoS issues.

                         Linus
