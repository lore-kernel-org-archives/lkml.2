Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0JEFO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 01:14:59 -0400
Received: from ozlabs.org ([203.10.76.45]:33608 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab0JEFO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 01:14:58 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
Date: Tue, 5 Oct 2010 15:44:51 +1030
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6> <201010041300.15234.arnd@arndb.de> <alpine.LFD.2.00.1010050026170.2556@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010050026170.2556@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010051544.52269.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010 09:13:38 am Thomas Gleixner wrote:
> The patch below cures it.

Using module_mutex here is just lazy...  Here's 5c, go buy your own lock :)

>  	/*
> -	 * Strictly speaking this should have a spinlock to protect against
> -	 * traversals, but since we only traverse on BUG()s, a spinlock
> -	 * could potentially lead to deadlock and thus be counter-productive.
> +	 * We need to take module_mutex here to protect the list add, though
> +	 * it won't protect against a concurrent BUG().
>  	 */
> +	mutex_lock(&module_mutex);
>  	list_add(&mod->bug_list, &module_bug_list);
> +	mutex_unlock(&module_mutex);
>  
>  	return 0;
>  }
>  
>  void module_bug_cleanup(struct module *mod)
>  {
> +	mutex_lock(&module_mutex);
>  	list_del(&mod->bug_list);
> +	mutex_unlock(&module_mutex);
>  }
>  
>  #else
> 
