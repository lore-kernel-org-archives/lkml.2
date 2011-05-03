Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1ECOoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:44:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51536 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752853Ab1ECOon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:44:43 -0400
Date: Tue, 3 May 2011 15:44:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Subject: Re: [PATCHv2 -next] MFD: MFD module of DA9052 PMIC driver
Message-ID: <20110503144441.GS1762@opensource.wolfsonmicro.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5AFBA@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5AFBA@KCINPUNHJCMS01.kpit.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 07:30:54PM +0530, Ashish Jangam wrote:

> +int da9052_unmask_events(struct da9052 *da9052, unsigned int events)
> +{
> +       uint8_t v[4];
> +
> +       da9052->events_mask &= ~events;
> +
> +       v[0] = (da9052->events_mask & 0xff);
> +       v[1] = (da9052->events_mask >> 8) & 0xff;
> +       v[2] = (da9052->events_mask >> 16) & 0xff;
> +       v[3] = (da9052->events_mask >> 24) & 0xff;
> +
> +       return da9052_group_write(da9052, DA9052_IRQ_MASK_A_REG, 4, v);
> +}
> +
> +int da9052_mask_events(struct da9052 *da9052, unsigned int events)
> +{
> +       uint8_t v[4];
> +
> +       da9052->events_mask |= events;
> +
> +       v[0] = (da9052->events_mask & 0xff);
> +       v[1] = (da9052->events_mask >> 8) & 0xff;
> +       v[2] = (da9052->events_mask >> 16) & 0xff;
> +       v[3] = (da9052->events_mask >> 24) & 0xff;
> +
> +       return da9052_group_write(da9052, DA9052_IRQ_MASK_A_REG, 4, v);
> +}

My previous queries about why this is here and not in the IRQ code still
stand.

> +static void da9052_irq_sync_unlock(struct irq_data *data)
> +{
> +       struct da9052 *da9052 = irq_data_get_irq_chip_data(data);
> +       struct da9052_irq_data *irq_data = irq_to_da9052_irq(da9052,
> +                                               data->irq);
> +
> +       da9052_mask_events(da9052, irq_data->event);
> +       mutex_unlock(&da9052->irq_lock);

What happens if an event was enabled while the bus was locked?
