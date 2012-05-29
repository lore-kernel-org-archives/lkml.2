Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717Ab2E2NpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 09:45:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54798 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752370Ab2E2NpG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 09:45:06 -0400
Message-ID: <1338299104.2202.34.camel@joe2Laptop>
Subject: Re: [PATCH V3] [staging] bcm: Replace the BCM_DEBUG_* and
 BCM_SHOW_* macros with functions
From: Joe Perches <joe@perches.com>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kevin McKinney <klmckinney1@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 29 May 2012 06:45:04 -0700
In-Reply-To: <1338289626-9021-1-git-send-email-devendra.aaru@gmail.com>
References: <1338289626-9021-1-git-send-email-devendra.aaru@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-29 at 16:37 +0530, Devendra Naga wrote:
[]
> diff --git a/drivers/staging/bcm/Debug.c b/drivers/staging/bcm/Debug.c
[]
> +void bcm_debug_print(PMINI_ADAPTER Adapter, int Type, int SubType,
> +			int dbg_level, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +	UINT debug_level = Adapter->stDebugState.debug_level;
> +
> +	va_start(args, fmt);
> +
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	if (DBG_TYPE_PRINTK == Type)
> +		pr_info("%s: %pV", __func__, &vaf);

func

> +	else if (Adapter &&
> +		(dbg_level & DBG_LVL_BITMASK) <= debug_level &&
> +		(Type & Adapter->stDebugState.type) &&
> +		(SubType & Adapter->stDebugState.subtype[Type])) {
> +		if (dbg_level & DBG_NO_FUNC_PRINT)
> +			printk(KERN_DEBUG "%pV" , &vaf);
> +		else
> +			printk(KERN_DEBUG "%s: %pV", __func__, &vaf);

func

> +	}
> +
> +	va_end(args);
> +}
> +
> +void bcm_debug_print_buffer(PMINI_ADAPTER Adapter, int Type, int SubType,
> +			    int dbg_level, const void *buffer, size_t bufferlen)
> +{
> +	if (DBG_TYPE_PRINTK == Type ||
> +	   (Adapter &&
> +	   (dbg_level & DBG_LVL_BITMASK) <= Adapter->stDebugState.debug_level &&
> +	   (Type & Adapter->stDebugState.type) &&
> +	   (SubType & Adapter->stDebugState.subtype[Type]))) {
> +		printk(KERN_DEBUG "%s:\n", __func__);

func

> +		print_hex_dump(KERN_DEBUG, " ", DUMP_PREFIX_OFFSET,
> +			       16, 1, buffer, bufferlen, false);
> +	}
> +}

[]

> diff --git a/drivers/staging/bcm/Debug.h b/drivers/staging/bcm/Debug.h
[]
> +struct _MINI_ADAPTER;
> +
> +__printf(5, 6)
> +
> +void bcm_debug_print(struct _MINI_ADAPTER *Adapter, int Type, int SubType,
> +			int dbg_level, const char *fmt, ...);

No blank line between __printf and prototype

> +void bcm_debug_print_buffer(struct _MINI_ADAPTER *Adapter, int Type, int SubType,
> +			int dbg_level, const void *buffer, size_t bufferlen);
> +void bcm_show_debug_bitmap(struct _MINI_ADAPTER *Adapter);
> +
> +#define BCM_DEBUG_PRINT(Adapter, Type, SubType, dbg_level, fmt, ...)	\
> +	bcm_debug_print(Adapter, Type, SubType, dbg_level, fmt, ##__VA_ARGS__)
> +
> +#define BCM_DEBUG_PRINT_BUFFER(Adapter, Type, SubType, dbg_level,	\
> +				buffer, bufferlen)			\
> +	bcm_debug_print_buffer(Adapter, Type, SubType, dbg_level,	\
> +				buffer, bufferlen)
> +#define BCM_SHOW_DEBUG_BITMAP(Adapter)					\
> +	bcm_show_debug_bitmap(Adapter)

Turns out to keep the same behavior, you need to add
a const char *func argument to these functions and
change the macros to pass __func__.
 


