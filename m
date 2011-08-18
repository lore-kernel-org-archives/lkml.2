Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab1HRWra (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:47:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:20019 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754993Ab1HRWr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:47:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,247,1312182000"; 
   d="scan'208";a="40014299"
Date: Thu, 18 Aug 2011 15:47:13 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Amit Blay <ablay@codeaurora.org>, Hans Petter Selasky <hselasky@c2i.net>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        Amit Blay <ablay@qualcomm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to
 devio.c
Message-ID: <20110818224713.GA6738@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108170906.03901.hselasky@c2i.net>
 <a9d8b0f164cdb51e88125d8432644213.squirrel@www.codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:21:35PM -0700, Amit Blay wrote:
> On Tue, July 19, 2011 2:12 am, Amit Blay wrote:
> > What I have in mind is user space passing a structure holding:
> >
> > 1. Interface number [IN]
> > 2. Bitmap indicating which EP to allocate streams for [IN]
> > 3. Number of streams to allocate, one number [IN}
> > 4. Number of streams actually allocated, one number  [OUT]
> >
> > The devio alloc function will double check if all EPs belong to the
> > interface passed by the user space.
> > Then it will call the HCI alloc function with the required number of
> > streams. It will return the number of streams actually allocated by the
> > HCD. Items 3 & 4 can be merged to one IN/OUT parameter.
> >
> > No error checking will be done in devio for number of required streams
> > (i.e, comparing it with the reported max streams). This kind of error
> > checking is already done by the xHCI driver.
> >
> > Please let me know if the solution is acceptable.

Yes, I think this is the correct solution.  Sorry for taking so long to
get back to you.


On Wed, Aug 17, 2011 at 09:06:03AM +0200, Hans Petter Selasky wrote:
> I'm looking into implementing USB 3.0 streams support for FreeBSD and would 
> like to have a solution in Linux which is not too far apart, also regarding 
> API's for userspace.
> 
> I would suggest overloading the "unsigned int pipe", instead of breaking 
> existing API's by adding a new stream ID value. Also for LibUSB.
> 
> ./linux/usb.h:  unsigned int pipe;              /* (in) pipe information */

I think this gets very close to breaking current API for usbfs.  What
happens if some application is putting garbage in the upper bits of the
pipe?  A libusb application that worked before will break because the
USB core will reject the endpoint as not having streams enabled.  So I
think it's better to have a new IOCTL for submitting URBs to endpoints
with streams enabled, as Alan suggested:

http://marc.info/?l=linux-kernel&m=130832352124932&w=2

> As per definition there are 15 bits available for "pipe". I think it is not 
> important to support more than 255 streams in the first go, hence I see no 
> real applications that would benefit from that many streams yet.

I don't see this as a strong argument why we should arbitrarily limit a
new API.  It's very hard to deprecate kernel to userspace API, so I
think we should do it right the first time.  There are current
applications (like an SSD behind a UAS device) that need as many
concurrent streams in flight as possible, so I don't buy the argument
that there aren't current applications that need that many streams.

I don't want to limit future applications of streams without a very good
reason.  I would like to see the new API allow userspace to submit URBs
for stream IDs up to the maximum limit specified by the USB 3.0 spec
(65,533 streams).

Why do you think reusing the pipe variable would be a better solution?
You're going to need a new IOCTL to enable streams anyway, so why not
also have a new IOCTL for submitting an URB to an endpoint with streams
enabled?

> #define usb_pipeendpoint(pipe)  (((pipe) >> 15) & 0xf)
> 
> Then I suggest a new function/IOCTL in libusb which can be used to switch 
> on/off streams on a given endpoint. This is something which would need to be 
> done before submitting any URB's on that endpoint. And would be similar to the 
> clear-stall case.

Amit was discussing such an IOCTL.  The problem is you just can't turn
streams "on and off".  The xHCI driver has to have an indication of how
many streams your application will need.  That's why Amit's proposal
included a way for the application to pass in the number of streams to
allocate.

> If an URB is submitted on a stream when streams are disabled then it should 
> just fail and vice versa.

That code is already included in the xHCI driver, and usbfs shouldn't do
any checking of the stream ID for the URB, since it's already in the
lower level driver.

Sarah Sharp
