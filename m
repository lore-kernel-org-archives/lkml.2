Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491Ab0HGIzx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:55:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63413 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0HGIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PRJfMVuZSHor7AhK1flMpM06m3lGHmDFFwVM5YcS6BvgjdB29ZTDWG25A2IKagzaHJ
         V1IlBWjxTspxOy7Y5aiObq4csCWpp4loWPWBjJHtseDfKp2ELjtmVAeLPp5TQdSvdNXU
         +8ldkYloL/WWilUCwbWggGWOjpVI8xjyU5z6M=
Date: Sat, 7 Aug 2010 12:55:12 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Carpenter <error27@gmail.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/18] char: moxa: call disable_pci_device() if
 pci_probe() failed
Message-ID: <20100807085512.GA5783@albatros>
References: <1281124152-12630-1-git-send-email-segooon@gmail.com>
 <20100807072205.GW9031@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807072205.GW9031@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 09:22 +0200, Dan Carpenter wrote:
> On Fri, Aug 06, 2010 at 11:49:10PM +0400, Kulikov Vasiliy wrote:
> > Driver should call disable_pci_device() if it returns from pci_probe()
> > with error. Also it must not be called if pci_request_region() fails as
> > it means that somebody uses device resources and rules the device.
> > 
> 
> I think we should disable it actually.  The comments on
> pci_enable_device() and pci_disable_device() say that only the first and
> last callers actually enable and disable it.  The others just increment
> or decrement a counter.

See this thread: http://lkml.org/lkml/2005/2/13/82

Specifically this mail:

    Date    Mon, 14 Feb 2005 14:51:26 -0500
    From    Jeff Garzik <>

    ...
    You also need to consider situations such as out-of-tree drivers 
    for the same hardware (might not use PCI API), and situations where you 
    have peer devices discovered and used (PCI API doesn't have "hey, <this> 
    device is associated with <current driver>, too" capability).
    ...

Searching for 'pci_disable_device() inurl:lkml' doesn't give me newer info
aboud this problem, so I think it's better to play safe.


> 
> regards,
> dan carpenter
> 
> > Move pci_enable_device() after checking moxa_boards[] to remove senseless
> > pci_enable_device()/pci_disable_device().
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> > ---
> >  drivers/char/moxa.c |   12 +++++++-----
> >  1 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
> > index 107b0bd..0ea5aeb 100644
> > --- a/drivers/char/moxa.c
> > +++ b/drivers/char/moxa.c
> > @@ -939,11 +939,6 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
> >  	int board_type = ent->driver_data;
> >  	int retval;
> >  
> > -	retval = pci_enable_device(pdev);
> > -	if (retval) {
> > -		dev_err(&pdev->dev, "can't enable pci device\n");
> > -		goto err;
> > -	}
> >  
> >  	for (i = 0; i < MAX_BOARDS; i++)
> >  		if (moxa_boards[i].basemem == NULL)
> > @@ -956,6 +951,12 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
> >  		goto err;
> >  	}
> >  
> > +	retval = pci_enable_device(pdev);
> > +	if (retval) {
> > +		dev_err(&pdev->dev, "can't enable pci device\n");
> > +		goto err;
> > +	}
> > +
> >  	board = &moxa_boards[i];
> >  
> >  	retval = pci_request_region(pdev, 2, "moxa-base");
> > @@ -1001,6 +1002,7 @@ err_base:
> >  	board->basemem = NULL;
> >  err_reg:
> >  	pci_release_region(pdev, 2);
> > +	pci_disable_device(pdev);
> >  err:
> >  	return retval;
> >  }
> > -- 
> > 1.7.0.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
