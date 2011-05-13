Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646Ab1EMQqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:46:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42143 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759635Ab1EMQqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:46:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZxDExrrlNhtN2ojWtZRBzkYDyZoH5f7d8G4O8bkCMtxlfeoHi3/0gSp5g1eAIQvttu
         b+9iKThFHU8D78iqc9z3LbMouZAdxy/3r7dd4cjJH0LWx2MCn015ddvnjkVIt+hLjqmW
         rdXJ0JkMnQPyadhmHneKsCvZPpybFQJH1Ejs4=
Subject: Re: [patch V2] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305304532.3866.54.camel@edumazet-laptop>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
	 <1305261477.2373.45.camel@sli10-conroe>
	 <1305264007.2831.14.camel@edumazet-laptop>
	 <20110513052859.GA11088@sli10-conroe.sh.intel.com>
	 <1305268456.2831.38.camel@edumazet-laptop>
	 <1305298300.3866.22.camel@edumazet-laptop>
	 <1305301151.3866.39.camel@edumazet-laptop>
	 <1305304532.3866.54.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 18:46:30 +0200
Message-ID: <1305305190.3866.57.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 13 mai 2011 à 18:35 +0200, Eric Dumazet a écrit :

If you want to try this patch, please note I missed in
__percpu_counter_init() :

fbc->sum_cnt = 0; 


>  int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
>  			  struct lock_class_key *key)
>  {
> -	spin_lock_init(&fbc->lock);
> -	lockdep_set_class(&fbc->lock, key);
> -	fbc->count = amount;
> +	struct percpu_counter_rw *pcrw; 
> +
> +	pcrw = kzalloc(sizeof(*pcrw), GFP_KERNEL);
> +	if (!pcrw)
> +		return -ENOMEM;
> +	atomic64_set(&pcrw->count, amount);
> +
>  	fbc->counters = alloc_percpu(s32);
> -	if (!fbc->counters)
> +	if (!fbc->counters) {
> +		kfree(pcrw);
>  		return -ENOMEM;
> +	}
> +	fbc->pcrw = pcrw;

	fbc->sum_cnt = 0;

>  
>  	debug_percpu_counter_activate(fbc);
>  




