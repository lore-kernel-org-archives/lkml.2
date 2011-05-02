Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab1EBJ1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 05:27:44 -0400
Received: from trinity.fluff.org ([89.16.178.74]:60291 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816Ab1EBJ1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 05:27:43 -0400
Date: Mon, 2 May 2011 10:27:34 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: eric.y.miao@gmail.com, khali@linux-fr.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 1/3] i2c: append hardware lock with bus lock
Message-ID: <20110502092734.GV15795@trinity.fluff.org>
References: <1304003746-12127-1-git-send-email-haojian.zhuang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304003746-12127-1-git-send-email-haojian.zhuang@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 11:15:44PM +0800, Haojian Zhuang wrote:
> Both AP and CP are contained in Marvell PXA910 silicon. These two ARM
> cores are sharing one pair of I2C pins.
> 
> In order to keep I2C transaction operated with atomic, hardware lock
> (RIPC) is required. Because of this, bus lock in AP side can't afford
> this requirement. Now hardware lock is appended.
> 
> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
> Cc: Ben Dooks <ben-linux@fluff.org>
> Cc: Jean Delvare <khali@linux-fr.org>

Right, this looks like a reasonable explanation of what is going on here
and if Jean is happy with the core changes I'll look at where the driver
change can go.

> ---
>  drivers/i2c/i2c-core.c |   22 ++++++++++++++++++----
>  include/linux/i2c.h    |    3 +++
>  2 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
> index 045ba6e..132d46c 100644
> --- a/drivers/i2c/i2c-core.c
> +++ b/drivers/i2c/i2c-core.c
> @@ -448,8 +448,11 @@ void i2c_lock_adapter(struct i2c_adapter *adapter)
>  
>  	if (parent)
>  		i2c_lock_adapter(parent);
> -	else
> +	else {
>  		rt_mutex_lock(&adapter->bus_lock);
> +		if (adapter->hardware_lock)
> +			adapter->hardware_lock(adapter);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(i2c_lock_adapter);
>  
> @@ -460,11 +463,19 @@ EXPORT_SYMBOL_GPL(i2c_lock_adapter);
>  static int i2c_trylock_adapter(struct i2c_adapter *adapter)
>  {
>  	struct i2c_adapter *parent = i2c_parent_is_i2c_adapter(adapter);
> +	int ret = 0;
>  
>  	if (parent)
>  		return i2c_trylock_adapter(parent);
> -	else
> -		return rt_mutex_trylock(&adapter->bus_lock);
> +	else {
> +		ret = rt_mutex_trylock(&adapter->bus_lock);
> +		if (ret && adapter->hardware_trylock) {
> +			ret = adapter->hardware_trylock(adapter);
> +			if (!ret)
> +				i2c_unlock_adapter(adapter);
> +		}
> +		return ret;
> +	}
>  }
>  
>  /**
> @@ -477,8 +488,11 @@ void i2c_unlock_adapter(struct i2c_adapter *adapter)
>  
>  	if (parent)
>  		i2c_unlock_adapter(parent);
> -	else
> +	else {
> +		if (adapter->hardware_unlock)
> +			adapter->hardware_unlock(adapter);
>  		rt_mutex_unlock(&adapter->bus_lock);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(i2c_unlock_adapter);
>  
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 06a8d9c..f4ef5b0 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -361,6 +361,9 @@ struct i2c_adapter {
>  
>  	/* data fields that are valid for all devices	*/
>  	struct rt_mutex bus_lock;
> +	void (*hardware_lock)(struct i2c_adapter *);
> +	void (*hardware_unlock)(struct i2c_adapter *);
> +	int (*hardware_trylock)(struct i2c_adapter *);
>  
>  	int timeout;			/* in jiffies */
>  	int retries;
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

