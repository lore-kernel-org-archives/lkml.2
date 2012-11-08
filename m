Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2KHXNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 18:13:02 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:60134 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831Ab2KHXNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 18:13:00 -0500
Date: Thu, 8 Nov 2012 18:12:55 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Nix <nix@esperi.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.7-rc4
Message-ID: <20121108231255.GO19977@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>, Nix <nix@esperi.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CA+55aFxGm+2-OiVL1JRYH12BZiMBjiaST+9jrQCtHeU-iVvmyA@mail.gmail.com>
 <87625gqgm1.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87625gqgm1.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2012 at 03:06:14PM +0000, Nix wrote:
> On 4 Nov 2012, Linus Torvalds stated:
> 
> > Perhaps notable just because of the noise it caused in certain
> > circles, there's the ext4 bitmap journaling fix for the issue that
> > caused such a ruckus. It's a tiny patch and despite all the noise
> > about it you couldn't actually trigger the problem unless you were
> > doing crazy things with special mount options.
> 
> It also helps if you reboot during umount. Which is also crazy (says the
> man who's still doing it). 

BTW, it *also* required allocating inodes in the same block group in
two consecutive transactions; where the second inode allocation takes
place before the journal blocks for the first transaction have
finished being written to disk (which is what causes the incorrect
checksum; because we weren't requesting write access to a metadata
block before we started modifying it, this opened a window here the
commit thread could end up calculate the checksum for the committing
transaction that was out of sync with what was actually written to the
journal).

I haven't had the time to write up the full explanation, but that's
the other missing piece of what happened.

> This problem seems to be intrinsic to journal_async_commit to me, since
> it repurposes journal checksums to do a second job of missing-commit-
> block detection, which pretty much means that *actual* checksum
> failures, i.e. kernel bugs or corruption at writeout time, go
> undetected, just as they do when journal checksumming is off -- but they
> *also* mean that errors computing the checksum can go undetected. And
> since journal checksumming is rarely used, such bugs can persist for a
> relatively long time.

Journal checksumming isn't used at all, because it wasn't ready;
precisely because I knew that we didn't handle checksum failures for
anything other than the last checksum in the journal.  It got enabled
by journal_async_commit, but this wasn't something that was enabled by
default, nor was journal checksumming at all.

It's my fault; I should have put these features under an
CONFIG_EXT4_EXPERIMENTAL, which was appropriately labelled with a
scary "THESE OPTIONS ARE NOT READY YET FOR COMMON USE; YOU MAY LOSE
YOUR DATA" warning sign.

> I'd apologise for causing all the fuss, but it wasn't me who decided to
> submit it to Phoronix (actually I suspect Michael Larabel just read the
> list and everything snowballed from there).

Or Michael read it on the LWN comment thread....  the lesson here is
that if there's bad information on the web, or on some mailing list
and it's sensationalistic, you can depend on certain web sites to pick
it up, because they make money only when they can drive lots of
advertising web hits.

   	   	      	      	      - Ted
