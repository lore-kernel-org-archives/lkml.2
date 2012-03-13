Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757780Ab2CMQzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:55:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:64412 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab2CMQy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:54:57 -0400
Message-ID: <4F5F7BDD.9070404@windriver.com>
Date: Tue, 13 Mar 2012 12:54:53 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.27) Gecko/20120216 Thunderbird/3.1.19
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: Re: [34-longterm 077/196] USB: xhci - fix math in xhci_get_endpoint_interval()
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com> <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com> <1331598109-31424-32-git-send-email-paul.gortmaker@windriver.com> <20120313162044.GI6955@xanatos>
In-Reply-To: <20120313162044.GI6955@xanatos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-13 12:20 PM, Sarah Sharp wrote:
> This commit introduced a bug, so you will need this fix as well:

Thanks.

> 
> commit 340a3504fd39dad753ba908fb6f894ee81fc3ae2
> Author: Sarah Sharp <sarah.a.sharp@linux.intel.com>
> Date:   Mon Feb 13 14:42:11 2012 -0800
> 
>     xhci: Fix encoding for HS bulk/control NAK rate.
>     
>     The xHCI 0.96 spec says that HS bulk and control endpoint NAK rate must
>     be encoded as an exponent of two number of microframes.  The endpoint
>     descriptor has the NAK rate encoded in number of microframes.  We were
>     just copying the value from the endpoint descriptor into the endpoint
>     context interval field, which was not correct.  This lead to the VIA
>     host rejecting the add of a bulk OUT endpoint from any USB 2.0 mass
>     storage device.
>     
>     The fix is to use the correct encoding.  Refactor the code to convert
>     number of frames to an exponential number of microframes, and make sure
>     we convert the number of microframes in HS bulk and control endpoints to
>     an exponent.
>     
>     This should be back ported to kernels as old as 2.6.31, that contain the
>     commit dfa49c4ad120a784ef1ff0717168aa79f55a483a "USB: xhci - fix math
>     in xhci_get_endpoint_interval"
>     
>     Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>     Tested-by: Felipe Contreras <felipe.contreras@gmail.com>
>     Suggested-by: Andiry Xu <andiry.xu@amd.com>
>     Cc: stable@vger.kernel.org
> 
> Why are you hand-picking which of the xHCI commits marked for stable to
> apply to this new 2.6.34 stable tree?  On top of this patch, you're

I've been using the commits applied to 2.6.32.x versions as a reference.
I can't do a release with 1000 commits, so I have to chunkify things
somewhat, and doing roughly parallels of the individual 2.6.32.x releases
is a good starting point.  Most times the commits for stable are independent
bugfixes chosen for high value and low risk of regression, so this typically
works fine.  If there are dependencies and regressions in the xHCI stable
content that I should be trying to avoid, I'm fine with taking that input.

Paul.

> probably missing twenty or so other required bug fix patches.  I'm very
> careful about saying which patches should apply to which stable kernels,
> so it should be easy for you to go through the current -rc git log and
> grep for changes to the xHCI driver that are marked for stable.
> 
> Sarah Sharp
> 
> On Mon, Mar 12, 2012 at 08:19:50PM -0400, Paul Gortmaker wrote:
>> From: Dmitry Torokhov <dtor@vmware.com>
>>
>>                    -------------------
>>     This is a commit scheduled for the next v2.6.34 longterm release.
>>     If you see a problem with using this for longterm, please comment.
>>                    -------------------
>>
>> commit dfa49c4ad120a784ef1ff0717168aa79f55a483a upstream.
>>
>> When parsing exponent-expressed intervals we subtract 1 from the
>> value and then expect it to match with original + 1, which is
>> highly unlikely, and we end with frequent spew:
>>
>> 	usb 3-4: ep 0x83 - rounding interval to 512 microframes
>>
>> Also, parsing interval for fullspeed isochronous endpoints was
>> incorrect - according to USB spec they use exponent-based
>> intervals (but xHCI spec claims frame-based intervals). I trust
>> USB spec more, especially since USB core agrees with it.
>>
>> This should be queued for stable kernels back to 2.6.31.
>>
>> Reviewed-by: Micah Elizabeth Scott <micah@vmware.com>
>> Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
>> Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>> ---
>>  drivers/usb/host/xhci-mem.c |   90 +++++++++++++++++++++++++++++--------------
>>  1 file changed, 62 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
>> index e560dd4..e1dbcc2 100644
>> --- a/drivers/usb/host/xhci-mem.c
>> +++ b/drivers/usb/host/xhci-mem.c
>> @@ -520,6 +520,47 @@ int xhci_setup_addressable_virt_dev(struct xhci_hcd *xhci, struct usb_device *ud
>>  	return 0;
>>  }
>>  
>> +/*
>> + * Convert interval expressed as 2^(bInterval - 1) == interval into
>> + * straight exponent value 2^n == interval.
>> + *
>> + */
>> +static unsigned int xhci_parse_exponent_interval(struct usb_device *udev,
>> +		struct usb_host_endpoint *ep)
>> +{
>> +	unsigned int interval;
>> +
>> +	interval = clamp_val(ep->desc.bInterval, 1, 16) - 1;
>> +	if (interval != ep->desc.bInterval - 1)
>> +		dev_warn(&udev->dev,
>> +			 "ep %#x - rounding interval to %d microframes\n",
>> +			 ep->desc.bEndpointAddress,
>> +			 1 << interval);
>> +
>> +	return interval;
>> +}
>> +
>> +/*
>> + * Convert bInterval expressed in frames (in 1-255 range) to exponent of
>> + * microframes, rounded down to nearest power of 2.
>> + */
>> +static unsigned int xhci_parse_frame_interval(struct usb_device *udev,
>> +		struct usb_host_endpoint *ep)
>> +{
>> +	unsigned int interval;
>> +
>> +	interval = fls(8 * ep->desc.bInterval) - 1;
>> +	interval = clamp_val(interval, 3, 10);
>> +	if ((1 << interval) != 8 * ep->desc.bInterval)
>> +		dev_warn(&udev->dev,
>> +			 "ep %#x - rounding interval to %d microframes, ep desc says %d microframes\n",
>> +			 ep->desc.bEndpointAddress,
>> +			 1 << interval,
>> +			 8 * ep->desc.bInterval);
>> +
>> +	return interval;
>> +}
>> +
>>  /* Return the polling or NAK interval.
>>   *
>>   * The polling interval is expressed in "microframes".  If xHCI's Interval field
>> @@ -537,45 +578,38 @@ static inline unsigned int xhci_get_endpoint_interval(struct usb_device *udev,
>>  	case USB_SPEED_HIGH:
>>  		/* Max NAK rate */
>>  		if (usb_endpoint_xfer_control(&ep->desc) ||
>> -				usb_endpoint_xfer_bulk(&ep->desc))
>> +		    usb_endpoint_xfer_bulk(&ep->desc)) {
>>  			interval = ep->desc.bInterval;
>> +			break;
>> +		}
>>  		/* Fall through - SS and HS isoc/int have same decoding */
>> +
>>  	case USB_SPEED_SUPER:
>>  		if (usb_endpoint_xfer_int(&ep->desc) ||
>> -				usb_endpoint_xfer_isoc(&ep->desc)) {
>> -			if (ep->desc.bInterval == 0)
>> -				interval = 0;
>> -			else
>> -				interval = ep->desc.bInterval - 1;
>> -			if (interval > 15)
>> -				interval = 15;
>> -			if (interval != ep->desc.bInterval + 1)
>> -				dev_warn(&udev->dev, "ep %#x - rounding interval to %d microframes\n",
>> -						ep->desc.bEndpointAddress, 1 << interval);
>> +		    usb_endpoint_xfer_isoc(&ep->desc)) {
>> +			interval = xhci_parse_exponent_interval(udev, ep);
>>  		}
>>  		break;
>> -	/* Convert bInterval (in 1-255 frames) to microframes and round down to
>> -	 * nearest power of 2.
>> -	 */
>> +
>>  	case USB_SPEED_FULL:
>> +		if (usb_endpoint_xfer_int(&ep->desc)) {
>> +			interval = xhci_parse_exponent_interval(udev, ep);
>> +			break;
>> +		}
>> +		/*
>> +		 * Fall through for isochronous endpoint interval decoding
>> +		 * since it uses the same rules as low speed interrupt
>> +		 * endpoints.
>> +		 */
>> +
>>  	case USB_SPEED_LOW:
>>  		if (usb_endpoint_xfer_int(&ep->desc) ||
>> -				usb_endpoint_xfer_isoc(&ep->desc)) {
>> -			interval = fls(8*ep->desc.bInterval) - 1;
>> -			if (interval > 10)
>> -				interval = 10;
>> -			if (interval < 3)
>> -				interval = 3;
>> -			if ((1 << interval) != 8*ep->desc.bInterval)
>> -				dev_warn(&udev->dev,
>> -						"ep %#x - rounding interval"
>> -						" to %d microframes, "
>> -						"ep desc says %d microframes\n",
>> -						ep->desc.bEndpointAddress,
>> -						1 << interval,
>> -						8*ep->desc.bInterval);
>> +		    usb_endpoint_xfer_isoc(&ep->desc)) {
>> +
>> +			interval = xhci_parse_frame_interval(udev, ep);
>>  		}
>>  		break;
>> +
>>  	default:
>>  		BUG();
>>  	}
>> -- 
>> 1.7.9.3
>>
