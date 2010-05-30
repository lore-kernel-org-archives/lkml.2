Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0E3SNJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 14:13:09 -0400
Received: from THUNK.ORG ([69.25.196.29]:48224 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679Ab0E3SNH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 14:13:07 -0400
Date: Sun, 30 May 2010 14:13:00 -0400
From: tytso@mit.edu
To: Peter Hallberg <hallberg68@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: What happened to mount option "noextents"
Message-ID: <20100530181300.GP26177@thunk.org>
Mail-Followup-To: tytso@mit.edu, Peter Hallberg <hallberg68@hotmail.com>,
	linux-kernel@vger.kernel.org
References: <COL116-W195C862FD57AC7C2144804DAED0@phx.gbl>
 <20100530123248.GO26177@thunk.org>
 <COL116-W2944FC5A891172B1FECD52DAED0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <COL116-W2944FC5A891172B1FECD52DAED0@phx.gbl>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 03:52:10PM +0200, Peter Hallberg wrote:
> 
> > Basically, since we couldn't think of a good use case where the mount
> > options made sense, and ext4 has way too many mount options already, we
> > decided to remove them.
> 
> The ext2/3 Windows driver doesn't support extents yet so one common
> use would be to do a mount -o remount,noextents and make a dir and
> copy the files you want to read from Windows to it. I think mount -o
> remount is something that is well known, if you use tune2fs you
> would need to do research before you know if the change starts
> working right a way or after a reboot or if it is valid only until
> reboot or is static, with mount -o remount there is no risk that you
> forget to set the flag back to the right value.

Yeah, but.... it's a horrible interface to support.  If one or more
directories happen to be extent-mapped, then Windows won't be able to
read it.  And if there are other files that are created while the
filesystem is remounted noextents, they will be created w/o extents,
which means that fallocate won't work.  The opportunities for
hard-to-understand failures are very large, and especially for
clueless Ubuntu users, it's just not something where I want to see
whining on Launchpad because they read somewhere that they could do
it, and it doesn't quite work right.

This is more something where if someone wants to patch the kernel do
something hacky like this, it's almost better because then it's not
something where we have to worry about confused users wondering why
something broke when they tried to use this interface.  Something that
works 80% of the time can be far worse than something that doesn't
work at all.

The real right answer is to fix the Windows driver to support extents.
Or create a separate filesystem just for moving files from Linux to
Windows --- or just write the files directly onto the Windows
partition.


> Also when I tryed tune2fs as you said, I got the following error message:
> 
> peter@sanna:~$ sudo tune2fs -O ^extents /dev/mapper/sannavg-home
> tune2fs 1.41.4 (27-Jan-2009)
> Clearing filesystem feature 'extent' not supported.
> peter@sanna:~$ 

Yes, right now you can only enable extents; it's not something you
can disable.

					- Ted
