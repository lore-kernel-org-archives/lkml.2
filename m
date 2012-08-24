Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab2HXN0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 09:26:35 -0400
Received: from mail16.primus.ca ([216.254.141.183]:36636 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751931Ab2HXN0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 09:26:33 -0400
Message-ID: <50378117.4010601@bell.net>
Date: Fri, 24 Aug 2012 09:26:47 -0400
From: John David Anglin <dave.anglin@bell.net>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, Parisc <linux-parisc@vger.kernel.org>,
        "3.2.x.." <stable@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 08/10] parisc: Add missing RCU idle APIs on idle loop
References: <1345652628-15060-1-git-send-email-fweisbec@gmail.com> <1345652628-15060-9-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1345652628-15060-9-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated: danglin-lux@magma.ca - 216-58-40-249.cpe.distributel.net ([192.168.0.181]) [216.58.40.249]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/2012 12:23 PM, Frederic Weisbecker wrote:
> In the old times, the whole idle task was considered
> as an RCU quiescent state. But as RCU became more and
> more successful overtime, some RCU read side critical
> section have been added even in the code of some
> architectures idle tasks, for tracing for example.
>
> So nowadays, rcu_idle_enter() and rcu_idle_exit() must
> be called by the architecture to tell RCU about the part
> in the idle loop that doesn't make use of rcu read side
> critical sections, typically the part that puts the CPU
> in low power mode.
>
> This is necessary for RCU to find the quiescent states in
> idle in order to complete grace periods.
>
> Add this missing pair of calls in the parisc's idle loop.
>
> Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: James E.J. Bottomley <jejb@parisc-linux.org>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Parisc <linux-parisc@vger.kernel.org>
> Cc: 3.2.x.. <stable@kernel.org>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>   arch/parisc/kernel/process.c |    3 +++
>   1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
> index d4b94b3..c54a4db 100644
> --- a/arch/parisc/kernel/process.c
> +++ b/arch/parisc/kernel/process.c
> @@ -48,6 +48,7 @@
>   #include <linux/unistd.h>
>   #include <linux/kallsyms.h>
>   #include <linux/uaccess.h>
> +#include <linux/rcupdate.h>
>   
>   #include <asm/io.h>
>   #include <asm/asm-offsets.h>
> @@ -69,8 +70,10 @@ void cpu_idle(void)
>   
>   	/* endless idle loop with no priority at all */
>   	while (1) {
> +		rcu_idle_enter();
>   		while (!need_resched())
>   			barrier();
> +		rcu_idle_exit();
>   		schedule_preempt_disabled();
>   		check_pgt_cache();
>   	}

Builds and boots fine on parisc.
Acked-by: John David Anglin<dave.anglin@bell.net>

Dave

-- 
John David Anglin    dave.anglin@bell.net

