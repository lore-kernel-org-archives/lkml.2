Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab0DTXwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:52:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54201 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753827Ab0DTXwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:52:10 -0400
Date: Tue, 20 Apr 2010 16:51:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Zyngier <maz@misterjones.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: max732x: fix input configuration for open-drain
 pins
Message-Id: <20100420165148.49711c3c.akpm@linux-foundation.org>
In-Reply-To: <c2d04a7116b74b3717366148db5f7e54@localhost>
References: <c2d04a7116b74b3717366148db5f7e54@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 16 Mar 2010 10:19:00 +0100

I bet you thought I'd forgotten.

Marc Zyngier <maz@misterjones.org> wrote:

> max732x datasheets indicate that open-drain pins must be
> configured as output-high to be used as input...
> 
> Signed-off-by: Marc Zyngier <maz@misterjones.org>
> ---
>  drivers/gpio/max732x.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpio/max732x.c b/drivers/gpio/max732x.c
> index f786824..3618feb 100644
> --- a/drivers/gpio/max732x.c
> +++ b/drivers/gpio/max732x.c
> @@ -179,15 +179,25 @@ static int max732x_gpio_direction_input(struct gpio_chip *gc, unsigned off)
>  {
>  	struct max732x_chip *chip;
>  	unsigned int mask = 1u << off;
> +	unsigned int is_input;
>  
>  	chip = container_of(gc, struct max732x_chip, gpio_chip);
>  
> -	if ((mask & chip->dir_input) == 0) {
> +	is_input = mask & chip->dir_input;
> +
> +	if (!is_input) {
>  		dev_dbg(&chip->client->dev, "%s port %d is output only\n",
>  			chip->client->name, off);
>  		return -EACCES;
>  	}
>  
> +	/*
> +	 * Open-drain pins must be set to high impedance (which is
> +	 * equivalent to output-high) to be turned into an input.
> +	 */
> +	if ((is_input & chip->dir_output))

You really did mean `&' here, but one very much expects a variable
called is_foo to be a boolean, and booleans want `&&'.

Can you think of a more appropriate name for this guy?  input_lines, maybe?

> +		max732x_gpio_set_value(gc, off, 1);
> +
>  	return 0;
>  }
