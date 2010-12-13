Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab0LMTmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 14:42:09 -0500
Received: from kroah.org ([198.145.64.141]:32863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416Ab0LMTmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 14:42:07 -0500
Date: Mon, 13 Dec 2010 11:41:01 -0800
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/1] hv: Use only one receive buffer and kmalloc on
 initialize
Message-ID: <20101213194101.GA18431@kroah.com>
References: <1292262350-29001-1-git-send-email-hjanssen@microsoft.com>
 <20101213183448.GA11745@kroah.com>
 <8AFC7968D54FB448A30D8F38F259C5622C0BB71F@TK5EX14MBXC116.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8AFC7968D54FB448A30D8F38F259C5622C0BB71F@TK5EX14MBXC116.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 07:31:42PM +0000, Hank Janssen wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:greg@kroah.com]
> > Sent: Monday, December 13, 2010 10:35 AM
> > > ---
> > >  drivers/staging/hv/hv_utils.c |   68 +++++++++++++++++++------------------
> > ---
> > >  1 files changed, 32 insertions(+), 36 deletions(-)
> > >
> > > diff --git a/drivers/staging/hv/hv_utils.c
> > > b/drivers/staging/hv/hv_utils.c index 53e1e29..4ed4ab8 100644
> > > --- a/drivers/staging/hv/hv_utils.c
> > > +++ b/drivers/staging/hv/hv_utils.c
> > > @@ -38,12 +38,15 @@
> > >  #include "vmbus_api.h"
> > >  #include "utils.h"
> > >
> > > +/*
> > > + * Buffer used to receive packets from Hyper-V  */ static u8
> > > +*chan_buf;
> > 
> > One buffer is nicer, yes, but what's controlling access to this buffer?
> > You use it in multiple functions, and what's to say those functions can't be
> > called at the same time on different cpus?  So, shouldn't you either have
> > some locking for access to the buffer, or have a per-function buffer instead?
> > 
> > And if you have a per-function buffer, again, you might need to control
> > access to it as the functions could be called multiple times at the same time,
> > right?
> > 
> 
> The current versions of Hyper-V support interrupt handling on CPU0 only.
> I can make multiple buffers per channel, but because of Hyper-V implementation
> It does not really make a difference.

Then put a big fat note in there saying this, and that it will have to
change if the hyperv channel ever changes.

Hm, how will you handle things if the hyperv core changes and an old
kernel is running this code where things were "assumed" about the
reentrancy happening here?

thanks,

greg k-h
