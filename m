Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201Ab2JIX3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 19:29:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34773 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab2JIX3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 19:29:11 -0400
Date: Wed, 10 Oct 2012 00:29:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mark Moseley <moseleymark@gmail.com>
Cc: john@feurix.com, linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: linux-audit: reconstruct path names from syscall events?
Message-ID: <20121009232907.GW2616@ZenIV.linux.org.uk>
References: <20110917001215.GA961@zombie.hq.fstein.net>
 <CAOH1cHkn_Yndw55y8QU-ipygRMfDyCG+An-qqBERtu4P-tt3MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOH1cHkn_Yndw55y8QU-ipygRMfDyCG+An-qqBERtu4P-tt3MA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 04:09:18PM -0700, Mark Moseley wrote:
> On Fri, Sep 16, 2011 at 5:12 PM, John Feuerstein <john@feurix.com> wrote:
> > Hi,
> >
> > I would like to audit all changes to a directory tree using the linux
> > auditing system[1].
> >
> > # auditctl -a exit,always -F dir=/etc/ -F perm=wa
> >
> > It seems like the GNU coreutils are enough to break the audit trail.
> >
> > The resulting SYSCALL events provide CWD and multiple PATH records,
> > depending on the syscall. If one of the PATH records is relative, I can
> > reconstruct the absolute path using the CWD record.
> >
> > However, that does not work for the whole *at syscall family
> > (unlinkat(2), renameat(2), linkat(2), ...); accepting paths relative to
> > a given directory file descriptor. GNU coreutils are prominent users,
> > for example "rm -r" making use of unlinkat(2) to prevent races.
> >
> > Things like dup(2) and fd passing via unix domain sockets come to mind.
> > It's the same old story again: mapping fds to path names is ambiguous at
> > best, if not impossible.

Your point being?  Even if you do get all pathnames, you *can't* reconstruct
the changes of filesystem tree, period.  Pathname resolution is not atomic.
Can't be made such, either - not without serializing all system calls, which
will hurt too damn much.

You can tell when something happens to filesystem *object*.  Which audit,
lousy as it is, allows to do.  Anything that hopes to reconstruct the
history of changes based on fully timestamped history of syscalls is
inherently unreliable.

Again, pathname resolution is not atomic at all and neither is reconstructing
pathname by object (i.e. by vfsmount/dentry pair).
