Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034Ab0KIKQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:16:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:59760 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab0KIKQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:16:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC 1/8] Introduce dynamic clock devices
Date: Mon, 8 Nov 2010 07:38:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1288897198.git.richard.cochran@omicron.at> <031a33e771a3c8bd95ed2c88ede4820b7675ceca.1288897198.git.richard.cochran@omicron.at>
In-Reply-To: <031a33e771a3c8bd95ed2c88ede4820b7675ceca.1288897198.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011080738.41871.arnd@arndb.de>
X-Provags-ID: V02:K0:mKvYUMnKWpUqovuBu3ii9j42oIJPndyOlb3sj+3n12d
 UKxUCazZJXvWKxtU1lye/tDRUkh+ub9fjLXWqlhGjtM1aLZ8nu
 DAhoJv1Gkd5CVVAPvN3wjpgi4z4qOGNMm3F3cHJ8KAmI5hYzql
 Qee6ymFf4eZmLfCalfUIegkv8nljvnvR8ylPNlM5DGCHMYSXjC
 gxdH7vhd4e4L8584VzAMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 November 2010, Richard Cochran wrote:
> This patch adds support for adding and removing clock devices. The clock
> lifetime cycle is patterned after usb devices. Each clock is represented
> by a standard character device. In addition, the driver may optionally
> implemented custom character device operations.
> 
> The clock devices do not yet do anything useful. This patch merely
> provides some needed infrastructure.
> +/**
> + * create_clock_device() - register a new clock

I'd call this clock_device_create() etc, putting all clock_device functions
in a common namespace with the clock_device_ prefix

> +#define MAX_CLKDEV BITS_PER_LONG
> +static DECLARE_BITMAP(clocks_map, MAX_CLKDEV);
> +static DEFINE_MUTEX(clocks_mux); /* protects 'clocks_map' */

Using "_mux" as a postfix for the name is highly unusual, this normally
means multiplex, not mutual exlusion.

You could probably avoid the need for this mutex altogether if you use
the atomic bit operations (e.g. test_and_set_bit).

> +struct clock_device {
> +	struct file_operations fops;
> +	struct file_operations *driver_fops;
> +	struct clock_device_operations *ops;
> +	struct cdev cdev;
> +	struct kref kref;
> +	struct mutex mux;
> +	void *priv;
> +	int index;
> +	bool zombie;
> +};

You should really not need the file_operations here, neither the
struct nor the pointer. Just define a static file_operations
structure containing clock_device_open and clock_device_release,
and whatever else you might need, then add the driver's operations
to clock_device_operations, and pass the clock_device pointer
directly to them, instead of passing the file/inode pointers.

	Arnd

