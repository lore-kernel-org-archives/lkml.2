Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010Ab2KHPGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 10:06:21 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:47969 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317Ab2KHPGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 10:06:17 -0500
From: Nix <nix@esperi.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.7-rc4
References: <CA+55aFxGm+2-OiVL1JRYH12BZiMBjiaST+9jrQCtHeU-iVvmyA@mail.gmail.com>
Emacs: The Awakening
Date: Thu, 08 Nov 2012 15:06:14 +0000
In-Reply-To: <CA+55aFxGm+2-OiVL1JRYH12BZiMBjiaST+9jrQCtHeU-iVvmyA@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 4 Nov 2012 11:43:33 -0800")
Message-ID: <87625gqgm1.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-STAT_FI_X86_64_VIRTUAL-Metrics: spindle 1245; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 Nov 2012, Linus Torvalds stated:

> Perhaps notable just because of the noise it caused in certain
> circles, there's the ext4 bitmap journaling fix for the issue that
> caused such a ruckus. It's a tiny patch and despite all the noise
> about it you couldn't actually trigger the problem unless you were
> doing crazy things with special mount options.

It also helps if you reboot during umount. Which is also crazy (says the
man who's still doing it). But the *real* problem is the way
journal_async_commit uses a journal checksum failure as an indication
that the commit was interrupted as long as there is no following commit
block, which as the comment in
fs/jbd2/recovery.c:do_one_pass():JBD2_COMMIT_BLOCK says, is going to
lead to an incorrect conclusion of interrupted commit and a successful
remount whenever commit N is corrupt and commit N+1 is interrupted (e.g.
by some loony rebooting or powerfailing during umount).

This problem seems to be intrinsic to journal_async_commit to me, since
it repurposes journal checksums to do a second job of missing-commit-
block detection, which pretty much means that *actual* checksum
failures, i.e. kernel bugs or corruption at writeout time, go
undetected, just as they do when journal checksumming is off -- but they
*also* mean that errors computing the checksum can go undetected. And
since journal checksumming is rarely used, such bugs can persist for a
relatively long time.

All of this means that journal_async_commit is *more* likely to cause a
no-warnings remount of a corrupted filesystem that really needs fscking
than is a filesystem using a normal non-checksummed journal. And that,
to me, is the really dangerous part. If you know the fs is corrupt, you
can fsck it and all is well, after a bit of flak: you won't overlook it.
If you don't know the fs is corrupt, you run a substantial risk of
making things much much worse before the problem escalates from ext4
errors in a log you never read into -EIO. (I happened to be reading that
log because I was trying to reproduce the nsm lockd bug. But normally?
Yeah, I spend all my time reading the kernel log, doesn't everyone?)


I'd apologise for causing all the fuss, but it wasn't me who decided to
submit it to Phoronix (actually I suspect Michael Larabel just read the
list and everything snowballed from there).

-- 
NULL && (void)
