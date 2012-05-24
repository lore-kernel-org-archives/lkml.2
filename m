Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2EXW4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:56:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43612 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2EXW4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:56:15 -0400
Date: Thu, 24 May 2012 15:56:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        andi@firstfloor.org, Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] printk: ignore recursion_bug flag in HW error handle
 process
Message-Id: <20120524155611.b7aeff4d.akpm@linux-foundation.org>
In-Reply-To: <20120524061145.GA18284@liondog.tnic>
References: <4FBC444A.6060500@intel.com>
	<20120523100138.GA13506@x1.osrc.amd.com>
	<4FBDCE4A.7050900@intel.com>
	<20120524061145.GA18284@liondog.tnic>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2012 08:11:45 +0200
Borislav Petkov <bp@alien8.de> wrote:

> > +/* HW error handle status helpers */
> > +extern atomic_t hw_error;
> > +static inline void hw_error_enter(void)
> > +{
> > +	atomic_inc(&hw_error);
> > +}
> > +
> > +static inline void hw_error_exit(void)
> > +{
> > +	atomic_dec(&hw_error);
> > +}
> > +
> > +static inline int in_hw_error(void)
> > +{
> > +	return atomic_read(&hw_error);
> > +}
> 
> Shouldn't those be generic empty functions and each arch implement their
> own with the stuff they want to do on the respective architecture when
> they get a hardware error?

This code needs documentation.

Specifically, it should clearly explain (and hence define) what a
"hardware error" *is*, and for what purpose this code exists.

Because as it stands, this interface is hopelessly vague.  Once one
sees that it is *specifically* used for handling mce within a printk,
it all makes sense.

And with that understanding comes the realisation that the interface is
poorly named.  It will not be used for any purpose other than adjusting
printk() behavior so it should mention printk() in its name and in its
comments and probably it should all be moved into printk.h.

Futhermore, this code is not really related to MCE or hardware or
anything else.  It is simply a way in which callers can suppress
printk()'s recursion check.  Callers are free to use it for reasons
other than "hardware errors".

And once all that is done, and this interface becomes part of printk()
then no, there is no need to add per-arch hooks.  An arch can call into
printk_recursion_check_disable() and printk_recursion_chack_enable() -
nice and simple.


IOW, the title of this patch should be

	[patch 1/2] printk: add interface for disabling recursion check
	[patch 2/2] x86 mce: use new printk recursion disabling interface
