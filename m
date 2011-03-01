Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab1CATjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:39:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57981 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab1CATjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:39:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VcSZRHB5gXKsOo8b+MXrn7i93xoWGOE80jJXm45H54Mo6ebHuaTr1+EgmomUJFDsHG
         z0y5QwNn+gMOaPzFKCJQy/tVCPRwet6LrlFgCP6hNhGlVVcwiRhD2eRO6gpa2xlAq++5
         CJcyCVYTc2esxAO07ogRluzgBrWSA62H8S+x8=
Date: Tue, 1 Mar 2011 22:39:09 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: rklein@nvidia.com
Cc: olof@lixom.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] power: bq20z75: add support for POWER_NOW
Message-ID: <20110301193909.GB5649@oksana.dev.rtsoft.ru>
References: <1298940931-17552-1-git-send-email-rklein@nvidia.com>
 <1298940931-17552-4-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1298940931-17552-4-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 04:55:30PM -0800, rklein@nvidia.com wrote:
[...]
> +static int bq20z75_get_power_now(struct i2c_client *client,
> +	union power_supply_propval *val)
> +{
> +	int voltage_now = 0;
> +	int current_now = 0;
> +
> +	voltage_now = bq20z75_read_word_data(client,
> +		bq20z75_data[REG_VOLTAGE].addr);
> +	if (voltage_now < 0)
> +		return voltage_now;
> +
> +	current_now = bq20z75_read_word_data(client,
> +		bq20z75_data[REG_CURRENT].addr);
> +	if (current_now < 0)
> +		return current_now;
> +
> +	/* returned values are 16 bit */
> +	current_now = (s16)current_now;
> +	/* need to ensure it is positive */
> +	current_now = abs(current_now);
> +
> +	val->intval = voltage_now * current_now;

Nope, we don't do this in the drivers. It's a derived property, and
driver should not bother with these.

Documentation/power/power_supply_class.txt says:
- - - -
Q: Suppose, my battery monitoring chip/firmware does not provides capacity
   in percents, but provides charge_{now,full,empty}. Should I calculate
   percentage capacity manually, inside the driver, and register CAPACITY
   attribute? The same question about time_to_empty/time_to_full.
A: Most likely, no. This class is designed to export properties which are
   directly measurable by the specific hardware available.

   Inferring not available properties using some heuristics or mathematical
   model is not subject of work for a battery driver. Such functionality
   should be factored out, and in fact, apm_power, the driver to serve
   legacy APM API on top of power supply class, uses a simple heuristic of
   approximating remaining battery capacity based on its charge, current,
   voltage and so on. But full-fledged battery model is likely not subject
   for kernel at all, as it would require floating point calculation to deal
   with things like differential equations and Kalman filters. This is
   better be handled by batteryd/libbattery, yet to be written.
- - - -

There were some ideas to write a kernel module that would provide
such "derived" properties for all the drivers. But drivers themselves
should not duplicate the generic logic.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
