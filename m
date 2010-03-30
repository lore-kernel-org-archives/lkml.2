Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0C3HHd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 03:07:33 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36956 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab0C3HHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 03:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=K5ZoBEtMKUo8zUgOX9Nuv88BL5BfAwRYTLwz1z6JBANY4e8SZtAW5Btax3QYAt317O
         99HdcmjEKwCM+KZ4ZzR48EFmlOq9BU7popJpCC+YjxjWMNBf5ZqZj9KeRGoWy/YydQqe
         KyxcgYkW2m2lPEKUO3lekHjVfppYl0Xlc/SBk=
Date: Tue, 30 Mar 2010 09:07:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 6/6] procfs: Kill the bkl in ioctl
Message-ID: <20100330070733.GC22419@nowhere>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com> <1269930015-863-7-git-send-regression-fweisbec@gmail.com> <b6fcc0a1003292338yafeb3d3k37fb3fa79af5340c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6fcc0a1003292338yafeb3d3k37fb3fa79af5340c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 09:38:11AM +0300, Alexey Dobriyan wrote:
> On Tue, Mar 30, 2010 at 9:20 AM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > --- a/fs/proc/inode.c
> > +++ b/fs/proc/inode.c
> > @@ -231,9 +231,9 @@ static long proc_reg_unlocked_ioctl(struct file *file, unsigned int cmd, unsigne
> >                if (rv == -ENOIOCTLCMD)
> >                        rv = -EINVAL;
> >        } else if (ioctl) {
> > -               lock_kernel();
> > +               WARN_ONCE(1, "Procfs ioctl handlers must use unlocked_ioctl, "
> > +                         "%pf will be called without the Bkl held\n", ioctl);
> >                rv = ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
> > -               unlock_kernel();
> 
> Then delete the branch.
> Or go through formal feature-removal procedure.


I thought about it. I even started to write something in this
feature-removal file but realized that I can't remove the
.ioctl() callback from file operations. We still need to check
the user hasn't made the mistake of implementing it.

What I can plan as a feature removal, though, is to keep the warning
but don't actually call the ioctl.

