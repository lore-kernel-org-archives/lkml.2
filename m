Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab0ELClh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 22:41:37 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47302 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab0ELCle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 22:41:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vEKIYmB3uowYmk/gs6uxUMRJTqVnTNpSDM1FID40qyJVfyLAEOwX05nwns1AQ0ImGk
         sIXdag/7DbSn4JRk+gPCbDz0GDmL/okOGOpOj5cfuhlMvZMCohetDHPQkXJWnpOM8pW7
         yS+xtZccRvhA/GRQ5o4QmowzwFCmt3EOqtgIM=
Message-ID: <4BEA1559.9000107@gmail.com>
Date: Tue, 11 May 2010 20:41:29 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: saeed bishara <saeed.bishara@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>,
       DE/ATA development list <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [BUG] bug when enabling VM DEBUG
References: <AANLkTikkSRI6u_mp6mNQReECB84t3oh-_MPVzAYEQULN@mail.gmail.com> <AANLkTikoNc6oAY5JthYX1jWx1w2KeJ1fGab72Z-OvIVG@mail.gmail.com>
In-Reply-To: <AANLkTikoNc6oAY5JthYX1jWx1w2KeJ1fGab72Z-OvIVG@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2010 09:27 AM, saeed bishara wrote:
> Jeff,
> seems that the libata do pio to buffer which was allocated with
> kmalloc, and under arm arch, the flush_dcache_page() is needed to
> prevent cache aliasing, the later function calls the page_mapping
> which falls on PageSlab(page)
>
> as the flush_dcache_page() is needed to prevent aliasing, it can be
> skipped if the page is Slab as such pages are used only by the kernel.
> here a suggested patch:
>
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -894,7 +894,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
>                                         do_write);
>          }
>
> -       if (!do_write)
> +       if (!do_write&&  !PageSlab(page))
>                  flush_dcache_page(page);
>
> saeed

I would think that check belongs inside flush_dcache_page itself, rather 
than forcing every driver to include it..
