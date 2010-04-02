Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab0DBAnP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 20:43:15 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:58751 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374Ab0DBAnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 20:43:13 -0400
Date: Thu, 1 Apr 2010 17:43:11 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
       netdev@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH 2/3] can: add support for Janz VMOD-ICAN3 Intelligent
 CAN module
Message-ID: <20100402004311.GB25412@ovro.caltech.edu>
References: <1269881932-3803-3-git-send-email-iws@ovro.caltech.edu>
 <20100401130359.9a9b5c7b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401130359.9a9b5c7b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 01 Apr 2010 17:43:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 01:03:59PM -0700, Andrew Morton wrote:
> On Mon, 29 Mar 2010 09:58:51 -0700
> "Ira W. Snyder" <iws@ovro.caltech.edu> wrote:
> 
> > The Janz VMOD-ICAN3 is a MODULbus daughterboard which fits onto any
> > MODULbus carrier board. It is an intelligent CAN controller with a
> > microcontroller and associated firmware.
> > 
> 
> A neat-looking driver.
> 
> > ...
> >
> > +	spin_lock_irqsave(&mod->lock, flags);
> >
> > ...
> 
> It does this rather a lot.  it seems to be doing quite a lot of work
> under that lock, too - quite a lot of memcpy_toio(), other stuff.
> 

Like most similar cards, the host computer communicates to the
microcontroller through a dual ported memory (DPM) interface. In this
card, it is split into 256x 256 byte pages/windows.

The lock ensures that once code sets a window, it doesn't change while
the memcpy/iowrite happens.

> Is there potential here to disable interrupt for too long?  Not
> possible to use spin_lock_bh() here?
> 

The largest possible memcpy_(to|from)io() in the driver is 256 bytes.
Not too huge, but I understand the concern.

Looking at this again, I don't take the lock in the interrupt handler
(nor do I need to). What contexts do the network driver's xmit() and
napi() routines run in? hardirq and softirq respectively, right? In that
case, I think spin_lock_bh() is probably enough.

Ira
