Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab2BIPp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 10:45:29 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:63236 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752885Ab2BIPp2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 10:45:28 -0500
MIME-Version: 1.0
In-Reply-To: <20120209141703.GB3852@pengutronix.de>
References: <1328285474-26365-1-git-send-email-javier.martin@vista-silicon.com>
	<20120209141703.GB3852@pengutronix.de>
Date: Thu, 9 Feb 2012 16:45:26 +0100
Message-ID: <CACKLOr1+OW+f4Nku0W-jtZpE78afx0JX+H9tgGya+tUGS-K8gQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] i.MX DMA: Add support for 2D transfers.
From: javier Martin <javier.martin@vista-silicon.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, kernel@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On 9 February 2012 15:17, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> On Fri, Feb 03, 2012 at 05:11:13PM +0100, Javier Martin wrote:
>> DMAC present in i.MX2 and i.MX1 chips have two
>> 2D configuration slots that any DMA channel can
>> use to make 2D DMA transfers.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>
> My problem with this patch is that it adds new code to
> arch/arm/mach-imx/dma-v1.c.
> The original intention of having a legacy driver in arch/arm/mach-imx/dma-v1.c
> and a dmaengine driver in drivers/dma was that we move remove the
> arch/arm parts to drivers/dma once all users have switched to the new
> API.

I wasn't aware of that. I couldn't find any warning comment in the
code or anything.

>I fixed the sound drivers and the mxcmmc driver already.  We
> currently have the imxmmc driver and the i.MX1/2 camera drivers left
> in the tree.

I know, I tested those changes myself and works properly. Thank you.

>The imxmmc driver is broken for ages and I think we can
> remove it when nobody takes care of putting it back to work. You seem to
> work on the i.MX2 camera driver and thus you should be able to fix it
> (do you use DMA here or the EMMA engine?).

Currently i.MX2 camera does not use DMAs. You removed support for it
recently (which I found very convenient) and I don't have plans to use
them. This means that there is no i.MX2 driver using legacy code out
there.

>This leaves the i.MX1 driver
> and I have no possibility to fix it. I once pinged Paulius about this
> issue but appearently nothing has happened.
> I think we should start cleaning this up even if we risk breaking
> something. Otherwise we are stuck with the legacy driver forever.

Let me explain the situation I have here (which is a summarize of what
I have already explained to Vinod):

We have a video processing chain which involves a tvp5150, mx2 camera
capture driver and and intermediate deinterlacing driver (mem2mem).

Deinterlacing driver requires a full working dmaengine API and
interleaved transfer support. As a consequence our development process
is organized as follows:

- Step 1 (already submitted):
[PATCH v3] dmaengine: Add support for MEMCPY for imx-dma.

This step is important for us since it gives us access to the dmatest
module and allows to develop a first prototype of the driver which
just copies the content of one buffer into another.

- Step 2 (also submitted):
[PATCH 1/2] i.MX DMA: Add support for 2D transfers.
[PATCH 2/2] dmaengine: i.MX: Add support for interleaved transfers.

With this step we have know a first working version of a driver which
actually does video deinterlacing. However, since current dmaengine
support for imx only regards a single descriptor, this code is quite
ugly and dirty.

- Step 3 (developing):
dmaengine: i.MX: Support multiple descriptors.

The problem here is that, after 6 days from my last patch, I have
Step3 nearly finished (I was just testing it when I received your
e-mail). According to your suggestion, I would have to rewrite all my
code in order to drop the arch/arm file. However, we are targeting for
merge window 3.4 and have already agreed with Guennadi some cleanup
patches for the mx2_camera driver.

I know that you want that file to be dropped and I understand, but my
schedule is so tight that I can't afford a complete rewriting right
now. I hope you can undesrtand too.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
