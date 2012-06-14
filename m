Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2FNRU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:20:56 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33229 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab2FNRUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:20:55 -0400
Date: Thu, 14 Jun 2012 10:20:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Alan Cox <alan@linux.intel.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-kernel@vger.kernel.org, rabin@rab.in
Subject: Re: [PATCH] vt: fix race in vt_waitactive()
Message-ID: <20120614172045.GA18839@kroah.com>
References: <20120518180628.GA27021@kroah.com>
 <1337587722-19809-1-git-send-email-rabin.vincent@stericsson.com>
 <20120613234452.GA12764@kroah.com>
 <20120614104802.4983dc67@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614104802.4983dc67@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 10:48:02AM +0100, Alan Cox wrote:
> On Wed, 13 Jun 2012 16:44:52 -0700
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Mon, May 21, 2012 at 01:38:42PM +0530, Rabin Vincent wrote:
> > > pm_restore_console() is called from the suspend/resume path, and this
> > > calls vt_move_to_console(), which calls vt_waitactive().
> > > 
> > > There's a race in this path which causes the process which requests the
> > > suspend to sleep indefinitely waiting for an event which already
> > > happened:
> > > 
> > > P1                                      P2
> > >  vt_move_to_console()
> > >   set_console()
> > >     schedule_console_callback()
> > >   vt_waitactive()
> > >     check n == fg_console +1
> > >                                        console_callback()
> > >                                          switch_screen()
> > >                                          vt_event_post() // no waiters
> > > 
> > >     vt_event_wait() // forever
> > > 
> > > Fix the race by ensuring we're registered for the event before we check
> > > if it's already completed.
> > > 
> > > Cc: Alan Cox <alan@linux.intel.com>
> > > Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> > > ---
> > >  drivers/tty/vt/vt_ioctl.c |   47 ++++++++++++++++++++++++++++++++------------
> > >  1 files changed, 34 insertions(+), 13 deletions(-)
> > 
> > Alan, any thoughts on this patch?
> 
> I acked it when first posted - I believe its correct.

Ah, sorry, I missed that somehow.  I'll go queue it up now.

greg k-h
