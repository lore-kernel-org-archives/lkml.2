Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab2CJWOP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 17:14:15 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:52885 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab2CJWOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 17:14:14 -0500
Date: Sat, 10 Mar 2012 22:14:12 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs fixes
Message-ID: <20120310221412.GE23916@ZenIV.linux.org.uk>
References: <20120310213050.GD23916@ZenIV.linux.org.uk>
 <CA+55aFwDsoJHGv03tcPgLb7DeFvdcDhmX0rfft8htMTd3aMPXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwDsoJHGv03tcPgLb7DeFvdcDhmX0rfft8htMTd3aMPXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 01:49:21PM -0800, Linus Torvalds wrote:
> On Sat, Mar 10, 2012 at 1:30 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Jan Kara (2):
> > ? ? ?vfs: Fix missed wakeup in I_NEW handling
> 
> Christ. This one is too ugly to live.
> 
> I'm not pulling crap like this. It's f*^&ing stupid to take a lock,
> calculate a bitqueue, and just generally be an absolute ass-hat about
> things for waiting for a bit that is already set 99.999% of the time.
> 
> May I suggest just reverting that commit 250df6ed instead. It added
> all these insane things for no good reason. The comment said they are
> going away, but if they are just multiplying in ways like this, I
> really think the damn thing needs to be reverted. Any change that
> causes code like this is by definition not a good change.

You mean the part that removed smp_mb() on cleaning I_NEW?  OK by me -
definitely saner than what this variant is doing.  AFAICS, evict()
does _not_ need it - only unlock_new_inode(); in case of evict() the
change of ->i_state is separated from that wake_up_bit() by spin_unlock
followed by spin_lock and that ought to provide the barrier...

Done and pushed to the same branch;

Shortlog:
Al Viro (1):
      restore smp_mb() in unlock_new_inode()

Jan Kara (1):
      udf: Fix deadlock in udf_release_file()

Miklos Szeredi (2):
      vfs: fix double put after complete_walk()
      vfs: fix return value from do_last()

Tyler Hicks (1):
      vfs: Correctly set the dir i_mutex lockdep class

Diffstat:
 fs/inode.c    |    4 ++--
 fs/namei.c    |    4 ++--
 fs/udf/file.c |    2 --
 3 files changed, 4 insertions(+), 6 deletions(-)
