Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1J0RmQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 13:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab1J0RmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 13:42:14 -0400
Date: Thu, 27 Oct 2011 13:40:53 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: akpm@linux-foundation.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kdump: Fix crash_kexec - smp_send_stop race in panic
Message-ID: <20111027174053.GK7491@redhat.com>
References: <1319639649.3321.11.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319639649.3321.11.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 04:34:09PM +0200, Michael Holzheu wrote:
> Hello Andrew,
> 
> After the discussion with Eric and Vivek the following patch
> seems to be a good solution to me. Could you accept this patch?
> 
> When two CPUs call panic at the same time there is a
> possible race condition that can stop kdump. The first
> CPU calls crash_kexec() and the second CPU calls
> smp_send_stop() in panic() before crash_kexec() finished
> on the first CPU. So the second CPU stops the first CPU
> and therefore kdump fails:
> 
> 1st CPU:
> panic()->crash_kexec()->mutex_trylock(&kexec_mutex)-> do kdump
> 
> 2nd CPU:
> panic()->crash_kexec()->kexec_mutex already held by 1st CPU
>        ->smp_send_stop()-> stop 1st CPU (stop kdump)
> 
> This patch fixes the problem by introducing a spinlock in
> panic that allows only one CPU to process crash_kexec() and
> the subsequent panic code.
> 
> Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Sounds reasonable to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> ---
>  kernel/panic.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -59,6 +59,7 @@ EXPORT_SYMBOL(panic_blink);
>   */
>  NORET_TYPE void panic(const char * fmt, ...)
>  {
> +	static DEFINE_SPINLOCK(panic_lock);
>  	static char buf[1024];
>  	va_list args;
>  	long i, i_next = 0;
> @@ -82,6 +83,13 @@ NORET_TYPE void panic(const char * fmt,
>  #endif
>  
>  	/*
> +	 * Only one CPU is allowed to execute the panic code from here. For
> +	 * multiple parallel invocations of panic all other CPUs will wait on
> +	 * the panic_lock. They are stopped afterwards by smp_send_stop().
> +	 */
> +	spin_lock(&panic_lock);
> +
> +	/*
>  	 * If we have crashed and we have a crash kernel loaded let it handle
>  	 * everything else.
>  	 * Do we want to call this before we try to display a message?
> 
