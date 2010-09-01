Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab0IARFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:05:40 -0400
Received: from proxima.lp0.eu ([81.2.80.65]:59162 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752685Ab0IARFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:05:39 -0400
Message-ID: <4C7E87DD.3080508@simon.arlott.org.uk>
Date: Wed, 01 Sep 2010 18:05:33 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100605 Thunderbird/3.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: output an error message when the pipe type doesn't
 match the endpoint type
References: <Pine.LNX.4.44L0.1008311014330.1538-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1008311014330.1538-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/10 15:16, Alan Stern wrote:
> On Mon, 30 Aug 2010, Simon Arlott wrote:
>> Commit f661c6f8c67bd55e93348f160d590ff9edf08904 adds a check of the pipe type if
>> CONFIG_USB_DEBUG is enabled, but it doesn't output anything if this scenario
>> occurs.
>> 
>> diff --git a/drivers/usb/core/urb.c b/drivers/usb/core/urb.c
>> index 419e6b3..c14fc08 100644
>> --- a/drivers/usb/core/urb.c
>> +++ b/drivers/usb/core/urb.c
>> @@ -401,8 +401,11 @@ int usb_submit_urb(struct urb *urb, gfp_t mem_flags)
>>  	/* Check that the pipe's type matches the endpoint's type */
>> -	if (usb_pipetype(urb->pipe) != pipetypes[xfertype])
>> +	if (usb_pipetype(urb->pipe) != pipetypes[xfertype]) {
>> +		dev_err(&dev->dev, "BOGUS urb xfer, pipe %x != type %x\n",
>> +			usb_pipetype(urb->pipe), pipetypes[xfertype]);
>>  		return -EPIPE;		/* The most suitable error code :-) */
>> +	}
> 
> This is okay with me.  If you're serious about not changing the
> behavior merely because debugging is enabled, you could move this test
> out of the debug-only region and possibly change the dev_err to
> dev_dbg.  However doing so might break some devices that are currently
> working.

I'd expect that to break potentially many devices, although only cxacru
stopped working for me. The USB API isn't really suitable for adding
this type of check because it allows the drivers to get away with too
much already.

usb_clear_halt() takes a pipe when it really wants the endpoint, the
pipe type is ignored.

usb_bulk_msg() auto-detects the type between interrupt and bulk, as
does usb_interrupt_msg() because the latter just calls the former.

(I think -EINVAL might be a better return code. The pipe isn't broken,
it doesn't exist.)

-- 
Simon Arlott
