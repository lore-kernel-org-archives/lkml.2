Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870Ab1HVH7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 03:59:34 -0400
Received: from mailfe04.c2i.net ([212.247.154.98]:44925 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752441Ab1HVH70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 03:59:26 -0400
X-Cloudmark-Score: 0.000000 []
X-Cloudmark-Analysis: v=1.1 cv=T62/IVpqZ1mLJMkeHfndQHXgWa4ATHZu3+3wVrCy9JU= c=1 sm=1 a=SvYTsOw2Z4kA:10 a=55MoappXO6kA:10 a=WQU8e4WWZSUA:10 a=8nJEP1OIZ-IA:10 a=CL8lFSKtTFcA:10 a=i9M/sDlu2rpZ9XS819oYzg==:17 a=gu6fZOg2AAAA:8 a=RtYKlhKViTtdSjik8fMA:9 a=wPNLvfGTeEIA:10 a=i9M/sDlu2rpZ9XS819oYzg==:117
From: Hans Petter Selasky <hselasky@c2i.net>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to devio.c
Date: Mon, 22 Aug 2011 09:56:51 +0200
User-Agent: KMail/1.13.5 (FreeBSD/8.2-STABLE; KDE/4.4.5; amd64; ; )
Cc: Amit Blay <ablay@codeaurora.org>,
        Tatyana Brokhman <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        Amit Blay <ablay@qualcomm.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20110818224713.GA6738@xanatos>
In-Reply-To: <20110818224713.GA6738@xanatos>
X-Face: *nPdTl_}RuAI6^PVpA02T?$%Xa^>@hE0uyUIoiha$pC:9TVgl.Oq,NwSZ4V"|LR.+tj}g5
	%V,x^qOs~mnU3]Gn;cQLv&.N>TrxmSFf+p6(30a/{)KUU!s}w\IhQBj}[g}bj0I3^glmC(
	:AuzV9:.hESm-x4h240C`9=w
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108220956.51135.hselasky@c2i.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> 
> On Wed, Aug 17, 2011 at 09:06:03AM +0200, Hans Petter Selasky wrote:
> > I'm looking into implementing USB 3.0 streams support for FreeBSD and
> > would like to have a solution in Linux which is not too far apart, also
> > regarding API's for userspace.
> > 
> > I would suggest overloading the "unsigned int pipe", instead of breaking
> > existing API's by adding a new stream ID value. Also for LibUSB.
> > 
> > ./linux/usb.h:  unsigned int pipe;              /* (in) pipe information
> > */
> 
> I think this gets very close to breaking current API for usbfs.  What
> happens if some application is putting garbage in the upper bits of the
> pipe? 

I think this will never happen, because all USB applications I know about are 
taught to use a set of macros to create the "pipe" value, which by default 
zero these bits.

> A libusb application that worked before will break because the
> USB core will reject the endpoint as not having streams enabled.  So I
> think it's better to have a new IOCTL for submitting URBs to endpoints
> with streams enabled, as Alan suggested:
> 
> http://marc.info/?l=linux-kernel&m=130832352124932&w=2
> 
> > As per definition there are 15 bits available for "pipe". I think it is
> > not important to support more than 255 streams in the first go, hence I
> > see no real applications that would benefit from that many streams yet.
> 
> I don't see this as a strong argument why we should arbitrarily limit a
> new API.  It's very hard to deprecate kernel to userspace API, so I
> think we should do it right the first time.  There are current
> applications (like an SSD behind a UAS device) that need as many
> concurrent streams in flight as possible, so I don't buy the argument
> that there aren't current applications that need that many streams.
> 
> I don't want to limit future applications of streams without a very good
> reason.  I would like to see the new API allow userspace to submit URBs
> for stream IDs up to the maximum limit specified by the USB 3.0 spec
> (65,533 streams).
> 
> Why do you think reusing the pipe variable would be a better solution?
> You're going to need a new IOCTL to enable streams anyway, so why not
> also have a new IOCTL for submitting an URB to an endpoint with streams
> enabled?

What I'm thinking is that you should try to integrate the streams 
functionality as much as possible, with existing API's, so that API's that do 
roughly the same are not duplicated. In FreeBSD 8/9 we have more free bits in 
the pipe variable, and I'll probably use that for the stream ID. It's like 
IPv4 and IPv6, that you extend fields when required and not duplicate them. 
I'm just worried that intel will come up with yet-another way to transfer data 
in a few years, and then we'll have to wreck API's again. So why not foresee 
that now and make 128-bits available for endpoint/stream/XXX addressing?

> 
> > #define usb_pipeendpoint(pipe)  (((pipe) >> 15) & 0xf)
> > 
> > Then I suggest a new function/IOCTL in libusb which can be used to switch
> > on/off streams on a given endpoint. This is something which would need to
> > be done before submitting any URB's on that endpoint. And would be
> > similar to the clear-stall case.
> 
> Amit was discussing such an IOCTL.  The problem is you just can't turn
> streams "on and off".  The xHCI driver has to have an indication of how
> many streams your application will need.  That's why Amit's proposal
> included a way for the application to pass in the number of streams to
> allocate.

Ok.

> 
> > If an URB is submitted on a stream when streams are disabled then it
> > should just fail and vice versa.
> 
> That code is already included in the xHCI driver, and usbfs shouldn't do
> any checking of the stream ID for the URB, since it's already in the
> lower level driver.

Ok.

--HPS
