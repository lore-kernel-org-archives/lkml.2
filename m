Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab0DWKYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 06:24:34 -0400
Received: from mail-iw0-f178.google.com ([209.85.223.178]:61735 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972Ab0DWKYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 06:24:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eDWYQQCaSOW3GF3Nz0nL8Iqi2cvAN5twhbHRVlluV+lsuT6GEcO/HkZ77BgY97BKdg
         DRzgMhdJ23fjPgWdfWsByYbUSDSxQOM9W6y5yo7CSI2BDVGP8Gr7jeQvr4KD+e1ER95u
         ef95u8SHQWBnuQ4dzfuWCyux5jjXF95W/VAmc=
MIME-Version: 1.0
In-Reply-To: <20100423112222.67cfcbb2@lxorguk.ukuu.org.uk>
References: <20100423112222.67cfcbb2@lxorguk.ukuu.org.uk>
Date: Fri, 23 Apr 2010 20:24:28 +1000
Message-ID: <s2l21d7e9971004230324me3de75b0w58a9907999b7872a@mail.gmail.com>
Subject: Re: Locking question for DRM
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 8:22 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
> Various bits of the DRM deal with minor->master:
>
> In the case of the open helper its protected by the struct mutex.
>
> In the release path it's protected on some paths, but not this one ...
>
>     /* if the master has gone away we can't do anything with the lock */
>        if (file_priv->minor->master)
>                drm_master_release(dev, filp);
>
> and I can't see what makes this safe if the drm_release for the master
> and a client occur at the same time ?

lock_kernel in drm_release. We probably need to clean that up.

>
> The setmaster/dropmaster ioctl seems similar - the various conditional
> checks are not protected from parallel changes occuring during their
> execution.
>
> Is this a bug or is something clever afoot ?

These ioctls are also under the BKL.

So yes its nasty, and we should probably grow a minor lock to protect that.

Dave.
