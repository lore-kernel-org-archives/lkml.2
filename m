Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab1ACWHp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 17:07:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47135 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1ACWHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 17:07:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AtJFdYQORmtcbkQT90fCHmhwzV0qUHT6+XT1zGfoVbJHaoGCzpXj0EcyAnKk1hCvW0
         H0Hc2YrMcpNUvYR6ncdkhDmfduT5KAB3bQc434VmCcWyQxS4Ug/41ASYh3Ee8+AUBnmt
         qNPhSvcp3Rgad+/kNP9shUhTejOAYUj0M0TMc=
Subject: Re: [PATCH 2/3] mx3_camera: Support correctly the YUV222 and BAYER
 configurations of CSI
From: Alberto Panizzo <maramaopercheseimorto@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Magnus Damm <damm@opensource.se>,
        =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
        linux-media@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1101031931160.23134@axis700.grange>
References: <1290964687.3016.5.camel@realization>
	 <1290965045.3016.11.camel@realization>
	 <Pine.LNX.4.64.1012011832430.28110@axis700.grange>
	 <Pine.LNX.4.64.1012181722200.18515@axis700.grange>
	 <Pine.LNX.4.64.1012302028100.13281@axis700.grange>
	 <1294076008.2493.85.camel@realization>
	 <Pine.LNX.4.64.1101031931160.23134@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Jan 2011 23:07:29 +0100
Message-ID: <1294092449.2493.135.camel@realization>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 20:37 +0100, Guennadi Liakhovetski wrote:
> On Mon, 3 Jan 2011, Alberto Panizzo wrote:
> 
> > On Thu, 2010-12-30 at 20:38 +0100, Guennadi Liakhovetski wrote:
> > > On Sat, 18 Dec 2010, Guennadi Liakhovetski wrote:
> > > 
> > > > Alberto
> > > > 
> > > > it would be slowly on the time to address my comments and submit updates. 
> > > > While at it, also, please update the subject - you probably meant "YUV422" 
> > > > or "YUV444" there, also below:
> > > 
> > > Ok, I'm dropping this patch
> > > 
> > > Alberto, I've applied and pushed your other 2 patches from this series, 
> > > but I've dropped this one. The reason is not (only), that you didn't reply 
> > > to my two last mails with update-requests. But because of that I took the 
> > > time today to look deeper into detail at this patch. And as a result, I 
> > > don't think it is correct.
> > > 
> > > Currently the mx3_camera driver transfers data from video clients (camera 
> > > sensors) only in one mode - as raw data, 1-to-1. This is extablished in 
> > > the way, how it creates format translation tables during the initial 
> > > negotiation with client drivers in mx3_camera_get_formats().
> > > 
> > > Your patch is trying to add support for specific modes on CSI, but is only 
> > > doing this in the transfer part of the driver, and not in the negotiation 
> > > part. So, if you really need native support for various pixel formats, 
> > > this is a wrong way to do this. If you only want to transfer data from 
> > > your sensor into RAM and the current driver is failing for you, then this 
> > > is a wrong way to do this, and the bug has to be found and fixed, while 
> > > maintaining the present pass-through only model.
> > > 
> > 
> > This patch shows that IPU and CSI manage parameters in different 
> > units. It shows that an unknown at the CSI pixel format, that require n
> > bytes per pixel, have to be considered generic on the IPU side and the
> > parameters of the DMA and CSI have to be set properly to support it.
> > In this way also 10-bit wide pixels formats can be managed in pass
> > through mode, setting properly the IPU and CSI parameters.
> > 
> > So, this patch shows that the CSI can manage successfully n-byte wide
> > pixel codes (tested with n = 1,2) without breaking the old behaviour
> > of providing 10-bit wide pixel formats with 8-bit wide ones.
> > 
> > The next step is to uniform also the pixel-code translations at this 
> > type of management. Being able to capture real 10-bit wide samples.
> > 
> > This patch also, make use of a native functionality of the CSI: capture 
> > a YUV422 format. 
> > In this case the CSI convert this pixel format to YUV444 sent to the 
> > BUS  and the IPU re-pack the YUV444 to YUV422 into the memory.
> > 
> > This shows how CSI and IPU manage formats different than the generic 
> > one and open the way to understand how to support the communication
> > between agents of the IPU encoding chain.
> > 
> > Maybe the last part is misleading you and can be dropped out from this 
> > patch as an enhancement: the YUV422 interleaved format can be 
> > successfully managed as CSI-BAYER/IPU-GENERIC one, the same as rgb565.
> > Supporting the CSI-YUV422 is a plus only to show how the CSI works.
> 
> Let's try slowly again:
> 
> 1. The current mainline driver doesn't work for you, right? What exactly 
> is failing and how? What fourcc format?

Yes, does not work for me for both YUV422 interleaved and rgb565.
What is captured is an image that have in the bottom half the violet 
color and in the upper half, half of the real image (divided 
vertically) with even rows on the left and odd rows on the right.


> 2. Do you think, it would be possible to fix the driver to also support 
> your use-case with the present generic / pass-through mode? Have you tried 
> this? Could you try? That would be a bug-fix.

Yes, this is the way I told about: dividing the geometry fixes from the 
special YUV422 support.

> 
> 3. After the first two questions are answered, then we can think about 
> extending the driver by adding native support forvarious specific formats.

Yes, sure. I'll try to explain better what the single patches are 
fixing, improving especially for these core functionality.


Best Regards,
Alberto!

