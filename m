Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922Ab1LGRNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:13:32 -0500
Received: from mail.klingt.org ([86.59.21.178]:42512 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab1LGRN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:13:28 -0500
From: Tim Blechmann <tim@klingt.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: Re: [05/27] ALSA: lx6464es - fix device communication via command bus
Date: Wed, 07 Dec 2011 18:13:08 +0100
Message-ID: <1561513.9b6lVaYVip@moka>
User-Agent: KMail/4.7.3 (Linux/3.2.0-rc4+; KDE/4.7.3; x86_64; ; )
In-Reply-To: <20111207165600.831023370@clark.kroah.org>
References: <20111207165600.831023370@clark.kroah.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (klingt.org [86.59.21.178]); Wed, 07 Dec 2011 18:13:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it is not really necessary to apply this patch to 2.6.32, as the problem was 
introduced by a change to the memcpy_*_io functions that was introduced in 
2.6.34.

otoh, it doesn't harm, either.

On Wednesday 07 December 2011 08:54:38 Greg KH wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me
> know.
> 
> ------------------
> 
> From: Tim Blechmann <tim@klingt.org>
> 
> commit a29878553a9a7b4c06f93c7e383527cf014d4ceb upstream.
> 
> commit 6175ddf06b6172046a329e3abfd9c901a43efd2e optimized the mem*io
> functions that have been used to send commands to the device. these
> optimizations somehow corrupted the communication with the lx6464es,
> that resulted the device to be unusable with kernels after 2.6.33.
> 
> this patch emulates the memcpy_*_io functions via a loop to avoid these
> problems.
> 
> Signed-off-by: Tim Blechmann <tim@klingt.org>
> LKML-Reference: <4ECB5257.4040600@ladisch.de>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  sound/pci/lx6464es/lx_core.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> --- a/sound/pci/lx6464es/lx_core.c
> +++ b/sound/pci/lx6464es/lx_core.c
> @@ -80,8 +80,12 @@ unsigned long lx_dsp_reg_read(struct lx6
> 
>  void lx_dsp_reg_readbuf(struct lx6464es *chip, int port, u32 *data, u32
> len) {
> -	void __iomem *address = lx_dsp_register(chip, port);
> -	memcpy_fromio(data, address, len*sizeof(u32));
> +	u32 __iomem *address = lx_dsp_register(chip, port);
> +	int i;
> +
> +	/* we cannot use memcpy_fromio */
> +	for (i = 0; i != len; ++i)
> +		data[i] = ioread32(address + i);
>  }
> 
> 
> @@ -94,8 +98,12 @@ void lx_dsp_reg_write(struct lx6464es *c
>  void lx_dsp_reg_writebuf(struct lx6464es *chip, int port, const u32 *data,
>  			 u32 len)
>  {
> -	void __iomem *address = lx_dsp_register(chip, port);
> -	memcpy_toio(address, data, len*sizeof(u32));
> +	u32 __iomem *address = lx_dsp_register(chip, port);
> +	int i;
> +
> +	/* we cannot use memcpy_to */
> +	for (i = 0; i != len; ++i)
> +		iowrite32(data[i], address + i);
>  }
