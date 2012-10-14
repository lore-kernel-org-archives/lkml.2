Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab2JNPpH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab2JNPpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:45:01 -0400
Message-ID: <507ADD08.40305@redhat.com>
Date: Sun, 14 Oct 2012 17:40:56 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Stuge <peter@stuge.se>
Subject: Re: REGRESSION: usbdevfs: Use-scatter-gather-lists-for-large-bulk-transfers
References: <20121011213707.GA2187@polaris.bitmath.org> <Pine.LNX.4.44L0.1210121018390.1605-100000@iolanthe.rowland.org> <20121012150800.GA3097@polaris.bitmath.org>
In-Reply-To: <20121012150800.GA3097@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On 10/12/2012 05:08 PM, Henrik Rydberg wrote:
> Hi Alan,
>
>> Instead of introducing a new local variable, why not simply update
>> uurb->buffer?  That's what we do elsewhere in the code.
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
>
> I can certainly change the patch if preferred. Tested and attached
> below.
>
> Thanks,
> Henrik
>
>  From 40b70394747eea51fdd07cc8213dd6afd24b1b30 Mon Sep 17 00:00:00 2001
> From: Henrik Rydberg <rydberg@euromail.se>
> Date: Thu, 11 Oct 2012 23:27:04 +0200
> Subject: [PATCH v2] usbdevfs: Fix broken scatter-gather transfer
>
> The handling of large output bulk transfers is broken; the same u
> page is read over and over again. Fixed with this patch.
>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
> ---
>   drivers/usb/core/devio.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
> index ebb8a9d..6e58b59 100644
> --- a/drivers/usb/core/devio.c
> +++ b/drivers/usb/core/devio.c
> @@ -1349,6 +1351,7 @@
>   					goto error;
>   				}
>   			}
> +			uurb->buffer += u;

I know you've already fixed this in the next revision, but still:

NAK, this will break large, split input transfers as it well
set as->userbuffer to the end of the buffer instead of the beginning!

Regards,

Hans
