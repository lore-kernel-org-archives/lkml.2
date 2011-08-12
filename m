Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1HLP4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:56:41 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56802 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1HLP4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:56:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110802050411.GC3857@192.168.0.12>
References: <20110801210905.GC2096@zod.bos.redhat.com>
	<20110802050411.GC3857@192.168.0.12>
Date: Fri, 12 Aug 2011 17:56:38 +0200
Message-ID: <CACTFLAM9sqCAQusGXuA6_JVGZvFKp8pOgb9mbEP_aEzt9b80Uw@mail.gmail.com>
Subject: Re: ums-realtek driver uses stack memory for DMA
From: Daniel Mack <zonque@gmail.com>
To: Adam Cozzette <acozzette@cs.hmc.edu>
Cc: Josh Boyer <jwboyer@redhat.com>, edwin_rong <edwin_rong@realsil.com.cn>,
        wwang <wei_wang@realsil.com.cn>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 2, 2011 at 7:04 AM, Adam Cozzette <acozzette@cs.hmc.edu> wrote:

> drivers/usb/storage/realtek_cr.c:419:40: warning: ‘buf[0]’ may be used uninitialized in this function [-Wuninitialized]
>
> It think they are harmless but I didn't see an obvious way to get rid of them,
> so if you have any suggestions I would be glad to hear them.
>
> This patch changed rts51x_read_mem, rts51x_write_mem, and rts51x_read_status to
> allocate temporary buffers with kmalloc. This way stack addresses are not used
> for DMA when these functions call rts51x_bulk_transport.
>
> Signed-off-by: Adam Cozzette <acozzette@cs.hmc.edu>
> ---
>  realtek_cr.c |   35 ++++++++++++++++++++++++++++++-----
>  1 file changed, 30 insertions(+), 5 deletions(-)

[...]

> @@ -342,6 +351,12 @@ static int rts51x_write_mem(struct us_data *us, u16 addr, u8 *data, u16 len)
>  {
>        int retval;
>        u8 cmnd[12] = { 0 };
> +       u8 *buf;
> +
> +       buf = kmalloc(len, GFP_NOIO);
> +       if (buf == NULL)
> +               return USB_STOR_TRANSPORT_ERROR;
> +       memcpy(buf, data, len);

Your can simplify this with kmemdup().
