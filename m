Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab2FGByO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 21:54:14 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36754 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab2FGByM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 21:54:12 -0400
Date: Thu, 7 Jun 2012 02:54:10 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120607015410.GG30000@ZenIV.linux.org.uk>
References: <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607013149.GF30000@ZenIV.linux.org.uk>
 <CA+55aFx3QT0AA+s=M+QyJFKqQNh0cHiunwZ=fyrc1eneJTtarQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx3QT0AA+s=M+QyJFKqQNh0cHiunwZ=fyrc1eneJTtarQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 06:45:35PM -0700, Linus Torvalds wrote:
> On Wed, Jun 6, 2012 at 6:31 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > And you want to check i_mutex on old parent, not the file being moved
> > itself. ?IOW, the second one should be
> >
> > if (dentry->d_parent != dentry)
> > ? ? ? ?WARN_ON_ONCE(!mutex_is_locked(&dentry->d_parent->d_inode->i_mutex));
> 
> Do you even need the "dentry->d_parent != dentry" test? When do we
> even rename root dentries?

Root of the filesystem - never; root of disconnected subtree - sure,
that's how they become connected to the tree.  See d_materialize_unique(),
for example...

BTW, I really need more coffee - those checks belong in __d_move(),
not d_move(); aforementioned d_materialize_unique() doesn't use d_move(),
it calls __d_move() directly.  Sorry.
