Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422697Ab2JLPKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:10:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45765 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757796Ab2JLPKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:10:38 -0400
Date: Fri, 12 Oct 2012 11:10:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Henrik Rydberg <rydberg@euromail.se>
cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Peter Stuge <peter@stuge.se>
Subject: Re: REGRESSION: usbdevfs: Use-scatter-gather-lists-for-large-bulk-transfers
In-Reply-To: <20121012150800.GA3097@polaris.bitmath.org>
Message-ID: <Pine.LNX.4.44L0.1210121108350.1605-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Henrik Rydberg wrote:

> Hi Alan,
> 
> > Instead of introducing a new local variable, why not simply update 
> > uurb->buffer?  That's what we do elsewhere in the code.
> 
> It seemed fragile, due to these scary lines:
> 
> 	if (is_in && uurb->buffer_length > 0)
> 		as->userbuffer = uurb->buffer;
> 	else
> 		as->userbuffer = NULL;
> 
> I suppose it works in this particular case.  How is the
> USBDEVFS_URB_TYPE_CONTROL case supposed to work here?

It's understood that for control transfers, the setup part of the 
buffer remains unchanged.  The data transfer starts at the eighth byte 
of the buffer.

> I can certainly change the patch if preferred. Tested and attached
> below.
> 
> Thanks,
> Henrik
> 
> From 40b70394747eea51fdd07cc8213dd6afd24b1b30 Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Thu, 11 Oct 2012 23:27:04 +0200
> Subject: [PATCH v2] usbdevfs: Fix broken scatter-gather transfer
> 
> The handling of large output bulk transfers is broken; the same user
> page is read over and over again. Fixed with this patch.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>  drivers/usb/core/devio.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index ebb8a9d..6e58b59 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1349,6 +1351,7 @@
>  					goto error;
>  				}
>  			}
> +			uurb->buffer += u;
>  			totlen -= u;
>  		}
>  	} else if (uurb->buffer_length > 0) {

Acked-by: Alan Stern <stern@rowland.harvard.edu>

