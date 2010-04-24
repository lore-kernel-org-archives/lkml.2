Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0DXOoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 10:44:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59572 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752998Ab0DXOoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 10:44:44 -0400
Date: Sat, 24 Apr 2010 10:44:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: Arve Hj?nnev?g <arve@android.com>, Len Brown <len.brown@intel.com>,
       <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 2/9] PM: suspend_block: Add driver to access
 suspend blockers from user-space
In-Reply-To: <20100424055523.GC2290@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.1004241037230.6848-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Apr 2010, Pavel Machek wrote:

> On Fri 2010-04-23 20:20:47, Arve Hj?nnev?g wrote:
> > On Fri, Apr 23, 2010 at 9:43 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > > On Fri, 23 Apr 2010, Pavel Machek wrote:
> > >
> > >> Hi!
> > >>
> > >> > Add a misc device, "suspend_blocker", that allows user-space processes
> > >> > to block auto suspend. The device has ioctls to create a suspend_blocker,
> > >> > and to block and unblock suspend. To delete the suspend_blocker, close
> > >> > the device.
> > >> >
> > >> > Signed-off-by: Arve Hj??nnev??g <arve@android.com>
> > >>
> > >> > --- a/Documentation/power/suspend-blockers.txt
> > >> > +++ b/Documentation/power/suspend-blockers.txt
> > >> > @@ -95,3 +95,20 @@ if (list_empty(&state->pending_work))
> > >> >  else
> > >> >     suspend_block(&state->suspend_blocker);
> > >> >
> > >> > +User-space API
> > >> > +==============
> > >> > +
> > >> > +To create a suspend_blocker from user-space, open the suspend_blocker device:
> > >> > +    fd = open("/dev/suspend_blocker", O_RDWR | O_CLOEXEC);
> > >> > +then call:
> > >> > +    ioctl(fd, SUSPEND_BLOCKER_IOCTL_INIT(strlen(name)), name);
> > >>
> > >>
> > >> This seems like very wrong idea -- it uses different ioctl number for
> > >> each length AFAICT.
> > >
> > > How about specifying the name by an ordinary write() call instead of
> > > by an ioctl()?
> > >
> > 
> > I prefer using ioctls. We have three operations at the moment. Init,
> > block and unblock. If we do init with write but block and unblock
> > using ioctls, it would be pretty strange. Specifying a command and
> 
> Why would it be "strange"?

Why indeed?  Using write() is the natural way to pass a data buffer
into the kernel, especially a variable-length buffer.

Mixing ioctl() and write() might seem strange at first, but it has
plenty of precedent.  Consider adjusting the settings for a serial
port, for example.

> > argument in a string to write is more complicated to parse than using
> > ioctls.
> 
> More complicated to parse?

It shouldn't be -- especially if you assume that the init action must
always come first.  The first write would contain the suspend blocker's
name; all following writes would have to be either "on" or "off".  
That's not hard to parse.

Alan Stern

