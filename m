Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2FNJob (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:44:31 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57412 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab2FNJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:44:30 -0400
Date: Thu, 14 Jun 2012 10:48:02 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-kernel@vger.kernel.org, rabin@rab.in
Subject: Re: [PATCH] vt: fix race in vt_waitactive()
Message-ID: <20120614104802.4983dc67@pyramind.ukuu.org.uk>
In-Reply-To: <20120613234452.GA12764@kroah.com>
References: <20120518180628.GA27021@kroah.com>
	<1337587722-19809-1-git-send-email-rabin.vincent@stericsson.com>
	<20120613234452.GA12764@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 16:44:52 -0700
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, May 21, 2012 at 01:38:42PM +0530, Rabin Vincent wrote:
> > pm_restore_console() is called from the suspend/resume path, and this
> > calls vt_move_to_console(), which calls vt_waitactive().
> > 
> > There's a race in this path which causes the process which requests the
> > suspend to sleep indefinitely waiting for an event which already
> > happened:
> > 
> > P1                                      P2
> >  vt_move_to_console()
> >   set_console()
> >     schedule_console_callback()
> >   vt_waitactive()
> >     check n == fg_console +1
> >                                        console_callback()
> >                                          switch_screen()
> >                                          vt_event_post() // no waiters
> > 
> >     vt_event_wait() // forever
> > 
> > Fix the race by ensuring we're registered for the event before we check
> > if it's already completed.
> > 
> > Cc: Alan Cox <alan@linux.intel.com>
> > Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
> > ---
> >  drivers/tty/vt/vt_ioctl.c |   47 ++++++++++++++++++++++++++++++++------------
> >  1 files changed, 34 insertions(+), 13 deletions(-)
> 
> Alan, any thoughts on this patch?

I acked it when first posted - I believe its correct.
