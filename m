Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933398Ab1CXSf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 14:35:26 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58817 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab1CXSfZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 14:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=PbvNWxtyefC1BVtNlGTKKKAedrfQUFr0Ba/nZVI1el25ZvRwQ2rurIJwNlE3D+LHVY
         vKqbnXNUuYGZ+76xle1lAB4lNBytVfP+HPyes7+inST44g/5pxP3TQho0+Q20SjEqj8d
         hevWUrBeytiTd1d+f4bTuhQMHgHlDE7IECft4=
MIME-Version: 1.0
In-Reply-To: <1300980071-24645-4-git-send-email-jamie@jamieiles.com>
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <1300980071-24645-4-git-send-email-jamie@jamieiles.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 24 Mar 2011 14:35:00 -0400
X-Google-Sender-Auth: QldbWPFlzOsHRV7Vnn85fmZafX4
Message-ID: <AANLkTi=c+664qQqiKOLmvdFScizUC7+88SrCx7WJnp0b@mail.gmail.com>
Subject: Re: [RFC PATCHv2 3/4] drivers/otp: allow an ioctl to be specified
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 11:21, Jamie Iles wrote:
> Some drivers may need an ioctl method to provide device specific control
> such as blackfin for providing locking.  Regions can specify an ioctl to
> be used but this field method is optional.

shouldnt this just be squashed into patch 1 since you havent merged
any of this yet ?

> +static long otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
> +{
> +       struct otp_region *region = filp->private_data;
> +       long ret = -ENOTTY;
> +
> +       if (down_interruptible(&otp_sem))
> +               return -ERESTARTSYS;
> +
> +       if (region->ops->ioctl)
> +               ret = region->ops->ioctl(region, cmd, arg);
> +
> +       up(&otp_sem);
> +
> +       return ret;
> +}

the existence check can be pulled out of the locking

long ret;

if (!region->ops->ioctl)
    return -ENOTTY;

if (down_interruptible(&otp_sem))

    return -ERESTARTSYS;

ret = region->ops->ioctl(region, cmd, arg);

up(&otp_sem);

return ret;
-mike
