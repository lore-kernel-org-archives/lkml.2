Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab1AFX5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 18:57:45 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60861 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab1AFX5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 18:57:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LYE/Lbx02TYYYbXE5cPO/4j/WJi3XyJYc+CRZwqg9DHovmuLlzhKImG9Uj2Meyh+Sk
         PiJ28yjHHZDfeey56JOO+nRWC+DJkK5EWNp/W/cJrNGFxp9Paj+c/+ToCAyS2zcZgUQo
         d3sDaiQqGPQ0GY2WeXDGTg2RBhfCS7n8CfuwI=
MIME-Version: 1.0
In-Reply-To: <1292895677-4242-3-git-send-email-airlied@gmail.com>
References: <1292895677-4242-1-git-send-email-airlied@gmail.com>
	<1292895677-4242-3-git-send-email-airlied@gmail.com>
Date: Fri, 7 Jan 2011 09:57:41 +1000
Message-ID: <AANLkTinsVH2pyPfEjEfm9JD=D8P12Q0Y56y+ZJbpYc06@mail.gmail.com>
Subject: Re: [PATCH 2/3] vt: fix issue when fbcon wants to takeover a second time.
From: Dave Airlie <airlied@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

here is the patch I think you missed.

Dave.

On Tue, Dec 21, 2010 at 11:41 AM, Dave Airlie <airlied@gmail.com> wrote:
> From: Dave Airlie <airlied@redhat.com>
>
> With framebuffer handover and multiple GPUs, we get into a
> position where the fbcon unbinds the vesafb framebuffer for GPU 1,
> but we still have a radeon framebuffer bound from GPU 0, so
> we don't unregister the console driver. Then when we tried to bind
> the new radeon framebuffer for GPU1 we never get to the bind
> call as we fail due to the console being registered already.
>
> This changes the return value to -EBUSY when the driver is
> already registered and continues to bind for -EBUSY.
>
> Signed-off-by: Dave Airlie <airlied@redhat.com>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Greg KH <greg@suse.de>
> ---
>  drivers/tty/vt/vt.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
> index a8ec48e..d781496 100644
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3524,7 +3524,7 @@ int register_con_driver(const struct consw *csw, int first, int last)
>
>                /* already registered */
>                if (con_driver->con == csw)
> -                       retval = -EINVAL;
> +                       retval = -EBUSY;
>        }
>
>        if (retval)
> @@ -3635,7 +3635,12 @@ int take_over_console(const struct consw *csw, int first, int last, int deflt)
>        int err;
>
>        err = register_con_driver(csw, first, last);
> -
> +       /* if we get an busy error we still want to bind the console driver
> +        * and return success, as we may have unbound the console driver
> +        * but not unregistered it.
> +        */
> +       if (err == -EBUSY)
> +               err = 0;
>        if (!err)
>                bind_con_driver(csw, first, last, deflt);
>
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
