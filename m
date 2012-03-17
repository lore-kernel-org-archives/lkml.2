Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030823Ab2CQQoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 12:44:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52936 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab2CQQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 12:44:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mircea Gherzan <mgherzan@gmail.com>
Subject: Re: [PATCH] wl12xx: fix DMA-API-related warnings
Date: Sat, 17 Mar 2012 16:44:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1332001592-17074-1-git-send-email-mgherzan@gmail.com>
In-Reply-To: <1332001592-17074-1-git-send-email-mgherzan@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203171644.14573.arnd@arndb.de>
X-Provags-ID: V02:K0:wIEHwmBkGsHQQGkTlEEY0lLmlJwpUAdTatGSQhrkJrW
 F20wdG5ifscfhgW5lib5FokOux+YH4eGbDnhAoeloeXsphms7k
 6PPUezsRr10nsPtMbsmObsDcrd9tG5hGfYlu5KY0y8tPEzwsR4
 /LnKGIPi0cZgHPFqQrwiuQJZX/ietx4sGTEz7lQU5GKTAA3EBF
 p0aC2XNGlJrdsFSayH1Cd5RmHdS4YhTBC9JurDuoMgI3TbzNT8
 Q4Dkm7KyIPMtAwrq0WkmuQADUM5SK8RMyKBgKh5lbISKZaZPol
 6+uicSYi0/IRKom+sEdzB63f0SaFK0ubAqOgEet718HIF5mgpA
 vS4uYi+U/UvQjOthWWf4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 17 March 2012, Mircea Gherzan wrote:
>  int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
>  {
> -       struct event_mailbox mbox;
> -       int ret;
> +       struct event_mailbox *mbox;
> +       int ret = 0;
>  
>         wl1271_debug(DEBUG_EVENT, "EVENT on mbox %d", mbox_num);
>  
>         if (mbox_num > 1)
>                 return -EINVAL;
>  
> +       /* no GFP_ATOMIC: we're called from the threaded IRQ handler */
> +       mbox = kmalloc(sizeof(*mbox), GFP_DMA);
> +
>         /* first we read the mbox descriptor */
> -       wl1271_read(wl, wl->mbox_ptr[mbox_num], &mbox,
> -                   sizeof(struct event_mailbox), false);
> +       wl1271_read(wl, wl->mbox_ptr[mbox_num], mbox, sizeof(*mbox), false);
>  
>         /* process the descriptor */
> -       ret = wl1271_event_process(wl, &mbox);
> +       ret = wl1271_event_process(wl, mbox);
>         if (ret < 0)
> -               return ret;
> +               goto out;
>  
>         /* then we let the firmware know it can go on...*/
>         wl1271_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
>  
> -       return 0;
> +out:
> +       kfree(mbox);
> +       return ret;
>  }

I think it would be better here to put another field into struct wl1271 to hold
the mailbox. There is no point allocating and freeing the field every time
you get into the interrupt handler.

	Arnd
