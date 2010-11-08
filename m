Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab0KIKQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 05:16:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0KIKQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 05:16:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH RFC 2/8] clock device: convert clock_gettime
Date: Mon, 8 Nov 2010 07:56:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <cl@linux.com>,
        John Stultz <johnstul@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1288897198.git.richard.cochran@omicron.at> <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
In-Reply-To: <81ccd2674ebf26332898761ba6b7b54f395a15bd.1288897199.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011080756.50930.arnd@arndb.de>
X-Provags-ID: V02:K0:ztKWzJSs/qQQVb3FjPxTalahsrSWSYcOxayLaiI1eSC
 sVe1KP5V1iy6wtSQsPMg8RChLrEGWhK/eDnAvp8uiQxGz/g3dN
 4TEKk7bK/9kq1ip+8VUp0i3UXyEwf44ohAWPdHCGH1/EPNQQvc
 41v3iPb/Yk/305/1CYiu5StWS747wf8fvRak0O0Hm2XiU99dFq
 uTPPDxKsFVwwKay2hkDcQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 November 2010, Richard Cochran wrote:
> diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
> index 3e23844..70f40e6 100644
> --- a/include/linux/posix-timers.h
> +++ b/include/linux/posix-timers.h
> @@ -17,10 +17,22 @@ struct cpu_timer_list {
>  	int firing;
>  };
>  
> +/* Bit fields within a clockid:
> + *
> + * The most significant 29 bits hold either a pid or a file descriptor.
> + *
> + * Bit 2 indicates whether a cpu clock refers to a thread or a process.
> + *
> + * Bits 1 and 0 give the type: PROF=0, VIRT=1, SCHED=2, or FD=3.
> + *
> + * A clockid is invalid if bits 2, 1, and 0 all set (see also CLOCK_INVALID
> + * in include/linux/time.h)
> + */
> +
>  #define 	(clock)		((pid_t) ~((clock) >> 3))
>  #define CPUCLOCK_PERTHREAD(clock) \
>  	(((clock) & (clockid_t) CPUCLOCK_PERTHREAD_MASK) != 0)
> -#define CPUCLOCK_PID_MASK	7
> +
>  #define CPUCLOCK_PERTHREAD_MASK	4
>  #define CPUCLOCK_WHICH(clock)	((clock) & (clockid_t) CPUCLOCK_CLOCK_MASK)
>  #define CPUCLOCK_CLOCK_MASK	3
> @@ -28,12 +40,17 @@ struct cpu_timer_list {
>  #define CPUCLOCK_VIRT		1
>  #define CPUCLOCK_SCHED		2
>  #define CPUCLOCK_MAX		3
> +#define CLOCKFD			CPUCLOCK_MAX
> +#define CLOCKFD_MASK		(CPUCLOCK_PERTHREAD_MASK|CPUCLOCK_CLOCK_MASK)

It looks like you are turning a kernel internal interface into a user ABI,
which I think is highly questionable. Using the bits like this internally is
ok, but making it part of the syscall ABI means that we can never change this
in the future.

Maybe I was misunderstanding your patch though.

	Arnd

