Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935Ab1FTK3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:29:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:35014 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab1FTK3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:29:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,392,1304319600"; 
   d="scan'208";a="15851075"
Date: Mon, 20 Jun 2011 12:29:34 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jin Park <jinyoungp@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] aat2870: Adding backlight, regulator and mfd driver
Message-ID: <20110620102934.GE22420@sortiz-mobl>
References: <1306743452-26386-1-git-send-email-jinyoungp@nvidia.com>
 <1306743452-26386-2-git-send-email-jinyoungp@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306743452-26386-2-git-send-email-jinyoungp@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,

On Mon, May 30, 2011 at 05:17:32PM +0900, Jin Park wrote:
> Adding backlight, regulator and mfd driver for AnalogicTech AAT2870.
Before reviewing this patch, could you please do the following:

1) Split it into 3 actual patches: the MFD one, the regulator one and the
backlight one.
2) Add the relevant maintainers (See MAINTAINERS) if you want to get a proper
regulator and backlight driver review.

Now, some MFD specific comments:

> +static int aat2870_read(struct aat2870_data *aat2870, u8 addr, u8 *val)
> +{
> +	struct i2c_client *client = aat2870->client;
> +	int ret = 0;
> +
> +	if (addr >= AAT2870_REG_NUM) {
> +		dev_err(aat2870->dev, "Invalid address, 0x%02x\n", addr);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&aat2870->io_lock);
> +
> +	if (!aat2870->reg_cache[addr].readable) {
> +		*val = aat2870->reg_cache[addr].value;
> +		goto out_unlock;
> +	}
> +
> +	ret = i2c_master_send(client, &addr, 1);
> +	if (ret < 0)
> +		goto out_unlock;
> +	if (ret != 1) {
> +		ret = -EIO;
> +		goto out_unlock;
> +	}
> +
> +	ret = i2c_master_recv(client, val, 1);
> +	if (ret < 0)
> +		goto out_unlock;
> +	if (ret != 1) {
> +		ret = -EIO;
> +		goto out_unlock;
> +	}
> +
> +	ret = 0;
> +
> +out_unlock:
> +	mutex_unlock(&aat2870->io_lock);
> +	dev_dbg(&client->dev, "read: addr=0x%02x, val=0x%02x\n", addr, *val);
> +
> +	return ret;
> +}
> +
> +static int aat2870_write(struct aat2870_data *aat2870, u8 addr, u8 val)
> +{
> +	struct i2c_client *client = aat2870->client;
> +	u8 msg[2];
> +	int ret = 0;
> +
> +	if (addr >= AAT2870_REG_NUM) {
> +		dev_err(aat2870->dev, "Invalid address, 0x%02x\n", addr);
> +		return -EINVAL;
> +	}
> +
> +	if (!aat2870->reg_cache[addr].writeable) {
> +		dev_err(aat2870->dev, "Address 0x%02x is not writeable\n",
> +			addr);
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&aat2870->io_lock);
> +
> +	msg[0] = addr;
> +	msg[1] = val;
> +	ret = i2c_master_send(client, msg, 2);
> +	if (ret < 0)
> +		goto out_unlock;
> +	if (ret != 2) {
> +		ret = -EIO;
> +		goto out_unlock;
> +	}
> +
> +	aat2870->reg_cache[addr].value = val;
> +	ret = 0;
> +
> +out_unlock:
> +	mutex_unlock(&aat2870->io_lock);
> +	dev_dbg(&client->dev, "write: addr=0x%02x, val=0x%02x\n", addr, val);
> +
> +	return ret;
> +}
> +
> +static int aat2870_update_bits(struct aat2870_data *aat2870, u8 addr,
> +			       u8 mask, u8 val)
> +{
> +	int change;
> +	u8 old_val, new_val;
> +	int ret;
> +
> +	ret = aat2870->read(aat2870, addr, &old_val);
> +	if (ret)
> +		return ret;
> +
> +	new_val = (old_val & ~mask) | val;
> +	change = old_val != new_val;
> +	if (change)
> +		ret = aat2870->write(aat2870, addr, new_val);
> +
> +	dev_dbg(&aat2870->client->dev,
> +		"update_bits: change=%d, addr=0x%02x, old=0x%02x, new=0x%02x\n",
> +		change, addr, old_val, new_val);
> +
> +	return ret;
> +}
You also need to take the io_lock mutex here, to prevent someone else to write
a different value to your register between your read and write.
So what you typically want is an unlocked version of aat2870_[read|write]
(let's say we call it __aat2870_[read|write]). Then your aat2870_[read|write]
become wrappers around the __aat2870_[read|write] with the lock taken. And
your update_bits routine can use __aat2870_[read|write] with the lock taken
from the beginning.

The rest looks pretty fine to me.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
