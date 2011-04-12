Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294Ab1DLRqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:46:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab1DLRqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:46:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: mathieu.poirier@linaro.org
Subject: Re: [PATCH 1/2] ux500: Adding support for u8500 Hsem functionality V2
Date: Tue, 12 Apr 2011 19:46:01 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ohad@wizery.com, lee.jones@linaro.org, patches@linaro.org,
        linus.walleij@stericsson.com
References: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org>
In-Reply-To: <1302535464-12294-1-git-send-email-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201104121946.01618.arnd@arndb.de>
X-Provags-ID: V02:K0:7DcloAekmSQ5zwTYmCdzwH3UfPA9gsvBNAPZk6hUceH
 rlRF5zhzdAzChyz0HsjTxTUzB8ByYgCD3VciCzSrBdh9SUneGP
 TN8MsRkRjQtuNr4RBJx31KE7IULO/qSQdv/1pzpT15RCbBVPtT
 WCDyYzGjSYgJT3QVoQwEEZU8SDgSkz1Vxu2WBafDeCJgSk8DS9
 6LMm9akLLO1VSBl9OUv7w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 April 2011, mathieu.poirier@linaro.org wrote:
> From: Mathieu J. Poirier <mathieu.poirier@linaro.org>
> 
> This is the second spin on STE's Hsem driver that is implemented
> through the hwspinlock scheme.  More specifically:
> 
>  More comments have been added in the code.
>  Cleanup of included header files.
>  One of the original contributor's name corrected.
>  Calls to 'pm_runtime_disable'restored.
> 
> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

Looks very nice overall, just a few small details I noticed:

> +
> +#define HSEM_REGISTER_OFFSET		0x08
> +
> +#define HSEM_CTRL_REG			0x00
> +#define HSEM_ICRALL			0x90
> +#define HSEM_PROTOCOL_1			0x01
> +
> +#define to_u8500_hsem(lock)	\
> +	container_of(lock, struct u8500_hsem, lock)
> +
> +struct u8500_hsem {
> +	struct hwspinlock lock;
> +	void __iomem *addr;
> +};

It seems inconsistent to name it sem instead of spinlock.

> +struct u8500_hsem_state {
> +	void __iomem *io_base;		/* Mapped base address */
> +};

If you make that one data structure, you only need a single allocation:

struct u8500_hsem_state {
	void __iomem *io_base;
	struct u8500_hsem hsem[U8500_MAX_SEMAPHORE];
}

> +
> +	for (i = 0; i < U8500_MAX_SEMAPHORE; i++) {
> +		u8500_lock = kzalloc(sizeof(*u8500_lock), GFP_KERNEL);
> +		if (!u8500_lock) {
> +			ret = -ENOMEM;
> +			goto free_locks;
> +		}
> +
> +		u8500_lock->lock.dev = &pdev->dev;
> +		u8500_lock->lock.owner = THIS_MODULE;
> +		u8500_lock->lock.id = i;
> +		u8500_lock->lock.ops = &u8500_hwspinlock_ops;
> +		u8500_lock->addr = io_base + offset + sizeof(u32) * i;
> +
> +		ret = hwspin_lock_register(&u8500_lock->lock);
> +		if (ret) {
> +			kfree(u8500_lock);
> +			goto free_locks;
> +		}
> +	}

When you do that, this can be a single allocation.

Thinking about it some more, it may actually be worthwhile to still improve
the API here: I think the owner field should be part of the operations structure,
because it is constant. It would also be nice to have a "private" pointer
in struct hwspinlock, so you don't need to wrap it if you don't want to.

Finally, the hwspin_lock_register could take the specific values as arguments
instead of requiring you to fill it out first.

	Arnd
