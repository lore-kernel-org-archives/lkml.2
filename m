Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab1DSOeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:34:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40573 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1DSOeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:34:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=H2GbKUoitPnlQTIRtgDS99XZaof6HRh97yfvcfTORTBVmKKbC+Qzs6JdeqS6BYcUbO
         bN1rHhKaJbr1k3sb8wp5T2uxCOap6jzMVziSnfu5s8l+wYinCyJpAyZ14xJ8dIkN3HoN
         Etu1FqYX1RKbZ0IKU4HgOxFd1YsseP1xo0y3U=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: stern@rowland.harvard.edu, m-sonasath@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] usb: gadget: f_mass_storage: Make us pass USBCV MSC
 Compliance tests
References: <1303220033-5274-1-git-send-email-roger.quadros@nokia.com>
 <1303220033-5274-3-git-send-email-roger.quadros@nokia.com>
Date: Tue, 19 Apr 2011 16:33:54 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vt6v2sq53l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1303220033-5274-3-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 15:33:53 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:
> @@ -2468,7 +2469,7 @@ static int fsg_set_alt(struct usb_function *f,  
> unsigned intf, unsigned alt)
>  	struct fsg_dev *fsg = fsg_from_func(f);
>  	fsg->common->new_fsg = fsg;
>  	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
> -	return 0;
> +	return USB_GADGET_DELAYED_STATUS;
>  }
> static void fsg_disable(struct usb_function *f)
> @@ -2604,6 +2605,8 @@ static void handle_exception(struct fsg_common  
> *common)
> 	case FSG_STATE_CONFIG_CHANGE:
>  		do_set_interface(common, common->new_fsg);
> +		if (common->new_fsg)
> +			usb_composite_setup_continue(common->cdev);
>  		break;
> 	case FSG_STATE_EXIT:

At first I thought that it's a mismatch since USB_GADGET_DELAYED_STATUS
is returned all the time but usb_composite_setup_continue() is called
only if common->new_fsg is set but after more careful investigation
this seems to be correct.

> @@ -3083,6 +3086,7 @@ static int fsg_bind_config(struct  
> usb_composite_dev *cdev,
>  	fsg->function.disable     = fsg_disable;
> 	fsg->common               = common;
> +	fsg->common->cdev	  = cdev;
>  	/*
>  	 * Our caller holds a reference to common structure so we
>  	 * don't have to be worry about it being freed until we return

common->cdev initialisation should be moved to fsg_common_init().

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
