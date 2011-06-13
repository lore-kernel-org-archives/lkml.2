Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab1FMSLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:11:34 -0400
Received: from mail.perches.com ([173.55.12.10]:2846 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754048Ab1FMSLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:11:32 -0400
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 11:11:30 -0700
Message-ID: <1307988690.26699.9.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 18:58 +0200, Linus Walleij wrote:
> This creates a subsystem for handling of pinmux devices. These are
> devices that enable and disable groups of pins on primarily PGA and
> BGA type of chip packages and common in embedded systems.

Trivia only:

> diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
[]
> +int pin_is_valid(int pin)
> +{
> +	return pin >= 0 && pin < num_pins;
> +}
> +EXPORT_SYMBOL_GPL(pin_is_valid);

bool pin_is_valid?

> +/* Deletes a range of pin descriptors */
> +static void pinctrl_free_pindescs(struct pinctrl_pin_desc const *pins,
> +				  unsigned num_pins)

const struct pinctrl_pin_desc *pins

> +{
> +	int i;
> +
> +	for (i = 0; i < num_pins; i++) {
> +		struct pin_desc *pindesc;
> +
> +		spin_lock(&pin_desc_tree_lock);
> +		pindesc = radix_tree_lookup(&pin_desc_tree, pins[i].number);
> +		if (pindesc != NULL) {
> +			radix_tree_delete(&pin_desc_tree, pins[i].number);
> +			num_pins --;

No space please

> +		}
> +		spin_unlock(&pin_desc_tree_lock);
> +		kfree(pindesc);
> +	}
> +}

Is it really worthwhile to have spin_lock/unlock in the loop?

> +static int pinctrl_register_one_pin(unsigned number, const char *name)
> +{
> +	/* Copy optional basic pin info */
> +	if (name) {
> +		strncpy(pindesc->name, name, 16);

strlcpy

> +		pindesc->name[15] = '\0';
> +	}
> +
> +	spin_lock(&pin_desc_tree_lock);
> +	radix_tree_insert(&pin_desc_tree, number, pindesc);
> +	num_pins ++;

No space please

> +	spin_unlock(&pin_desc_tree_lock);
> +	return 0;
> +}
> +
> +/* Passing in 0 num_pins means "sparse" */
> +static int pinctrl_register_pins(struct pinctrl_pin_desc const *pins,
> +				 unsigned num_descs, unsigned num_pins)
[]
> +	 * If we are registerering dense pinlists, fill in all holes with

registering

> +	 * anonymous pins.
> +	 */
> +	for (i = 0; i < num_pins; i++) {
> +		char pinname[16];
> +		struct pin_desc *pindesc;
> +
> +		spin_lock(&pin_desc_tree_lock);
> +		pindesc = radix_tree_lookup(&pin_desc_tree, i);
> +		spin_unlock(&pin_desc_tree_lock);
> +		/* Already registered this one, take next */
> +		if (pindesc)
> +			continue;
> +
> +		snprintf(pinname, 15, "anonymous %u", i);
> +		pinname[15] = '\0';

strlcpy

> +int pinctrl_register_pins_dense(struct pinctrl_pin_desc const *pins,
> +				 unsigned num_descs, unsigned num_pins)
> +{
> +	int ret;
> +	unsigned i;
> +
> +	ret = pinctrl_register_pins(pins, num_descs, num_pins);
> +	if (ret) {
> +		for (i = 0; i < num_pins; i++) {
> +			struct pin_desc *pindesc;
> +
> +			spin_lock(&pin_desc_tree_lock);
> +			pindesc = radix_tree_lookup(&pin_desc_tree, i);
> +			if (pindesc != NULL) {
> +				radix_tree_delete(&pin_desc_tree, i);
> +				num_pins --;
> +			}
> +			spin_unlock(&pin_desc_tree_lock);
> +			kfree(pindesc);
> +		}

Second use of this pattern.  Maybe use pinctrl_free_pindescs?


