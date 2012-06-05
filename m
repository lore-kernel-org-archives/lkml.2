Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761770Ab2FEKmW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:42:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761724Ab2FEKmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:42:18 -0400
Date: Tue, 5 Jun 2012 12:41:25 +0200
From: Karel Zak <kzak@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jslaby@suse.cz,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, alan@linux.intel.com
Subject: Re: um: TTY fixes (?)
Message-ID: <20120605104125.GA14536@x2.net.home>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
 <20120604221731.5e378fc2@pyramind.ukuu.org.uk>
 <4FCD4161.7060409@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCD4161.7060409@nod.at>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 01:14:41AM +0200, Richard Weinberger wrote:
> Am 04.06.2012 23:17, schrieb Alan Cox:
> >> 	On all other ttys login works but bash dies because of of -EIO.
> >> 	After vhangup() the tty returns -EIO upon read()/write().
> > 
> > You can't re-open the tty because a process is holding on to it, not
> > closing it and not killable. Fedora shouldn't be holding these devices
> > open this way. The behaviour we have of refusing to reopen them why this
> > is the case is both a) what the spec seems to say b) good security.
> 
> Hmm, there seems to be a bug in util-linux's login.
> login-utils/login.c::init_tty() does:
> ...
>        /* Kill processes left on this tty */
>         tcsetattr(0, TCSAFLUSH, &ttt);
> 
>         signal(SIGHUP, SIG_IGN);        /* so vhangup() wont kill us */
>         vhangup();
>         signal(SIGHUP, SIG_DFL);
> 
>         /* open stdin,stdout,stderr to the tty */
>         open_tty(cxt->tty_path);
> 
>         /* restore tty modes */
>         tcsetattr(0, TCSAFLUSH, &tt);
> ...
> 
> By calling vhangup() it kills all other programs on the current tty.
> open_tty() opens the tty again but it's still open because stdin, stdout and stderr
> belongs to it.

 open_tty() closes all the old file descriptors after tty open:

    vhangup();
    ...
	fd = open(tty, O_RDWR | O_NONBLOCK);
    ...

	flags = fcntl(fd, F_GETFL);
	flags &= ~O_NONBLOCK;
	fcntl(fd, F_SETFL, flags);

	for (i = 0; i < fd; i++)
		close(i);
	for (i = 0; i < 3; i++)
		if (fd != i)
			dup2(fd, i);
	if (fd >= 3)
		close(fd);

we use this for pretty long time (17+ years).

> If I add:
>         fclose(stdin);
>         fclose(stdout);
>         fclose(stderr);
> before the call to vhangup() login works like charm. :-)
> 
> Karel, what do you think?

 It's probably no problem to close all the file descriptors before
 vhangup(), but it would be nice to know why we need this change after
 20 years :-)

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
