Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab2LDWZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 17:25:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37823 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2LDWZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 17:25:52 -0500
Date: Wed, 5 Dec 2012 01:25:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: Laurent Navet <laurent.navet@gmail.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "line6linux-devel@lists.sourceforge.net" 
	<line6linux-devel@lists.sourceforge.net>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Line6linux-devel] [PATCH] line6: Use kmemdup rather than
 duplicating its implementation
Message-ID: <20121204222529.GK6568@mwanda>
References: <1354540825-17735-1-git-send-email-laurent.navet@gmail.com>
 <CAJSP0QXcv3CYE=4Ci=vRZQgHU=nDjAYx3kbbCnVgGfcn0seTDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJSP0QXcv3CYE=4Ci=vRZQgHU=nDjAYx3kbbCnVgGfcn0seTDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 05:34:07PM +0100, Stefan Hajnoczi wrote:
> On Mon, Dec 3, 2012 at 2:20 PM, Laurent Navet <laurent.navet@gmail.com> wrote:
> > staging: line6: driver.c
> >  The semantic patch that makes this output is available
> >  in scripts/coccinelle/api/memdup.cocci.
> >
> > Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
> > ---
> >  drivers/staging/line6/driver.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/staging/line6/driver.c b/drivers/staging/line6/driver.c
> > index f5c19b2..e1d6241 100644
> > --- a/drivers/staging/line6/driver.c
> > +++ b/drivers/staging/line6/driver.c
> > @@ -331,14 +331,13 @@ int line6_version_request_async(struct usb_line6 *line6)
> >         char *buffer;
> >         int retval;
> >
> > -       buffer = kmalloc(sizeof(line6_request_version), GFP_ATOMIC);
> > +       buffer = kmemdup(line6_request_version,
> > +                       sizeof(line6_request_version), GFP_ATOMIC);
> >         if (buffer == NULL) {
> >                 dev_err(line6->ifcdev, "Out of memory");
> >                 return -ENOMEM;
> >         }
> >
> > -       memcpy(buffer, line6_request_version, sizeof(line6_request_version));
> > -
> >         retval = line6_send_raw_message_async(line6, buffer,
> >                                               sizeof(line6_request_version));
> >         kfree(buffer);
> > --
> > 1.7.10.4
> 
> Your change is fine but I'm not sure whether we should allocate memory
> in the first place:
> 
> line6_send_raw_message_async() returns before the transfer is
> complete.  It submits one or more URBs but I cannot see a guarantee
> that the buffer is no longer needed.  It seems unsafe to kfree(buffer)
> before the request is complete.
> 

As Greg pointed out we do need to allocate the memory to make DMA
work.  But you're right that it is a use after free bug.  We should
move the kfree(msg->buffer) to inside line6_async_request_sent().
I can send a fix for this tomorrow or if someone else wants to do it
while I'm sleeping that's fine too.  :)

regards,
dan carpenter

