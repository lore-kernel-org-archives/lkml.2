Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab1LUWMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:12:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab1LUWMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:12:30 -0500
Date: Wed, 21 Dec 2011 14:12:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, mc@linux.vnet.ibm.com,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        david@fromorbit.com, Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-Id: <20111221141229.7f691c43.akpm@linux-foundation.org>
In-Reply-To: <4EF24C71.6000609@linux.vnet.ibm.com>
References: <20111220062710.GC23916@ZenIV.linux.org.uk>
	<4EF03915.60902@linux.vnet.ibm.com>
	<1324373854.21588.16.camel@mengcong>
	<4EF0654B.4060904@linux.vnet.ibm.com>
	<4EF06C9B.4010703@linux.vnet.ibm.com>
	<4EF084A4.3000106@linux.vnet.ibm.com>
	<20111220140628.GD23916@ZenIV.linux.org.uk>
	<4EF09D34.1060607@linux.vnet.ibm.com>
	<20111220175919.GE23916@ZenIV.linux.org.uk>
	<4EF0DE04.6030604@linux.vnet.ibm.com>
	<20111220195806.GF23916@ZenIV.linux.org.uk>
	<4EF24C71.6000609@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 02:45:29 +0530
"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:

off-topic, but the lockdep stuff in include/linux/lglock.h
(LOCKDEP_INIT_MAP and DEFINE_LGLOCK_LOCKDEP) appears to be dead code.

> --- a/include/linux/lglock.h
> +++ b/include/linux/lglock.h
> @@ -22,6 +22,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/lockdep.h>
>  #include <linux/percpu.h>
> +#include <linux/cpu.h>
>  
>  /* can make br locks by using local lock for read side, global lock for write */
>  #define br_lock_init(name)	name##_lock_init()
> @@ -72,9 +73,31 @@
>  
>  #define DEFINE_LGLOCK(name)						\
>  									\
> + DEFINE_SPINLOCK(name##_cpu_lock);					\
> + cpumask_t name##_cpus __read_mostly;					\
>   DEFINE_PER_CPU(arch_spinlock_t, name##_lock);				\
>   DEFINE_LGLOCK_LOCKDEP(name);						\
>  									\

also off-topic: we can't define a static lglock with this macro.
