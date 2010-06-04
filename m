Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab0FDH4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 03:56:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab0FDH4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 03:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZygXmId0KGgH15qyBxX+67eFRi+4cvRsjiQ6JVyzcXopzXNi0JI9HR5pEBjKjxIm7K
         2178qlN4a+hgYMzBLgy+xjIpCKfCm1/II6tXOwCgQGQU3QTViD/PvYDU3RFcLX4T30k5
         MwfIjlIuLmwlY7JY2FKtHFGLQ1ghgG/4HIpTc=
Subject: Re: [patch 2/4] lglock: introduce special lglock and brlock spin
 locks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Frank Mayhar <fmayhar@google.com>, John Stultz <johnstul@us.ibm.com>,
       Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20100604072618.400686656@suse.de>
References: <20100604064307.737085373@suse.de>
	 <20100604072618.400686656@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Jun 2010 09:56:03 +0200
Message-ID: <1275638163.2482.2.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 04 juin 2010 à 16:43 +1000, Nick Piggin a écrit :
> pièce jointe document texte brut (kernel-introduce-brlock.patch)
> This patch introduces "local-global" locks (lglocks). These can be used to:
> 
> - Provide fast exclusive access to per-CPU data, with exclusive access to
>   another CPU's data allowed but possibly subject to contention, and to provide
>   very slow exclusive access to all per-CPU data.
> - Or to provide very fast and scalable read serialisation, and to provide
>   very slow exclusive serialisation of data (not necessarily per-CPU data).
> 
> Brlocks are also implemented as a short-hand notation for the latter use
> case.
> 
> Thanks to Paul for local/global naming convention.
> 
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> Cc: Frank Mayhar <fmayhar@google.com>,
> Cc: John Stultz <johnstul@us.ibm.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> ---
>  include/linux/lglock.h |  165 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 165 insertions(+)
> 

IMHO some changes in Documentation/ would be needed

> 								\
> + void name##_global_lock(void) {					\
> +	int i;								\
> +	preempt_disable();						\
> +	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
> +	for_each_online_cpu(i) {					\

for_each_possible_cpu()

> +		arch_spinlock_t *lock;					\
> +		lock = &per_cpu(name##_lock, i);			\
> +		arch_spin_lock(lock);					\
> +	}								\
> + }									\
> + EXPORT_SYMBOL(name##_global_lock);					\
> +									\
> + void name##_global_unlock(void) {					\
> +	int i;								\
> +	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
> +	for_each_online_cpu(i) {					\

for_each_possible_cpu()

> +		arch_spinlock_t *lock;					\
> +		lock = &per_cpu(name##_lock, i);			\
> +		arch_spin_unlock(lock);					\
> +	}								\
> +	preempt_enable();						\
> + }									\
> + EXPORT_SYMBOL(name##_global_unlock);					\
> +									\


