Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1HQHNg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:13:36 -0400
Received: from mailfe07.c2i.net ([212.247.154.194]:51185 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751410Ab1HQHNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:13:33 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Aug 2011 03:13:33 EDT
X-Cloudmark-Score: 0.000000 []
X-Cloudmark-Analysis: v=1.1 cv=lojAwY+qLQvc0b6kXBNtlmG9HkfIJAzprEqL70AAUZs= c=1 sm=1 a=SvYTsOw2Z4kA:10 a=55MoappXO6kA:10 a=WQU8e4WWZSUA:10 a=8nJEP1OIZ-IA:10 a=CL8lFSKtTFcA:10 a=i9M/sDlu2rpZ9XS819oYzg==:17 a=g7MaO1AOq2mC7JdXTQcA:9 a=wPNLvfGTeEIA:10 a=i9M/sDlu2rpZ9XS819oYzg==:117
From: Hans Petter Selasky <hselasky@c2i.net>
To: "Amit Blay" <ablay@codeaurora.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to devio.c
Date: Wed, 17 Aug 2011 09:06:03 +0200
User-Agent: KMail/1.13.5 (FreeBSD/8.2-STABLE; KDE/4.4.5; amd64; ; )
Cc: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        "Amit Blay" <ablay@qualcomm.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org> <8bcfda19cbc633e011e6b28a6183e68b.squirrel@www.codeaurora.org> <a9d8b0f164cdb51e88125d8432644213.squirrel@www.codeaurora.org>
In-Reply-To: <a9d8b0f164cdb51e88125d8432644213.squirrel@www.codeaurora.org>
X-Face: *nPdTl_}RuAI6^PVpA02T?$%Xa^>@hE0uyUIoiha$pC:9TVgl.Oq,NwSZ4V"|LR.+tj}g5
	%V,x^qOs~mnU3]Gn;cQLv&.N>TrxmSFf+p6(30a/{)KUU!s}w\IhQBj}[g}bj0I3^glmC(
	:AuzV9:.hESm-x4h240C`9=w
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108170906.03901.hselasky@c2i.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 July 2011 08:21:35 Amit Blay wrote:
> Hi Sarah,
> 
> A gentle reminder, can you please take a look at the proposed solution
> below for stream alloc/dealloc in devio.c? I responded to your comments
> about the original patch.

Hi,

I'm looking into implementing USB 3.0 streams support for FreeBSD and would 
like to have a solution in Linux which is not too far apart, also regarding 
API's for userspace.

I would suggest overloading the "unsigned int pipe", instead of breaking 
existing API's by adding a new stream ID value. Also for LibUSB.

./linux/usb.h:  unsigned int pipe;              /* (in) pipe information */

As per definition there are 15 bits available for "pipe". I think it is not 
important to support more than 255 streams in the first go, hence I see no 
real applications that would benefit from that many streams yet.

#define usb_pipeendpoint(pipe)  (((pipe) >> 15) & 0xf)

Then I suggest a new function/IOCTL in libusb which can be used to switch 
on/off streams on a given endpoint. This is something which would need to be 
done before submitting any URB's on that endpoint. And would be similar to the 
clear-stall case.

If an URB is submitted on a stream when streams are disabled then it should 
just fail and vice versa.

--HPS
