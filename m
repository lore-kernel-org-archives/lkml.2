Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab0JQPit (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 11:38:49 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38387 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757063Ab0JQPir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 11:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PvAVTit0C5bYtapFkZULtoBjlOqq5wxavmLXn/2Xl9yoVDogtmJ5rTr5SfTKEmhdQu
         XYH84jYjzLHAAPPDsjwrq0ABAh6lshtw7tDnj/xA9i9MuxQoXcY+OQJDI/8csz96wYsc
         uOfGGu0WROgVxfLrTnNInNfB9DMLsIeENsreM=
Date: Sun, 17 Oct 2010 19:38:39 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: kernel-janitors@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] char: synclink: fix information leak to userland
Message-ID: <20101017153839.GA11029@albatros>
References: <1287326493-8134-1-git-send-email-segooon@gmail.com>
 <4CBB177C.9050007@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBB177C.9050007@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 17:34 +0200, Jiri Slaby wrote:
> On 10/17/2010 04:41 PM, Vasiliy Kulikov wrote:
> > Structure new_line is copied to userland with some padding fields unitialized.
> > It leads to leaking of stack memory.
> 
> I think your tool has a bug. I must admit I fail to see the padding
> which would cause leaks. Could you elaborate?

I didn't use any tool except "grep copy_to_user" :)

    typedef struct { 
        unsigned int clock_rate; /* bits per second */
        unsigned int clock_type; /* internal, external, TX-internal etc. */
        unsigned short loopback;
    } sync_serial_settings;          /* V.35, V.24, X.21 */

On x86_64 sizeof(sync_serial_settings) = 4 + 4 + 2 + 2 = 12.
The last 2 is padding.

> 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  Compile tested.
> > 
> >  drivers/char/synclink.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
> > index 3a6824f..abd0867 100644
> > --- a/drivers/char/synclink.c
> > +++ b/drivers/char/synclink.c
> > @@ -7846,6 +7846,8 @@ static int hdlcdev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
> >  	if (cmd != SIOCWANDEV)
> >  		return hdlc_ioctl(dev, ifr, cmd);
> >  
> > +	memset(&new_line, 0, size);
> > +
> >  	switch(ifr->ifr_settings.type) {
> >  	case IF_GET_IFACE: /* return current sync_serial_settings */
> >  
> 
> 
> -- 
> js
> suse labs

-- 
Vasiliy
