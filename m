Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab2K3LQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 06:16:26 -0500
Received: from mx3.cyfra.ua ([62.80.160.182]:33010 "EHLO mx3.cyfra.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738Ab2K3LQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 06:16:24 -0500
From: Vitalii Demianets <vitas@nppfactor.kiev.ua>
Organization: Factor-SPE
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH] uio.c: Fix warning: 'ret' might be used uninitialized
Date: Fri, 30 Nov 2012 13:16:19 +0200
User-Agent: KMail/1.9.10
Cc: Tux9 <tuxding@gmail.com>, linux-kernel@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
References: <201211271348.14603.vitas@nppfactor.kiev.ua> <201211291836.59358.vitas@nppfactor.kiev.ua> <20121129235822.GA2590@local>
In-Reply-To: <20121129235822.GA2590@local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201211301316.19217.vitas@nppfactor.kiev.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2012 01:58:22 Hans J. Koch wrote:
> On Thu, Nov 29, 2012 at 06:36:59PM +0200, Vitalii Demianets wrote:
> > > On Thursday 29 November 2012 18:05:27 Tux9 wrote:
> > > > Hans, I think there are something wrong in your patch, while
> > > > Vitalii's is right. The variable "ret" is reused in line 292 and line
> > > > 295, so the value of "ret" would be overridden (if it goto err_map in
> > > > line 284 when mi>=1).
> > >
> > > Actually, both patches do exactly the same thing. Hans's patch
> > > establishes default value for the ret for all those "other" cases when
> > > ret is not explicitly overridden. My patch explicitly enumerates all
> > > those "other" cases in more wordily manner.
> >
> > Oops, disregard this. After looking at it more thoroughly I got your
> > point. You are right, ret is overridden at first iteration (mi == 0), so
> > Hans's approach does not work.
> > I must do more thinking before replying in a hurry.
>
> You're right. Initialization of "ret" has to take place at the beginning of
> the loop.
>
> I think this version is right:

Yes, this looks right for me.

> >From 00c3c734c0dde67873a628bcb18cee403c95c301 Mon Sep 17 00:00:00 2001
>
> From: "Hans J. Koch" <hjk@hansjkoch.de>
> Date: Fri, 30 Nov 2012 00:51:50 +0100
> Subject: [PATCH] uio: Fix warning: 'ret' might be used uninitialized
>
> In two cases, the return value variable "ret" can be undefined.
>
> Signed-off-by: Hans J. Koch <hjk@hansjkoch.de>
> ---
>  drivers/uio/uio.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
> index 5110f36..0c80df2 100644
> --- a/drivers/uio/uio.c
> +++ b/drivers/uio/uio.c
> @@ -273,6 +273,7 @@ static int uio_dev_add_attributes(struct uio_device
> *idev) struct uio_portio *portio;
>
>  	for (mi = 0; mi < MAX_UIO_MAPS; mi++) {
> +		ret = -ENOMEM;
>  		mem = &idev->info->mem[mi];
>  		if (mem->size == 0)
>  			break;
> @@ -298,6 +299,7 @@ static int uio_dev_add_attributes(struct uio_device
> *idev) }
>
>  	for (pi = 0; pi < MAX_UIO_PORT_REGIONS; pi++) {
> +		ret = -ENOMEM;
>  		port = &idev->info->port[pi];
>  		if (port->size == 0)
>  			break;
