Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab1FNJTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 05:19:16 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57791 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab1FNJTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 05:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <1307988690.26699.9.camel@Joe-Laptop>
References: <1307984291-9774-1-git-send-email-linus.walleij@stericsson.com>
	<1307988690.26699.9.camel@Joe-Laptop>
Date: Tue, 14 Jun 2011 11:19:14 +0200
Message-ID: <BANLkTi=YQcQ2C=RhMrB_CpWXN7ba9SxfEg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pinmux subsystem v3
From: Linus Walleij <linus.walleij@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Stephen Warren <swarren@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

thanks for the review, excellent as always.

I fixed all except the below pattern, also searched the source to make sure
there were no other cases of the same errors.

On Mon, Jun 13, 2011 at 8:11 PM, Joe Perches <joe@perches.com> wrote:

>> +int pinctrl_register_pins_dense(struct pinctrl_pin_desc const *pins,
>> +                              unsigned num_descs, unsigned num_pins)
>> +{
>> +     int ret;
>> +     unsigned i;
>> +
>> +     ret = pinctrl_register_pins(pins, num_descs, num_pins);
>> +     if (ret) {
>> +             for (i = 0; i < num_pins; i++) {
>> +                     struct pin_desc *pindesc;
>> +
>> +                     spin_lock(&pin_desc_tree_lock);
>> +                     pindesc = radix_tree_lookup(&pin_desc_tree, i);
>> +                     if (pindesc != NULL) {
>> +                             radix_tree_delete(&pin_desc_tree, i);
>> +                             num_pins --;
>> +                     }
>> +                     spin_unlock(&pin_desc_tree_lock);
>> +                     kfree(pindesc);
>> +             }
>
> Second use of this pattern.  Maybe use pinctrl_free_pindescs?

It is quite different actually - in the second case here. we loop over a list
with holes, and we pick each one pin. We cannot loop over the entire
pin range because in this case we don't know the size of the range.

Thanks,
Linus Walleij
