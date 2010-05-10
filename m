Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab0EJVts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 17:49:48 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:33957 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab0EJVtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 17:49:46 -0400
Date: Mon, 10 May 2010 14:49:46 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Steven Liu <lingjiujianke@gmail.com>,
       Nigel Cunningham <nigel@tuxonice.net>
Cc: Linus WALLEIJ <linus.walleij@stericsson.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Check kmalloc return value before use the buffer
Message-ID: <20100510214946.GA4361@hexapodia.org>
References: <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local> <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com> <4BE3DF5A.9070601@tuxonice.net> <v2gbd0d95d71005070247j1f615a65mcbd52b5b6474206e@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A025A68D366@EXDCVYMBSTM006.EQ1STM.local> <4BE4BDED.5050406@tuxonice.net> <v2ubd0d95d71005061941j4f9272d1he7dc9bcf5daa6457@mail.gmail.com> <CEE6BB42CAD6E947908279175AF8470A025A68CE5C@EXDCVYMBSTM006.EQ1STM.local> <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BE4BDED.5050406@tuxonice.net> <z2mbd0d95d71005070017w7aa97001m2b81be6dbc1021b9@mail.gmail.com>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 07, 2010 at 03:17:39PM +0800, Steven Liu wrote:
>  	bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
> +	if (bigrxbuf_virtual == NULL) {
> +		status = -ENOMEM;
> +		kfree(bigtxbuf_virtual);
> +		goto out;
> +	}

On Sat, May 08, 2010 at 11:27:09AM +1000, Nigel Cunningham wrote:
>> Acked-by: Linus Walleij<linus.walleij@stericsson.com>
>
> Acked-by: Nigel Cunningham <nigel@tuxonice.net>

NACK.  Don't duplicate kfree(), instead do something like

--- a/arch/arm/mach-u300/dummyspichip.c
+++ b/arch/arm/mach-u300/dummyspichip.c
@@ -58,12 +58,13 @@ static ssize_t dummy_looptest(struct device *dev,
        if (mutex_lock_interruptible(&p_dummy->lock))
                return -ERESTARTSYS;
 
+       status = -ENOMEM;
        bigtxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
-       if (bigtxbuf_virtual == NULL) {
-               status = -ENOMEM;
+       if (bigtxbuf_virtual == NULL)
                goto out;
-       }
        bigrxbuf_virtual = kmalloc(DMA_TEST_SIZE, GFP_KERNEL);
+       if (bigrxbuf_virtual == NULL)
+               goto out_free_tx;
 
        /* Fill TXBUF with some happy pattern */
        memset(bigtxbuf_virtual, 0xAA, DMA_TEST_SIZE);
@@ -215,6 +216,7 @@ static ssize_t dummy_looptest(struct device *dev,
 
        status = sprintf(buf, "loop test complete\n");
        kfree(bigrxbuf_virtual);
+ out_free_tx:
        kfree(bigtxbuf_virtual);
  out:
        mutex_unlock(&p_dummy->lock);

-andy
