Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab1KFV55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:57:57 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:35139 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1KFV54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:57:56 -0500
X-Greylist: delayed 480 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Nov 2011 16:57:56 EST
Message-ID: <4EB70100.8030703@kernel.org>
Date: Sun, 06 Nov 2011 21:49:52 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111001 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] [staging] iio, adc: Do not leak memory in ad7280_event_handler()
References: <alpine.LNX.2.00.1111062246580.5763@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1111062246580.5763@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2011 09:49 PM, Jesper Juhl wrote:
> If ad7280_read_all_channels() returns <0 then we'll leak the memory
> allocated to 'channels' when we return and that variable goes out of
> scope.
> This patch fixes the leak.
> 
Looks right to me - good spot. Only choice is whether a single exit
point makes sense rather than undwinding it here? Michael?
I'm happy with either solution, hence the ack.

> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> ---
>  drivers/staging/iio/adc/ad7280a.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
>  note: I don't have the hardware, so patch is compile tested only.
> 
> diff --git a/drivers/staging/iio/adc/ad7280a.c b/drivers/staging/iio/adc/ad7280a.c
> index 372d059..dddc03c 100644
> --- a/drivers/staging/iio/adc/ad7280a.c
> +++ b/drivers/staging/iio/adc/ad7280a.c
> @@ -687,8 +687,10 @@ static irqreturn_t ad7280_event_handler(int irq, void *private)
>  		return IRQ_HANDLED;
>  
>  	ret = ad7280_read_all_channels(st, st->scan_cnt, channels);
> -	if (ret < 0)
> +	if (ret < 0) {
> +		kfree(channels);
>  		return IRQ_HANDLED;
> +	}
>  
>  	for (i = 0; i < st->scan_cnt; i++) {
>  		if (((channels[i] >> 23) & 0xF) <= AD7280A_CELL_VOLTAGE_6) {

