Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0HRO3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 10:29:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49803 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191Ab0HRO3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 10:29:15 -0400
Date: Wed, 18 Aug 2010 07:26:47 -0700
From: Greg KH <gregkh@suse.de>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: lkml@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <johnstul@us.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Kacur <jkacur@redhat.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFCv2] notify userspace about time changes
Message-ID: <20100818142647.GA32627@suse.de>
References: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282139739-23832-1-git-send-email-virtuoso@slind.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 04:55:39PM +0300, Alexander Shishkin wrote:
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-kernel-time-notify
> @@ -0,0 +1,39 @@
> +What:		/sys/kernel/time_notify
> +Date:		August 2010
> +Contact:	Alexander Shishkin <virtuoso@slind.org>
> +Description:
> +		This file is used by processes which want to receive
> +		notifications about system time changes, to communicate their
> +		eventfd descriptor number along with the type of event they
> +		wish to subscribe to and filtering options. Every time one of
> +		the processes in the system succeeds in doing a settimeofday()
> +		or adjtimex(), this eventfd will be signalled.
> +		This file is not readable. Upon write, this is the format
> +		accepted by the kernel:
> +		<fd> <want-others> <want-own> <want-set> <want-adj>
> +		where
> +		- <fd> is the file descriptor of the eventfd that the process
> +		will listen to for time change events;
> +		- <want-others> is 0 or 1 depending on whether the process wants
> +		to be notified about other processes' time changes;
> +		- <want-own> -- likewise, for process' own time changes;
> +		- <want-set> is 0 or 1 depending on whether the process wants
> +		to be notified about settimeofday()/stime() system calls;
> +		- <want-adj> -- likewise, for adjtimex() system call.
> +
> +		A simple snippet of C code illustrates the usage pattern:
> +
> +		     efd = eventfd(0, 0);
> +		     fd = open("/sys/kernel/time_notify", O_WRONLY);
> +		     fdprintf(fd, "%d 1 0 1 1", efd);
> +		     close(fd);
> +
> +		     fds[0].fd = efd;
> +		     fds[0].events = POLLIN;
> +		     while (poll(fds, 1, -1) > 0) {
> +		           uint64_t n;
> +
> +			   read(efd, &n, 8);
> +			   printf("time has been modified %d time(s)\n", n);
> +		     }

While this isn't the "nicest" sysfs file ever, it's not all that bad.


> +/* time change events */
> +#define TIME_EVENT_SET 0
> +#define TIME_EVENT_ADJ 1
> +
> +#ifdef CONFIG_TIME_NOTIFY
> +void time_notify_all(int type);
> +#else
> +#define time_notify_all(x) do {} while (0)

static inline please so we do a typecheck.

> +#endif
> +
>  #endif /* __KERNEL__ */
>  
>  #define NFDBITS			__NFDBITS
> diff --git a/init/Kconfig b/init/Kconfig
> index 2de5b1c..aa4d890 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -980,6 +980,14 @@ config PERF_USE_VMALLOC
>  	help
>  	  See tools/perf/design.txt for details
>  
> +config TIME_NOTIFY
> +	bool
> +	default y

Really?  You obviously haven't added new Kconfig options to the kernel
in the past and been yelled at by Linus :)

> +	evt->eventfd = eventfd_ctx_fileget(file);
> +	if (!evt->eventfd) {
> +		ret = PTR_ERR(evt->eventfd);

Are you sure this is correct?

thanks,

greg k-h
