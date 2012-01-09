Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab2AIWVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:21:46 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:57184 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab2AIWVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:21:45 -0500
Date: Mon, 9 Jan 2012 22:22:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: Multiple consoles
Message-ID: <20120109222234.6d34a7ad@pyramind.ukuu.org.uk>
In-Reply-To: <4F0B5808.2010900@cfl.rr.com>
References: <4F0B5808.2010900@cfl.rr.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It occurred to me that there ought to be an entirely separate set of 
> virtual consoles bound to the second seat, and the second X server ought 
> to run on one of those vcs.  Or of course, you could choose to log into 
> the console and not bother with X.

X can do it without consoles.

> Looking at drivers/tty/vt/vt.c, it appears that it was written assuming 
> that there is just one linux console.  It appears to use global 
> variables for keeping track of which vc is active, etc, rather than 
> creating one or more console devices, and store the vc multiplexing 
> information in those devices.  So to fix this, vt.c and keyboard.c would 
> need significantly refactored to remove the global variables and create 
> a console device to bind vcs, keyboards, and displays to, and then you 
> could create a second one if you wanted.

Yes - in theory (you'd also have to sort out some of the passing of
variables around so that the code knew which 'console group' it belonged
to.

> Does this make sense or am I missing something?

It makes sense but it's one of a set of three problems with the tty/vt
layer IMHO

- A vt/tty is linked to a framebuffer of some sort, so you can't just
  create abstract ones plumbed into arbitary objects. Really the vt
  emulator ought to be separate from the consoles. 

- You can only have one set of vts

- The locking needs a rework, particularly the handling of crashes where
  sometimes we deadlock on the oops reporting.

and the framebuffer layer has some problems with locking and mode setting,
with hotplug, and with a complete inability to handle scatter-gather
backed consoles.

Alan
