Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0LMDAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 22:00:20 -0500
Received: from mail001.aei.ca ([206.123.6.130]:56343 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844Ab0LMDAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 22:00:18 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 22:00:18 EST
From: Ed Tomlinson <edt@aei.ca>
To: Nick Piggin <npiggin@kernel.dk>
Subject: Re: rcu-walk and dcache scaling tree update and status
Date: Sun, 12 Dec 2010 21:53:32 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-crc+; KDE/4.5.4; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101213023733.GB6522@amd>
In-Reply-To: <20101213023733.GB6522@amd>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012122153.33427.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 December 2010 21:37:33 Nick Piggin wrote:
> The vfs-scale branch has had some progress, but it is now requiring
> wider testing and detailed review, particularly of the fine details of
> dcache_lock lifting, and rcu-walk synchronisation details and
> documentation.
> 
> Linus has suggested pretty strongly that he wants to pull this in the
> next merge window (recently, that "inodes will be RCU freed in 2.6.38"
> in an urelated discussion). As far as I know, that's what he's going to
> do. I'd like to get this some time in linux-next to improve test
> coverage (many filesystems I can't even test, so there are bound to be a
> few silly crashes). Stephen, how do I arrange that?
> 
> From my point of view, it has had nowhere near enough review,
> particularly I want Al to be happy with it, filesystem changes looked at
> and tested by respective fs maintainers, and anybody who is good at
> concurrency. However, if Linus still wants to merge it to kick things
> along, I am not going to stop him this time, because I have no known
> bugs or pending changes required.
> 
> I, like everybody else, would prefer bugs or design flaws to be found
> *before* it goes upstream, of course. I would be happy to spend time on
> irc with reviewers (ask me offline). And if anybody has reasonable
> concerns or suggestions, I will be happy to take that into account. I
> will not flame anybody who reads my replies, even if it takes a while
> for one or both of us to understand.
> 
> Documentation/filesystems/path-lookup.txt is a good place to start
> reviewing the fun stuff. I would much appreciate review of documentation
> and comments too, if anything is not clear, omitted, or not matching the
> code.
> 
> Also, please keep an eye on the end result when reviewing patches.
> Particularly the locking patches before dcache_lock is lifted, these are
> supposed to provide a lock coverage to lift dcache_lock with minimal
> complexity. They are not supposed to be nice looking code that you'd
> want to run on your production box, they are supposed to be nice
> changesets (from a review and verification point of view).
> 
> Git tree is here:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git
> 
> Branch is:
> 
>     vfs-scale-working
> 
> Changes since last posting:
> * Add a lot more comments for rcu-walk code and functions
> * Fix reported d_compare vfat crash
> * Incorporate review suggestions
> * Make rcu-walk bail out if we have to call a security subsystem
> * Fix for filesystems rewriting dentry name in-place
> * Audit d_seq barrier write-side, add a few places where it was missing
> * Optimised dentry memcmp
> 
> Testing:
> Testing filesystems is difficult, particularly remote filesystems, and
> ones without mkfs packaged in debian. I'm running ltp and xfstests among
> others, but those cover a tiny portion of what you can do with the
> dcache. The more testing the merrier.
> 
> I have been unable to break anything for a long time, but the race
> windows can be tiny. I've been trying to insert random delays into
> different parts of critical sections, and write tests specifically
> targetting particular races, but that's slow going -- review of locking,
> or testing on different configurations should be much more productive.
> 
> Final note:
> You won't be able to reproduce the parallel path walk scalability
> numbers that I've posted, because the vfsmount refcounting scalability
> patch is not included. I have a new idea for that now, so I'll be asking
> for comments with that soon.

I get this when building:

security/security.c: In function 'security_inode_exec_permission':
security/security.c:520: error: 'rcu' undeclared (first use in this function)
security/security.c:520: error: (Each undeclared identifier is reported only once
security/security.c:520: error: for each function it appears in.)
make[1]: *** [security/security.o] Error 1
make: *** [security] Error 2

Missing include maybe?

Ed


