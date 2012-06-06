Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758916Ab2FFXyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 19:54:09 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50202 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2FFXyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 19:54:07 -0400
Date: Thu, 7 Jun 2012 00:54:04 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120606235403.GC30000@ZenIV.linux.org.uk>
References: <20120603223617.GB7707@redhat.com>
 <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk>
 <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 04:31:51PM -0700, Linus Torvalds wrote:

> Al, looking at i_mutex use and rename, the only odd thing I see is how
> vfs_rename_dir() does the "d_move()" *after* it has dropped the target
> i_mutex. That looks odd. But I guess it shouldn't matter, because if
> we're doing cross-directory renames we will always serialize everybody
> with that rename mutex anyway. Yes/no? But wouldn't it make more sense
> to do it inside the i_mutex? And before we do the dput() on the
> new_dentry?

What we need is ->i_mutex on parents.  And I'm much more concerned about
this: 7732a557b1342c6e6966efb5f07effcf99f56167 and
 3f50fff4dace23d3cfeb195d5cd4ee813cee68b7.

Dave, you seem to be able to reproduce it; could you try with those two
commits reverted?  This stuff is *definitely* wrong with the way it
treats d_move(); there we might get it with parents not locked at all.

FWIW, I'd suggest adding a check into d_move(); new parent must be
locked in all cases and old one whenever dentry has one (i.e. isn't
disconnected).  If you can find a violation of that, you very likely
have found the cause of that bug.

Al, in the middle of really messy bisect right now ;-/  It started with
mips panicing (under qemu-system-mips -M malta) in -rc1; bisect has lead
to merge of akpm's patchbomb - as in "both parents work, merge doesn't,
recreating the merge give the identical tree and no textual conflicts".
I've located the (half of the) problem in akpm branch - that's commit
d6629859b36d953a4b1369b749f178736911bf10 (ipc/mqueue: improve performance
of send/recv).  Merge with it => unhandled unaligned access in the kernel,
merge with parent => no problems.  The other half of the logical conflict
is harder to find ;-/  On the "akpm patchbomb" side it was just a linear
sequence, so doing cherry-pick of all of that stuff to the other side of
merge has yielded a tree identical to the merge one and that allowed normal
git bisect, which has located the point where it breaks.  Can't do that
trick on the other side - there we have shitloads of merges (including the
one from tip, and I *really* hope it doesn't end up being the source of
trouble - topology in that one is horrible).  So I'm doing a kinda-sorta
manual bisect - pick a point with gitk, reset the test branch to it,
merge the ipc/mqueue commit into it, test, pick the next point, etc.
Any suggestions re improving that process?  Short of setting a clone
and doing git bisect _there_, while the original tree is used for
merge/build stuff, hopefully...  Is there any way to ask where would the
next bisection point be with given set of goods and bads?
