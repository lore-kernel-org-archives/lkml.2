Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab2LJWuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:50:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21386 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2LJWuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:50:04 -0500
Date: Tue, 11 Dec 2012 01:49:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        greg@kroah.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] rtl8712: replace min with min_t
Message-ID: <20121210224943.GT22569@mwanda>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
 <1355048110-10859-4-git-send-email-przemo@firszt.eu>
 <20121210094108.GQ6568@mwanda>
 <1355178112.2897.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355178112.2897.22.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 10:21:52PM +0000, Przemo Firszt wrote:
> Dnia 2012-12-10, pon o godzinie 12:41 +0300, Dan Carpenter pisze:
> > On Sun, Dec 09, 2012 at 10:15:09AM +0000, Przemo Firszt wrote:
> > > A clean up change suggested by checkpatch.pl
> > > 
> > > Signed-off-by: Przemo Firszt <przemo@firszt.eu>
> > > ---
> > >  drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> > > index cdb51d7..b131b61 100644
> > > --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> > > +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> > > @@ -188,8 +188,7 @@ static inline char *translate_scan(struct _adapter *padapter,
> > >  	/* Add the ESSID */
> > >  	iwe.cmd = SIOCGIWESSID;
> > >  	iwe.u.data.flags = 1;
> > > -	iwe.u.data.length = (u16)min((u16)pnetwork->network.Ssid.SsidLength,
> > > -			    (u16)32);
> > > +	iwe.u.data.length = min_t(u16, pnetwork->network.Ssid.SsidLength, 32);
> > 
> > pnetwork->network.Ssid.SsidLength is a u32 so it would be better to
> > not truncate the upper bits away.  It's not going to cause a
> > problem, but its slightly messy.
> > 
> > This is a common problem where people take the type of
> > iwe.u.data.length and cast to that instead of considering the types
> > for the data they are comparing.
> > 
> Dan,
> Thanks for the comment!
> 
> iew.u.data.length is __u16
> 
> min_t is defined as:
> #define min_t(type, x, y) ({                    \
>         type __min1 = (x);                      \
>         type __min2 = (y);                      \
>         __min1 < __min2 ? __min1: __min2; })
> 
> If I understand you correctly I should use this:
> 
> iwe.u.data.length = min_t(u32, pnetwork->network.Ssid.SsidLength, 32);
> 
> the result of min_t is u32, but iwe.u.data.lenght is __u16
> 

At the end iwe.u.data.length is going to be a number between 0 and
32.  That can easily fit in 16 bits no problem.

The difference is that, imagine ->network.Ssid.SsidLength is larger
than u16 like 0x10001.  The cast to u16 changes it to 0x0001 which
is less than 32 so we would say the minimum is 1 when actually we
want to say 32 is the min.

regards,
dan carpenter

