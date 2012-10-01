Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab2JASMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:12:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:44152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab2JASMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:12:36 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1210011343170.1386-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1210011332150.1386-100000@iolanthe.rowland.org>
	<Pine.LNX.4.44L0.1210011343170.1386-100000@iolanthe.rowland.org>
Date: Mon, 1 Oct 2012 21:12:34 +0300
Message-ID: <CAE1zotL=WggH2OFoxF7KZX+Ciu71LLZwiaOeVBZfPVM_jC1PDw@mail.gmail.com>
Subject: Re: [PATCH] usb hub: send clear_tt_buffer_complete events when
 canceling TT clear work
From: Octavian Purdila <octavian.purdila@intel.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Mon, Oct 1, 2012 at 8:48 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Mon, 1 Oct 2012, Alan Stern wrote:
>
> > On Mon, 1 Oct 2012, Octavian Purdila wrote:
> >
> > > There is a race condition in the USB hub code with regard to handling
> > > TT clear requests that can get the HCD driver in a deadlock. Usually
> > > when an TT clear request is scheduled it will be executed immediately:
> >
> > > However, if a suspend operation is triggered before hub_tt_work is
> > > scheduled, hub_quiesce will cancel the work without notifying the HCD
> > > driver:
> >
> > Ah, this is a very good point.
> >
> > > When the device will resume the EHCI driver will get stuck in
> > > ehci_endpoint_disable waiting for the tt_clearing flag to reset:
> >
> > > This patch notifies the HCD driver via clear_tt_buffer_complete
> > > when canceling TT clear work so that the EHCI driver has a chance to
> > > clear its tt_clearing flag.
> >
> > But I don't like the proposed fix.  What we really need to do is avoid
> > suspending the device until the clear-tt-buffer operation is complete.
> > Can you write a patch to do that instead?
>
> Actually, it would be sufficient to avoid suspending the _hub_ until
> the clear-tt-buffer operation is complete.  In short, hub_quiesce()
> should wait until all pending TT operations have finished.  The
> cancel_work_sync() call should be replaced with flush_work_sync().
>

Good point, i will resend the patch. I will only be able to test the
fix tomorrow though, I don't have access to the setup that reproduces
the issue.

Thanks!
Tavi
