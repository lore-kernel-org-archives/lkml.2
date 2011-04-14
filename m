Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758667Ab1DNCfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 22:35:36 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38426 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758440Ab1DNCff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 22:35:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tlRFY5nvPp7lQ5wMBu0fHPa9qeUG4+wwiOkVUoz8KHG12pJuG47+tSQw8QO7IQ5O9g
         zBmsZFJwBtCsebVWTVwR9twS7rdBp9iHw6vn7vjjn60njaePV9RZyyaZoJKMoUpCRIKJ
         mpO2Bb7+D1MTUEbj1LQuO9a1ZErzpW/jXKbTo=
Subject: Re: [patch v3 2/3] percpu_counter: fix code for 32bit systems for
 UP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        cl@linux.com
In-Reply-To: <20110414020747.201728372@sli10-conroe.sh.intel.com>
References: <20110414020447.979946152@sli10-conroe.sh.intel.com>
	 <20110414020747.201728372@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Apr 2011 04:35:30 +0200
Message-ID: <1302748530.3549.24.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 14 avril 2011 à 10:04 +0800, shaohua.li@intel.com a écrit :
> pièce jointe document texte brut (percpu-counter-32bits.patch)
> percpu_counter.counter is a 's64'. Accessing it in 32-bit system is racing.
> we need some locking to protect it otherwise some very wrong value could be
> accessed.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  include/linux/percpu_counter.h |   37 ++++++++++++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 11 deletions(-)
> 
> Index: linux/include/linux/percpu_counter.h
> ===================================================================
> --- linux.orig/include/linux/percpu_counter.h	2011-04-14 08:50:45.000000000 +0800
> +++ linux/include/linux/percpu_counter.h	2011-04-14 09:09:14.000000000 +0800
> @@ -89,9 +89,20 @@ struct percpu_counter {
>  	s64 count;
>  };
>  
> -static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
> +static inline void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
>  {
> +#if BITS_PER_LONG == 32
> +	preempt_disable();
>  	fbc->count = amount;
> +	preempt_enable();
> +#else
> +	fbc->count = amount;
> +#endif
> +}
> +
> +static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
> +{
> +	percpu_counter_set(fbc, amount);
>  	return 0;
>  }
>  

Please dont do this and obfuscate the code.

percpu_counter_init() cannot be racy.

Its like saying spin_lock_init() could be racy.

No other thread/cpu is supposed to use the object if not yet
initialized.



