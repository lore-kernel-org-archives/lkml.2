Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1APVob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 16:44:31 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49381 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab1APVo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 16:44:28 -0500
Date: Sun, 16 Jan 2011 21:44:26 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joachim Eastwood <manabian@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 2 (automount work)
Message-ID: <20110116214426.GD22723@ZenIV.linux.org.uk>
References: <20110116185745.GB22723@ZenIV.linux.org.uk>
 <AANLkTim1SS2Y1EL9iB2jDSUbqofoaWXig-xHa12Ogm95@mail.gmail.com>
 <AANLkTinZ5ng+hbOHz7DKy82HPqFwYhQvmmbM+ioSWp9x@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinZ5ng+hbOHz7DKy82HPqFwYhQvmmbM+ioSWp9x@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 01:37:54PM -0800, Linus Torvalds wrote:
> On Sun, Jan 16, 2011 at 1:15 PM, Joachim  Eastwood <manabian@gmail.com> wrote:
> >
> > f03c65993b98eeb909a4012ce7833c5857d74755 - sanitize vfsmount refcounting changes
> >
> > Breaks my ARM !CONFIG_SMP compile
> 
> In fact, any non-SMP compile, it's not ARM-specific.
> 
> The simple fix for the build breakage should be to just move the
> mnt_longterm thing out of the #ifdef CONFIG_SMP in
> include/linux/mount.h. But I do worry that it would cause some count
> imbalance, because there are some accesses that are still inside that
> CONFIG_SMP case in mntput_no_expire().
> 
> Al, please take a look,

Already fixed.  Actually, taking it out of ifdef would work (the only
place that actually cares about the value of that sucker is SMP side
of mntput()), but we are obviously better off just not touching it on
UP at all - why do pointless work and waste space?

See the patch upthread.  ->mnt_longterm is SMP-only optimization of
mntput(); it's there only to free the common case of mntput() from
cacheline bouncing and on UP it's needed at all.
