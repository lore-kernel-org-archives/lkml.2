Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab0DEN5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 09:57:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50885 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751444Ab0DEN5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 09:57:00 -0400
Date: Mon, 5 Apr 2010 14:56:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, sameo@linux.intel.com,
       lrg@slimlogic.co.uk
Subject: Re: [PATCH 4/4]-V2 Add MFD driver for TPS6507x family of
 multi-function chips and move TPS6507x regulator driver from being
 stand-alone to using the MFD driver.
Message-ID: <20100405135657.GI6580@rakim.wolfsonmicro.main>
References: <1270244253-4234-1-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-2-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-3-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-4-git-send-email-todd.fischer@ridgerun.com>
 <1270244253-4234-5-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270244253-4234-5-git-send-email-todd.fischer@ridgerun.com>
X-Cookie: Pyros of the world... IGNITE !!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 03:37:33PM -0600, Todd Fischer wrote:
> Add MFD driver for TPS6507x family of multi-function chips.  Move TPS6507x 
> regulator driver from being stand-alone driver to using the MFD TPS6507x driver.
> 
> Signed-off-by: Todd Fischer <todd.fischer@ridgerun.com>

One issue...

> +static int tps6507x_i2c_read_device(struct tps6507x_dev *tps6507x, char reg,
> +				  int bytes, void *dest)
> +{
> +	struct i2c_client *i2c = tps6507x->i2c_client;
> +	int ret;
> +
> +	ret = i2c_master_send(i2c, &reg, 1);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = i2c_master_recv(i2c, dest, bytes);
> +	if (ret < 0)
> +		return ret;
> +	if (ret != bytes)
> +		return -EIO;
> +	return 0;
> +}

Your register I/O functions don't have anything protecting them against
concurrent access.  This isn't really an issue for the writes by
themselves since they do a single transaction on the I2C bus so the I2C
layer concurrency protection ought to be enough but for reads you need
to send the register address first then read back the data, opening up
an issue.  A simple mutex in the read and write functions ought to cover
this.
