Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2FGAfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:35:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40570 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2FGAft convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120606235403.GC30000@ZenIV.linux.org.uk>
References: <20120603223617.GB7707@redhat.com> <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk> <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com> <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Jun 2012 17:35:28 -0700
X-Google-Sender-Auth: 7sDNfKqTtD7OEkv8d1-o_MoxNfw
Message-ID: <CA+55aFyzwGuV3kwTpYbYBhf4Wg=1xDgN8hXcdTpAdbmA1Zc6Vw@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:54 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Jun 06, 2012 at 04:31:51PM -0700, Linus Torvalds wrote:
>
>> Al, looking at i_mutex use and rename, the only odd thing I see is how
>> vfs_rename_dir() does the "d_move()" *after* it has dropped the target
>> i_mutex. That looks odd. But I guess it shouldn't matter, because if
>> we're doing cross-directory renames we will always serialize everybody
>> with that rename mutex anyway. Yes/no? But wouldn't it make more sense
>> to do it inside the i_mutex? And before we do the dput() on the
>> new_dentry?
>
> What we need is ->i_mutex on parents.

Yes. but the placement is odd as-is, wouldn't you say? *Why* is it
that way? Especially considering that it isn't that way in the other
non-directory case.

> And I'm much more concerned about
> this: 7732a557b1342c6e6966efb5f07effcf99f56167 and
>  3f50fff4dace23d3cfeb195d5cd4ee813cee68b7.

Hmm. If two directory dentries point to the same inode, we're f*cked
for other reasons: we'd consider them separate entries, and then try
to mutex_lock() them both. Causing the obvious deadlock. But I would
have assumed those two commits would make us *less* likely to have
that case, rather than more.

That said, you're right, that d_move() is scary as hell. No parent
semaphores there.. So we're screwed whether we try to alias them or
not.

So yeah, I agree with the suggestion of trying to revert those two and
seeing if that changes anything.

> Al, in the middle of really messy bisect right now ;-/
> [...] On the "akpm patchbomb" side it was just a linear
> sequence, so doing cherry-pick of all of that stuff to the other side of
> merge has yielded a tree identical to the merge one and that allowed normal
> git bisect, which has located the point where it breaks.

Yeah, we've done that before.

>  Can't do that
> trick on the other side - there we have shitloads of merges (including the
> one from tip, and I *really* hope it doesn't end up being the source of
> trouble - topology in that one is horrible).  So I'm doing a kinda-sorta
> manual bisect - pick a point with gitk, reset the test branch to it,
> merge the ipc/mqueue commit into it, test, pick the next point, etc.
> Any suggestions re improving that process?

Just do a *real* bisect - not a manual one - but every time you test a
kernel you test it with the merge (or rebase) on top. And then you
just mark the *base* of that merge good/bad, and let bisect sort it
out.

That's effectively how people bisect bugs that are hidden by other
bugs: you have to apply the (known) bugfix on top of the tree you are
bisecting in order to find the unknown one.

           Linus
