Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906Ab2FGAm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 20:42:58 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62467 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2FGAm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 20:42:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120607002914.GB22223@redhat.com>
References: <20120603223617.GB7707@redhat.com> <CA+55aFwCusEdMq3_3TAXSZ=+kbN7H6AbnngVaagAZw=ZpicckQ@mail.gmail.com>
 <20120603231709.GP30000@ZenIV.linux.org.uk> <20120603232820.GQ30000@ZenIV.linux.org.uk>
 <20120606194233.GA1537@redhat.com> <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com> <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk> <20120607002914.GB22223@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Jun 2012 17:42:35 -0700
X-Google-Sender-Auth: T-rqomf7mkJrGTm94kXvLjgRy_Q
Message-ID: <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
To: Dave Jones <davej@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 5:29 PM, Dave Jones <davej@redhat.com> wrote:
>
> Like this ?

No.

>  void d_move(struct dentry *dentry, struct dentry *target)
>  {
>        write_seqlock(&rename_lock);
> +
> +       BUG_ON(!spin_is_locked(&target->d_parent->d_lock));
> +
> +       if (dentry->d_parent != NULL)
> +               BUG_ON(!spin_is_locked(&dentry->d_parent->d_lock));

It's true that the d_lock needs to be held too, but we actually do
that in __d_move() (which calls dentry_lock_for_move), so the callers
don't have to worry about that part.

So Al meant you to test mutex_is_locked(dentry->d_inode->i_mutex) of
the parents.

And I'd suggest making it just a WARN_ON_ONCE(), because if you make
it a BUG_ON() and it triggers, your system will likely be dead. And
ONCE is all that matters - it should never happen.

> To be clear, do you want me to try that with or without the reverts ?

I think either would be interesting. *If* that d_move() from
d_splice_alias ever triggers, that would be an interesting backtrace
to see too.

Of course, if that d_splice_alias change is the cause of this, then
with those two commits reverted you'd not be able to reproduce the
problem, which would also be interesting to know, so either way it
would be good information.

               Linus
