Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab0C3KeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 06:34:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60744 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926Ab0C3KeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 06:34:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Date: Tue, 30 Mar 2010 11:33:40 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <b6fcc0a1003292338yafeb3d3k37fb3fa79af5340c@mail.gmail.com> <20100330070733.GC22419@nowhere>
In-Reply-To: <20100330070733.GC22419@nowhere>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003301233.40461.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18QK05ToCUGmY0fYsJsYfIXXweXA0JpVWouq52
 wOXPF00iS+fhIlBNioXNBhfq/f+v+Xb+NuZBHrlpw4yIcZsKwg
 qsCEaNf6R7qsdT71T5/LQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 March 2010, Frederic Weisbecker wrote:
> On Tue, Mar 30, 2010 at 09:38:11AM +0300, Alexey Dobriyan wrote:
> > On Tue, Mar 30, 2010 at 9:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > --- a/fs/proc/inode.c
> > > +++ b/fs/proc/inode.c
> > > @@ -231,9 +231,9 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
> > >                if (rv == -ENOIOCTLCMD)
> > >                        rv = -EINVAL;
> > >        } else if (ioctl) {
> > > -               lock_kernel();
> > > +               WARN_ONCE(1, "Procfs ioctl handlers must use unlocked_ioctl, "
> > > +                         "%pf will be called without the Bkl held\n", ioctl);
> > >                rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
> > > -               unlock_kernel();
> > 
> > Then delete the branch.
> > Or go through formal feature-removal procedure.
> 
> 
> I thought about it. I even started to write something in this
> feature-removal file but realized that I can't remove the
> .ioctl() callback from file operations. We still need to check
> the user hasn't made the mistake of implementing it.
> 
> What I can plan as a feature removal, though, is to keep the warning
> but don't actually call the ioctl.

I believe we can actually remove ioctl from file_operations. The patch I did
to convert all users to ".unlocked_ioctl = default_ioctl," should really catch
all cases, and I think we can enforce this by renaming fops->ioctl to locked_ioctl
or old_ioctl to make sure we didn't miss any, and then mandate that this one
is only used when unlocked_ioctl is set to default_ioctl.

I also remember going through procfs ioctl operations some time ago and finding
exactly three users, which I believe are the same ones that Frederic found.

	Arnd
