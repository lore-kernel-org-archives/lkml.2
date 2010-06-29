Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab0F2UjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:39:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38450 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935Ab0F2UjF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:39:05 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTiksmwITS6aCuXXZGR916OTEBm9VQ1MSzzEt8F7S@mail.gmail.com>
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com>
	<alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org>
	<20100608004102.GQ31073@ZenIV.linux.org.uk>
	<87pqzrexon.fsf@linux.vnet.ibm.com>
	<871vbwe6lp.fsf@linux.vnet.ibm.com>
	<AANLkTiksmwITS6aCuXXZGR916OTEBm9VQ1MSzzEt8F7S@mail.gmail.com>
Date: Tue, 29 Jun 2010 13:38:57 -0700
Message-ID: <AANLkTikyqHtazndL_zBux7Zk0qZSJuNEvitHj8wkuSWW@mail.gmail.com>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 
	2.6.35-rc2
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 1:18 PM, Eric Van Hensbergen <ericvh@gmail.com> wrote:
>
> Does this approach satisfy your concerns?  We've been going over
> several different options on how to proceed, but this seems to be the
> best option.

Using a p9fs rename lock does seem to be a reasonable option.

That said, the patch itself seems to not be valid. You drop the lock
too early in v9fs_fid_lookup() as far as I can tell. You then re-take
it before doing that whole

   for (d = dentry, i = (n-1); i >= 0; i--, d = d->d_parent)

loop with it held again, but that's totally bogus - because you
dropped the lock, your 'n-1' count has absolutely no meaning any more,
since a cross-directory rename might have changed the depth of the
thing in the meantime.

And if the depth changes, you aren't at all guaranteed to stay on the
same p9fs filesystem, so now you're doing that d_parent access without
the proper locking (sure: you hold the rename lock, but it's not at
all guaranteed that the rename lock is the _right_ lock any more as
you traverse the list down!)

But I didn't look deeply at the patch. There might be some reason why
it's safe (I doubt it, though), and there might be other places where
you do the same. But in general, dropping and re-taking a lock is a
bad idea. If you dropped the lock, you can't depend on anything you
found out while having held it.

              Linus
