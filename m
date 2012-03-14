Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031097Ab2CNWVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:21:40 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:52724 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761299Ab2CNWVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:21:38 -0400
Date: Wed, 14 Mar 2012 15:21:08 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120314222108.GJ19584@count0.beaverton.ibm.com>
References: <20120309235901.GE19584@count0.beaverton.ibm.com>
 <20120310074854.GA3065@moon>
 <20120313024511.GF19584@count0.beaverton.ibm.com>
 <20120313062625.GA1912@moon>
 <20120313071812.GA6969@moon>
 <20120313154337.GA25711@redhat.com>
 <20120313160044.GF1912@moon>
 <20120313160420.GA18307@moon>
 <20120314014106.GI19584@count0.beaverton.ibm.com>
 <20120314054728.GA2778@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314054728.GA2778@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031422-7282-0000-0000-0000075DD544
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 09:47:28AM +0400, Cyrill Gorcunov wrote:
> On Tue, Mar 13, 2012 at 06:41:06PM -0700, Matt Helsley wrote:
> ...
> > > +
> > > +	exe_file = fget(fd);
> > > +	if (!exe_file)
> > > +		return -EBADF;
> > > +
> > > +	dentry = exe_file->f_path.dentry;
> > > +
> > > +	/*
> > > +	 * Because the original mm->exe_file
> > > +	 * points to executable file, make sure
> > > +	 * this one is executable as well to not
> > > +	 * break an overall picture.
> > > +	 */
> > > +	err = -EACCES;
> > > +	if (!S_ISREG(dentry->d_inode->i_mode)	||
> > > +	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> > > +		goto exit;
> > 
> > You could factor out this portion of the access checking from open_exec()
> > after the do_filp_open() in open_exec() and re-use it here. I know it's
> > tiny helper but tying these two together might be good for
> > maintenance later.
> > 
> 
> Matt, I really dont wanna touch code outside of prctl and this function
> in particualar, at least in this patch, ie I can clean up and factor out
> is on top of the patch, as a separate task.

OK, sounds fine.

> 
> > Should it check for some of the flags open_exec() uses? open_exec()
> > passes:
> > 
> > 	O_LARGEFILE|O_RDONLY|__FMODE_EXEC
> > 
> > to do_filp_open(). I think a O_RDONLY check might be good. I don't
> > think __FMODE_EXEC is something userspace can set so could be ignored.
> > O_LARGEFILE might be important though.
> 
> Well, we're not going to read from this file, so it is not that important
> at moment, so previously I've had
> 
> > +     if ((exe_file->f_flags & O_ACCMODE) != O_RDONLY)
> > +             goto exit;
> 
> and Oleg pointed me
> 
>  | But the O_RDONLY check looks strange. We are not going to write
>  | to this file, we only set the name (and that is why I think it
>  | should be mm->exe_path). What is the point to check that the file
>  | was opened without FMODE_WRITE? Even if there were any security
>  | risk the apllication can open this file again with the different
>  | flags.
> 
> so I dropped it. And I think the same applies to O_LARGEFILE. Sure
> it's not a problem to bring it back but should we?

OK, sorry I must have missed that portion of the discussion. It all looks
good to me.

Cheers,
	-Matt

