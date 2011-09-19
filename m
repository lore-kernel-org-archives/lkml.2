Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932909Ab1ISWXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:23:37 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49259 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932760Ab1ISWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:23:35 -0400
Subject: Re: [PATCH 1/2] posix-timers: move global timer id management to
 signal_struct v4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Andi Kleen <ak@linux.intel.com>
In-Reply-To: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
References: <1316468925-16754-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 00:23:27 +0200
Message-ID: <1316471007.2455.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 19 septembre 2011 à 14:48 -0700, Andi Kleen a écrit :
> From: Andi Kleen <ak@linux.intel.com>
> 
> Move the global posix timer ids IDR to signal_struct. This removes
> a minor global scalability bottleneck and also allows to finally limit
> the number of process timers in a sane way (see next patch)
> 
> I put it into signal_struct following the other posix timer per process
> structures.
> 
> v2: Now with locking again (thanks Eric)
> v3: Fix the locking too (Eric Dumazet)
> v4: Use a mutex. Get rid of retry loop.
> idr_pre_get() is still there to avoid major surgery in lib/idr.c.
> Random gleixnerfication
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---

> +	mutex_lock(&sig->idr_lock);
> +	error = -EAGAIN;
> +	if (idr_pre_get(&sig->posix_timers_id, GFP_KERNEL))
> +		error = idr_get_new(&sig->posix_timers_id, new_timer, 
> +				    &new_timer_id);
> +	mutex_unlock(&sig->idr_lock);
>  	if (error) {

On 64bit arches :

IDR_FREE_MAX=12 && sizeof(struct idr_layer)=544

This means idr_pre_get() consumes 6528 bytes of spare space per process,
even if only one posix timer is used.

I guess we should allow idr to call slab directly in this case (only a
mutex held, it's safe to sleep in slab), and not have this per idr
reserve/free_list : This was done because of some idr callers using a
spinlock.

I dont believe its major idr surgery :)



