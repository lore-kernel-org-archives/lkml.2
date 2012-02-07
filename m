Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab2BGWHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 17:07:54 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:26931 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab2BGWHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 17:07:53 -0500
Date: Tue, 7 Feb 2012 23:07:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: guenter roeck <guenter.roeck@ericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Peter Tyser <ptyser@xes-inc.com>
Subject: Re: [PATCH 2/3 v2] gpio: Add support for Intel ICHx/3100/Series[56]
 GPIO
Message-ID: <20120207230741.17220c09@endymion.delvare>
In-Reply-To: <c4c7d7dc-5e9f-45c2-9aa6-f13c20e9a4e6@zimbra>
References: <1328300388.2261.211.camel@groeck-laptop>
	<c4c7d7dc-5e9f-45c2-9aa6-f13c20e9a4e6@zimbra>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Feb 2012 13:58:31 -0600 (CST), Aaron Sierra wrote:
> This driver works on many Intel chipsets, including the ICH6, ICH7,
> ICH8, ICH9, ICH10, 3100, Series 5/3400 (Ibex Peak), Series 6/C200
> (Cougar Point), and NM10 (Tiger Point).
> 
> Additional Intel chipsets should be easily supported if needed, eg the
> ICH1-5, EP80579, etc.
> 
> Tested on QM67 (Cougar Point), QM57 (Ibex Peak), 3100 (Whitmore Lake),
> and NM10 (Tiger Point).
> (...)
> +static int ichx_write_bit(int reg, unsigned nr, int val, int verify)
> +{
> +	unsigned long flags;
> +	u32 data, tmp;
> +	int reg_nr = nr / 32;
> +	int bit = nr & 0x1f;
> +	int ret = 0;
> +
> +	spin_lock_irqsave(&ichx_priv.lock, flags);
> +
> +	data = ICHX_READ(ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
> +	data = (data & ~(1 << bit)) | (val << bit);

I posted a fix for this function last Sunday:

Subject: [PATCH] gpio-ich: Fix setting GPIO value
Date: Sun, 5 Feb 2012 21:44:44 +0100

Please apply it, otherwise your driver doesn't implement the gpio
driver API properly and code running on top of it (consumer drivers)
may fail.

> +	ICHX_WRITE(data, ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
> +	tmp = ICHX_READ(ichx_regs[reg][reg_nr], ichx_priv.gpio_base);
> +	if (verify && (data != tmp))
> +		ret = -EPERM;
> +
> +	spin_unlock_irqrestore(&ichx_priv.lock, flags);
> +
> +	return ret;
> +}

-- 
Jean Delvare
