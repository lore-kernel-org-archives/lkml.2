Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1I2Ogo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:36:44 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33091 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1I2Ogm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:36:42 -0400
MIME-Version: 1.0
In-Reply-To: <4E847ED4.5090703@fnarfbargle.com>
References: <4E847ED4.5090703@fnarfbargle.com>
Date: Thu, 29 Sep 2011 10:36:41 -0400
Message-ID: <CADnq5_PUcDVL+RPZPDGiAxHjn=vL7dnNsiQYG2F5e6GWnoX7Kg@mail.gmail.com>
Subject: Re: Radeon regression fix
From: Alex Deucher <alexdeucher@gmail.com>
To: Brad Campbell <brad@fnarfbargle.com>
Cc: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 10:21 AM, Brad Campbell <brad@fnarfbargle.com> wrote:
> This patch fixes a regression introduced between 2.6.39 & 3.1-rc1 whereby
> the displayport AUX channel stopped re-trying commands that elicited a DEFER
> response.
>

It should still be retrying, just restructured slightly.  The retry
logic just moved into radeon_dp_i2c_aux_ch(),
radeon_dp_aux_native_write(), and radeon_dp_aux_native_read(), e.g.,

		else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
			udelay(400);

Perhaps the delay is causing a problem.  Does removing the udelay(400); help?

Alex

> Signed-off-by: Brad Campbell <brad@fnarfbargle.com>
>
> diff --git a/drivers/gpu/drm/radeon/atombios_dp.c
> b/drivers/gpu/drm/radeon/atombios_dp.c
> index 7ad43c6..b8450f4 100644
> --- a/drivers/gpu/drm/radeon/atombios_dp.c
> +++ b/drivers/gpu/drm/radeon/atombios_dp.c
> @@ -60,11 +60,13 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan
> *chan,
>        int index = GetIndexIntoMasterTable(COMMAND,
> ProcessAuxChannelTransaction);
>        unsigned char *base;
>        int recv_bytes;
> +       int retry_count = 0;
>
>        memset(&args, 0, sizeof(args));
>
>        base = (unsigned char *)rdev->mode_info.atom_context->scratch;
>
> +retry:
>        memcpy(base, send, send_bytes);
>
>        args.v1.lpAuxRequest = 0;
> @@ -79,6 +81,16 @@ static int radeon_process_aux_ch(struct radeon_i2c_chan
> *chan,
>
>        *ack = args.v1.ucReplyStatus;
>
> +       /* defer */
> +       if (args.v1.ucReplyStatus == 0x20){
> +               DRM_DEBUG_KMS("dp_aux_ch defer\n");
> +                       /* 10 is an arbitrary value from the pre-regression
> patch
> +                       in practice I've never seen more than one */
> +                       if (retry_count++ < 10)
> +                               goto retry;
> +               return -EBUSY;
> +       }
> +
>        /* timeout */
>        if (args.v1.ucReplyStatus == 1) {
>                DRM_DEBUG_KMS("dp_aux_ch timeout\n");
>
