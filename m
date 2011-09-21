Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab1IUI2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 04:28:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:48042 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1IUI2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 04:28:05 -0400
Date: Wed, 21 Sep 2011 10:28:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: akpm@google.com
cc: cschan@codeaurora.org, john.stultz@linaro.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] debugobjects: extend debugobjects to assert that an
 object is initialized
In-Reply-To: <201109202114.p8KLEpmO023041@wpaz9.hot.corp.google.com>
Message-ID: <alpine.LFD.2.02.1109211027210.2723@ionos>
References: <201109202114.p8KLEpmO023041@wpaz9.hot.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Sep 2011, akpm@google.com wrote:

Back to LKML

> From: Christine Chan <cschan@codeaurora.org>
> Subject: debugobjects: extend debugobjects to assert that an object is initialized
> 
> Add new check (assert_init) to make sure objects are initialized and
> tracked by debugobjects.

When is this function to be called and what problem does it solve
which is not handled by the current code?
 
> +	int (*fixup_assert_init)(void *addr, enum debug_obj_state state);
>  };
>  
>  /**
> + * debug_object_assert_init - debug checks when object should be init-ed
> + * @addr:	address of the object
> + * @descr:	pointer to an object specific debug description structure
> + */
> +void debug_object_assert_init(void *addr, struct debug_obj_descr *descr)
> +{
> +	struct debug_bucket *db;
> +	struct debug_obj *obj;
> +	unsigned long flags;
> +
> +	if (!debug_objects_enabled)
> +		return;
> +
> +	db = get_bucket((unsigned long) addr);
> +
> +	raw_spin_lock_irqsave(&db->lock, flags);
> +
> +	obj = lookup_object(addr, db);
> +	if (!obj) {
> +		raw_spin_unlock_irqrestore(&db->lock, flags);
> +		/*
> +		 * Maybe the object is static.  Let the type specific
> +		 * code decide what to do.
> +		 */
> +		debug_object_fixup(descr->fixup_assert_init, addr,
> +				   ODEBUG_STATE_NOTAVAILABLE);

So what's the point of requiring that function to return a value when
it's unchecked?

Thanks,

	tglx
