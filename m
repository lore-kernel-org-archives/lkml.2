Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab1FPGvy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 02:51:54 -0400
Received: from barracuda.fsl.cs.sunysb.edu ([130.245.126.20]:51066 "EHLO
	barracuda.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761Ab1FPGvv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 02:51:51 -0400
X-ASG-Debug-ID: 1308207103-01c65a06b0247ba0001-xx1T2L
X-Barracuda-Envelope-From: ezk@fsl.cs.sunysb.edu
X-Barracuda-RBL-Trusted-Forwarder: 130.245.126.16
Subject: Re: [PATCH 0/7] overlay filesystem: request for inclusion
X-Barracuda-BWL-IP: 10.0.0.19
X-Barracuda-BBL-IP: 10.0.0.19
X-Barracuda-RBL-IP: 10.0.0.19
Mime-Version: 1.0 (Apple Message framework v1084)
X-ASG-Orig-Subj: Re: [PATCH 0/7] overlay filesystem: request for inclusion
Content-Type: text/plain; charset=windows-1252
From: Erez Zadok <ezk@fsl.cs.sunysb.edu>
In-Reply-To: <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu>
Date: Wed, 15 Jun 2011 23:51:39 -0700
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "viro@ZenIV.linux.org.uk Viro" <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        apw@canonical.com, nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com, mszeredi@suse.cz,
        "J. R. Okajima" <hooanon05@yahoo.co.jp>
Content-Transfer-Encoding: 8BIT
Message-Id: <954F11FF-339B-48E2-8358-A158DE1E53BC@fsl.cs.sunysb.edu>
References: <1306932380-10280-1-git-send-email-miklos@szeredi.hu> <4540f7aa16724111bd792a1d577261c2@HUBCAS1.cs.stonybrook.edu>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
X-Barracuda-Connect: avatar.fsl.cs.sunysb.edu[130.245.126.16]
X-Barracuda-Start-Time: 1308207103
X-Barracuda-URL: http://130.245.126.20:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66219
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 8, 2011, at 3:32 PM, Andrew Morton wrote:

> On Wed,  1 Jun 2011 14:46:13 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
>> I'd like to ask for overlayfs to be merged into 3.1.
> 
> Dumb questions:
> 
> I've never really understood the need for fs overlaying.  Who wants it?
> What are the use-cases?

A fair question, Andrew.  I've read the entire thread and will try to address multiple issues in this one reply.

(A) USEFULNESS OF UNIONING:

Unioning is a very useful feature, used by many many people world wide.  Largest users are live-cds.  Then there are people who like to use unioning for its snapshotting/recovery abilities (e.g., revert a bad package installation).  Also some diskless NFS people like to use unioning (one shared readonly image, CoW on clients).  And more (the unionfs web page lists 40 projects that used/using unionfs at one point or another). When we started unionfs back in 2003, we were very quickly surprised at all the many ways in which people found creative ways to use it.  Bottom line is, this kind of file-based CoW is very useful.

If anyone is still not convinced that unioning is useful, consider all the many different implementations of it that had been attempted over the years: in-kernel file-system based, VFS-based, fuse-based, and various variants.  And consider how much debate this topic has generated too. :-)

One often mentioned metric asked of people who want to merge their code into linux is "do you have users and how long have they used it?"  By this metric, unioning should have been in mainline 7+ years ago.  It's way overdue.

> This sort of thing could be implemented in userspace and wired up via
> fuse, I assume.  Has that been attempted and why is it inadequate?

(B) APPROACHES TO UNIONING

Userspace file systems are very useful for many, esp. for prototyping, but not for unioning, for all the reasons people outlined already.  So the question is, which in-kernel approach is The Right One[™].  I'm afraid that's the million-dollar question no one in this community had been able to answer yet.

My group, Juniro and his team, and I have spent a huge amount of time over the years developing a standalone stackable file system based approach.  These approaches were rejected largely due to their complexity and large size (often over 10KLoC) which make it hard to review (we all know that code reviewers on linux forums are in very short supply).  That complexity and size were necessary due to the various features users have asked for over the years.  Aside for large/complex code base, some people plain didn't like unioning as a stackable file system; those people often suggested the VFS as the best location for this functionality.  There is some merit to a VFS based approach: unioning performs a fair amount of namespace manipulation (merging directories, eliminating duplications, whiteouts and opaques, etc.), and the VFS is often best suited for complex namespace operations.

Val, Jan, Bharata, and others have spent untold amounts of time trying to develop a VFS-based approach.  In lieu of stackable file system approaches, I was hoping to see those VFS-based approaches get the support needed to get merged, and yet they have not.  It appears that development of the VFS-based approaches has stalled, sadly.  To be fair, I have argued before that adding a lot of code to the VFS "just" to support unioning was a bad idea (see http://lkml.org/lkml/2007/12/13/242).  And I also felt that it was going to be hard to support approaches which required changes (however small) to many individual file systems (e.g., to add native whiteout support). But was I'd have been happy to see a VFS-based approach get merged, if the Powers That Be[™] sanctioned it.

Then there were suggestions to support unioning inside certain file systems like cramfs/tmpfs (see http://lkml.org/lkml/2008/6/2/6). I argued that these approaches were not good either because they required changes to existing stable file systems, and that it wouldn't have provided enough useful unioning features for users to switch to.

And now we have overlayfs, a small stackable file system which requires only small VFS changes and very small changes to other file systems (e.g., tmpfs xattr support, which was merged recently).  At this point in time, overlayfs seems to be the running favorite for merging.  How ironic it is that we've come full circle to the standalone in-kernel stackable file system approach.

(C) ABOUT OVERLAYFS

I've reviewed overlayfs's code.  I found it easy enough to follow that I was able to fix a few bugs and add a feature or two.  It's small enough to be easily reviewed.  I therefore argue that we should NOT try and add a ton of features to overlayfs now, but rather review it as is, consider merging it soon, and gradually add features over time (BTW, I just counted, and ecryptfs, another stackable f/s, grew by over 55% in LoC since first merged).

I also tested overlayfs and it's remarkably stable (and fast) given the features it offers and the relatively short amount of time it's been out compared to other solutions.  I ran LTP-full on overlayfs for several days and couldn't get it to crash (to be fair, some tests didn't pass — which I plan to report).  Either way, kudos to Miklos for such stable and functional code.

Overlayfs is already being used by others who find it useful.  I think the features it already has are good enough for a large user base of unioning solutions.

Andrew, you've asked another good question:

> Another issue: there have been numerous attempts at Linux overlay
> filesystems from numerous parties.  Does (or will) this implementation
> satisfy all their requirements?
> 
> Because if not, we're in a situation where the in-kernel code is
> unfixably inadequate so we end up merging another similar-looking
> thing, or the presence of this driver makes it harder for them to get
> other drivers merged and the other parties' requirements remain
> unsatisfied.

Because this debate has taken so long (8 years now), there is a large user base of unioning already, and several solutions.  By and large, most of these solutions offer the same basic set of features — only that implementations and approaches differ.  Many users couldn't care less how it was implemented as long as it gave them the basic features they needed.  For that reason, I believe that if this community (and the VFS Gods :-) finally decide WHICH APPROACH they liked best and finally just merge something, this'll have two very positive effects.  First, users who need the basic features will start migrating to the new in-kernel unioning solution.  It won't be an overnight migration, but that's fine. Second, and more important, I think the collective resources of this community can finally focus their attention on ONE solution and help make it better, add features, etc.  Frankly, unioning is the kind of problem for which I don't see a need for more than one in-kernel solution, because the basic features users need are all the same.  Sure, some people would continue to use the out-of-mainline solutions because of extra features they offer that the in-kernel solution doesn't, but over time, as newer features are carefully added to the in-kernel solution, more people will migrate to it.

Some might argue that it's good to have many competing solutions. Generally I agree. But in this case I think we have too many competing unioning solutions now, and the community is too splintered in its efforts; instead we should get behind one sanctioned solution and help make it best.  Recently some people "dared" to suggest we consider removing ext2/3 from the code b/c they're old and less used, in order to make the the linux code base smaller and more easily maintainable.  If that's the case, then why have more than one unioning solution in Linux?

Cheers,
Erez.

