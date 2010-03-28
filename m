Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab0C1UHk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 16:07:40 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146Ab0C1UHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 16:07:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Sun, 28 Mar 2010 21:05:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
References: <201003242240.54907.arnd@arndb.de> <201003271537.40488.arnd@arndb.de> <4BAF4B49.9070308@s5r6.in-berlin.de>
In-Reply-To: <4BAF4B49.9070308@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003282205.50886.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18sgZDGNzbQo6Hgq2l64uLdNpxol++3t9u6emd
 TDFS0Wt1qcEhe+ylNHcyvN1Dji8O6+K72UNwYMF0H2sNS3FrzM
 WLaGTJuTrfkIBWk1bqgiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 March 2010, Stefan Richter wrote:
> Arnd Bergmann wrote:
> > Your patches look good, but it would be helpful to also set .llseek = no_llseek
> > in the file operations, because that is much easier to grep for than
> > only the nonseekable_open. While it's technically a NOP on the presence of
> > nonseekable_open, it will help that I don't accidentally apply my patch on
> > top of yours.
> 
> Sounds like a plan, but (a) if my .llseek = no_llseek and your .llseek =
> default_llseek are not within diff context range, you (or whoever else
> merges mine and yours) only get a compiler warning (Initializer entry
> defined twice) rather than a merge conflict which couldn't be missed,
> (b) there won't be a merge conflict in "BKL removal: mark remaining
> users as 'depends on BKL'".  (c) While I don't mind adding more visual
> clutter to ieee1394/*, I prefer terse coding in firewire/*.
> 
> How about I put my nonseekable_open additions into a release branch and
> send you a pull request after a few days exposure in linux-next?  If you
> do not plan to respin your patch queue soon or at all, I could even let
> you pull a for-arnd branch with a semantically correct merge of yours
> and mine.

I can probably remember this specific one now, but for other people
doing the same on their subsystems, adding no_llseek may help reduce
the need for coordination.

> General thoughts:
> 
> ".llseek = NULL," so far meant "do the Right Thing on lseek() and
> friends, as far as the fs core can tell".  Shouldn't we keep it that
> way?  It's as close to other ".method = NULL," as it can get, which
> either mean "silently skip this method if it doesn't matter" (e.g.
> .flush) or "fail attempts to use this method with a fitting errno" (e.g.
> .write).

My series changes the default from 'default_llseek' to 'generic_file_llseek',
which is almost identical, except for taking the inode mutex instead of the
BKL. Another option that has been discussed before is to make no_llseek
the default, but that might cause more serious problems wiht drivers that
really require seeking.

Since using default_llseek can only ever make a difference if the driver
actually uses the BKL in any other function, I could go through the
patches again and revert those that do no use the BKL anywhere else.

> Of course, as we have already seen with infiniband, firewire, ieee1394,
> .llseek = NULL is ambiguous in practice.  Does the driver really want to
> use default_llseek, or should it rather use no_llseek and/or
> nonseekable_open, or should it even implement a dummy_llseek() { return
> 0; } which avoids the BKL but preserves ABI behaviour?  This needs to be
> resolved for each and every case eventually, regardless of whether or
> when your addition of .llseek = default_llseek enters mainline.

Yes, that also sounds like a good idea. I believe that Jan actually posted
a patch to do that at some point.

	Arnd
