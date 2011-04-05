Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1DEQAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 12:00:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:41753 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1DEP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 11:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=U0XLkyi2k/XiKf1kEPbj1mAa3eRp3htZ4O4azUC04xrVYkiSvPjoRGDBWX6JZyiu7F
         Wkr36z+seUET6gSXwZgXRinWtpMm22UVArI74Bm4V3oO7ORSY/uPFTmNo1OZyHXHJc42
         s6Ljip8UB1VQCA0NXGYkbiSSD3tspy/qnCoNU=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: gregkh@suse.de, "Roger Quadros" <roger.quadros@nokia.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] usb: gadget: f_mass_storage: Fix potential memory
 leak
References: <1302017802-16614-1-git-send-email-roger.quadros@nokia.com>
 <1302017802-16614-5-git-send-email-roger.quadros@nokia.com>
Date: Tue, 05 Apr 2011 17:59:54 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vtg2p4fl3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1302017802-16614-5-git-send-email-roger.quadros@nokia.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Apr 2011 17:36:41 +0200, Roger Quadros  
<roger.quadros@nokia.com> wrote:

> If allocation of multiple buffers would fail then we would leak memory.
> Fix that.
>
> Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
> ---
>  drivers/usb/gadget/f_mass_storage.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/usb/gadget/f_mass_storage.c  
> b/drivers/usb/gadget/f_mass_storage.c
> index f6bd001..60b4df9 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2863,6 +2863,12 @@ buffhds_first_it:
>  		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
>  		if (unlikely(!bh->buf)) {
>  			rc = -ENOMEM;
> +			/* clean up */
> +			while (i < FSG_NUM_BUFFERS) {
> +				bh--;
> +				kfree(bh->buf);
> +				i++;
> +			}
>  			goto error_release;
>  		}
>  	} while (--i);

This is handled in fsg_common_release(), isn't it?  Feel free to
send a patch with a comment explaining that.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
