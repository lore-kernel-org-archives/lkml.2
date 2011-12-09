Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab1LJADZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 19:03:25 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57773 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754957Ab1LJADX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 19:03:23 -0500
X-Sasl-enc: qSDn2g3yss3iaqf/hq7L+e+l4bZ9UrT/ht3XqGAo8vMJ 1323475401
Date: Fri, 9 Dec 2011 15:57:32 -0800
From: Greg KH <greg@kroah.com>
To: DONG-DONG YANG <gdb746@motorola.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kroah-Hartman <gregkh@suse.de>, Yi-wei Zhao <gbjc64@motorola.com>,
        TAO HU <taohu@motorola.com>, David Ding <dding@motorola.com>,
        Jeffrey Carlyle <jeff.carlyle@motorola.com>,
        zhiming YUAN <a14194@motorola.com>
Subject: Re: [PATCH 1/1] firmware_loading_store: fix firmware loading
 use-after-free oops
Message-ID: <20111209235732.GB6680@kroah.com>
References: <CACo43CLUiVxLof1k+Z4zL8B+mg9Giob6NhMeZn8WWGSqMc97wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACo43CLUiVxLof1k+Z4zL8B+mg9Giob6NhMeZn8WWGSqMc97wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 05:26:10PM +0800, DONG-DONG YANG wrote:
> 
> firmware_loading_store() should check for fw_priv->fw before fw_load_abort.
> Otherwise, the system has a chance to run into use-after-free oops,
> if the user-space handler sends "-1" to firmware controller(loading) in
> exception scenarios before sending "1" to start a load.
> See the attachment for the kernel log and the analysis
> 
> Tested:
>   ARM_ca9 + android init uevent + webtop udev
> 
> Patch:
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 06ed6b4..b333082 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -271,7 +271,8 @@ static ssize_t firmware_loading_store(struct device *dev,
>                 /* fallthrough */
>         case -1:
>         err:
> -               fw_load_abort(fw_priv);
> +               if (fw_priv->fw)
> +                       fw_load_abort(fw_priv);
>                 break;
>         }
> 

Can you resend this in the format described in
Documentation/SubmittingPatches so that I can accept it?  (hint, you
forgot the signed-off-by: line.)

Also, shouldn't we do the check for ->fw in the fw_load_abort() call?

And why is userspace doing wierd things like this?  What causes that?

thanks,

greg k-h
