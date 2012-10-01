Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab2JARsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 13:48:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36027 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751407Ab2JARsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 13:48:06 -0400
Date: Mon, 1 Oct 2012 13:48:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Octavian Purdila <octavian.purdila@intel.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb hub: send clear_tt_buffer_complete events when
 canceling TT clear work
In-Reply-To: <Pine.LNX.4.44L0.1210011332150.1386-100000@iolanthe.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1210011343170.1386-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012, Alan Stern wrote:

> On Mon, 1 Oct 2012, Octavian Purdila wrote:
> 
> > There is a race condition in the USB hub code with regard to handling
> > TT clear requests that can get the HCD driver in a deadlock. Usually
> > when an TT clear request is scheduled it will be executed immediately:
> 
> > However, if a suspend operation is triggered before hub_tt_work is
> > scheduled, hub_quiesce will cancel the work without notifying the HCD
> > driver:
> 
> Ah, this is a very good point.
> 
> > When the device will resume the EHCI driver will get stuck in
> > ehci_endpoint_disable waiting for the tt_clearing flag to reset:
> 
> > This patch notifies the HCD driver via clear_tt_buffer_complete
> > when canceling TT clear work so that the EHCI driver has a chance to
> > clear its tt_clearing flag.
> 
> But I don't like the proposed fix.  What we really need to do is avoid
> suspending the device until the clear-tt-buffer operation is complete.  
> Can you write a patch to do that instead?

Actually, it would be sufficient to avoid suspending the _hub_ until 
the clear-tt-buffer operation is complete.  In short, hub_quiesce() 
should wait until all pending TT operations have finished.  The 
cancel_work_sync() call should be replaced with flush_work_sync().

Alan Stern

