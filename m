Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1LAMrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:47:03 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52771 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1LAMrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:47:00 -0500
Date: Thu, 1 Dec 2011 21:47:41 +0900
From: Gustavo Padovan <padovan@profusion.mobi>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org
Subject: Re: [Patch] btusb: fix a memory leak in btusb_send_frame()
Message-ID: <20111201124741.GC2894@joana>
Mail-Followup-To: Cong Wang <amwang@redhat.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org
References: <1321925578-5407-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321925578-5407-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cong,

* Cong Wang <amwang@redhat.com> [2011-11-22 09:32:57 +0800]:

> This patch fixes the following memory leak reported by kmemleak:
> 
> unreferenced object 0xffff880060a53840 (size 192):
>   comm "softirq", pid 0, jiffies 4320571771 (age 1406.569s)
>   hex dump (first 32 bytes):
>     01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff81138a1c>] create_object+0x187/0x28b
>     [<ffffffff814be12e>] kmemleak_alloc+0x73/0x98
>     [<ffffffff811289d3>] __kmalloc+0xfc/0x123
>     [<ffffffff81386546>] usb_alloc_urb+0x1e/0x48
>     [<ffffffffa0130274>] btusb_send_frame+0x86/0x385 [btusb]
>     [<ffffffffa02d8230>] hci_send_frame+0xa0/0xa5 [bluetooth]
>     [<ffffffffa02d8a4e>] hci_cmd_task+0xa0/0xfb [bluetooth]
>     [<ffffffff81058548>] tasklet_action+0x8f/0xef
>     [<ffffffff81058a4c>] __do_softirq+0xf4/0x1db
>     [<ffffffff81058bb7>] run_ksoftirqd+0x84/0x129
>     [<ffffffff8106f1c4>] kthread+0xa0/0xa8
>     [<ffffffff814dd144>] kernel_thread_helper+0x4/0x10
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> The problem is that when inc_tx() returns non-zero, we forgot
> to call usb_free_urb().
> 
> Cc: Marcel Holtmann <marcel@holtmann.org>
> Cc: "Gustavo F. Padovan" <padovan@profusion.mobi>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> 
> ---
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index fe4ebc3..eabc437 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -777,9 +777,8 @@ skip_waking:
>  		usb_mark_last_busy(data->udev);
>  	}
>  
> -	usb_free_urb(urb);
> -
>  done:
> +	usb_free_urb(urb);
>  	return err;
>  }

Patch has been applied, thanks.

	Gustavo
