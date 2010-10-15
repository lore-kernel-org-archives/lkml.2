Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932369Ab0JOTNs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:13:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:58902 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932077Ab0JOTNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:13:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,337,1283756400"; 
   d="scan'208";a="847582796"
Message-ID: <4CB8A7EB.6050303@linux.intel.com>
Date: Fri, 15 Oct 2010 12:13:47 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: Louis Rilling <louis.rilling@kerlabs.com>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?B?TWF0dGhpZXUgRmVydHLDqQ==?= <matthieu.fertre@kerlabs.com>
Subject: Re: [RESEND PATCH] futex: fix key reference counter in case of requeue.
References: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com>
In-Reply-To: <1287055805-18233-1-git-send-email-louis.rilling@kerlabs.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2010 04:30 AM, Louis Rilling wrote:
> From: Matthieu Fertré<matthieu.fertre@kerlabs.com>

Hi Matthew,

>
> This patch ensures that we are referring to the right key when dropping
> reference for the futex_wait operation.
>
> The following scenario explains a typical case where the bug was
> happening:
>
> Process P calls futex_wait() on futex identified by 'key1'. 2 references
> are taken on this key: one for the struct futex_q itself, and one for the
> futex_wait operation.
> If now, process P is requeued on a futex identified by 'key2', its
> futex_q->key is updated from 'key1' to 'key2' and a reference is got
> to 'key2' and one is dropped to 'key1'.
> Later, another process calls futex_wake(): it gets a reference to
> 'key2', wakes process P, and drops reference to 'key2'.
> Once process P is woken up, it should unqueue, drop reference to 'key2'
> (the one referring to the futex_q, this is done in unqueue_me())
> and to 'key1' (the one referring to futex_wait operation). Without this
> patch it drops reference to 'key2' instead of 'key1'.

Nice catch. How did this manifest itself? Did you catch it just by code 
inspection?

I've been trying to develop a futex test suite to catch issues with the 
futex implementation, as well as to test any changes made to avoid 
regressions. Mind having a look?

http://git.kernel.org/?p=linux/kernel/git/dvhart/futextest.git;a=summary

> Signed-off-by: Matthieu Fertré<matthieu.fertre@kerlabs.com>
> Signed-off-by: Louis Rilling<louis.rilling@kerlabs.com>
> ---
>   kernel/futex.c |    8 ++++++--
>   1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index 6a3a5fa..bed6717 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -1791,6 +1791,7 @@ static int futex_wait(u32 __user *uaddr, int fshared,
>   	struct restart_block *restart;
>   	struct futex_hash_bucket *hb;
>   	struct futex_q q;
> +	union futex_key key;

We should be able to do this properly without requiring an additional 
key variable. I think tglx has proposed a suitable fix - but it needs 
testing to avoid any subtle regressions.

-- 
Darren Hart
Embedded Linux Kernel
