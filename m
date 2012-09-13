Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab2IMPeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 11:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25130 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab2IMPee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 11:34:34 -0400
Date: Thu, 13 Sep 2012 17:36:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>,
        Roland McGrath <roland@hack.frob.com>
Subject: Re: [PATCH 2/2] coredump: add a new elf note with siginfo fields
	of the signal
Message-ID: <20120913153615.GB32128@redhat.com>
References: <1347493124-10661-1-git-send-email-vda.linux@googlemail.com> <1347493124-10661-2-git-send-email-vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347493124-10661-2-git-send-email-vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13, Denys Vlasenko wrote:
>
> This patch adds a new elf note, NT_SIGINFO, which contains
> the remaining fields of siginfo_t.

I can't really comment this patch, but...

> +struct coredump_siginfo {
> +/*	int	csi_signo;	in prstatus.pr_info.si_signo instead */
> +/*	int	csi_errno;	in prstatus.pr_info.si_errno */
> +/*	int	csi_code;	in prstatus.pr_info.si_code */
> +	int	csi_pid;	/* PID of sending process */
> +	int	csi_uid;	/* Real UID of sending process */
> +/*	int	csi_status;	SIGCHLD never kills, field isn't meaningful */
> +/*	clock_t	csi_utime;	SIGCHLD never kills, field isn't meaningful */
> +/*	clock_t	csi_stime;	SIGCHLD never kills, field isn't meaningful */
> +	void	*csi_ptr;	/* union with si_int */
> +	int	csi_tid;	/* POSIX.1b timers */
> +	int	csi_overrun;	/* POSIX.1b timers */
> +	long	csi_band;	/* SIGIO/POLL: band event */
> +	int	csi_fd;		/* SIGIO/POLL: file descriptor */
> +	void	*csi_addr;	/* SEGV/BUS: address which caused fault */
> +	int	csi_trapno;	/* SEGV/BUS */
> +	int	csi_addr_lsb;	/* SEGV/BUS: least significant bit of address */
> +	/* Can be extended in the future, if siginfo_t is extended */
> +};
> +
> +static void fill_siginfo_note(struct memelfnote *note, struct coredump_siginfo *data, siginfo_t *siginfo)
> +{
> +	data->csi_pid      = siginfo->si_pid;
> +	data->csi_uid      = siginfo->si_uid;
> +	data->csi_ptr      = siginfo->si_ptr;
> +	data->csi_overrun  = siginfo->si_overrun;
> +	data->csi_tid      = siginfo->si_tid;
> +	data->csi_band     = siginfo->si_band;
> +	data->csi_fd       = siginfo->si_fd;
> +	data->csi_addr     = siginfo->si_addr;
> +#ifdef __ARCH_SI_TRAPNO
> +	data->csi_trapno   = siginfo->si_trapno;
> +#endif
> +	/* Prevent signed short->int expansion: */
> +	data->csi_addr_lsb = (unsigned short)siginfo->si_addr_lsb;
> +
> +	fill_note(note, "CORE", NT_SIGINFO, sizeof(*data), data);
> +}

I can't understand the layout. struct siginfo is union, for example
si_overrun only makes sense if si_code = SI_TIMER.

Not sure this is right. I think fill_siginfo_note() should either do
memcpy() and let userspace to decode this (raw) info, or this layout
should be unified with copy_siginfo_to_user().

Note also that we do not expose the upper bits of si_code to user-space,
probably coredump should do the same, I dunno.

Oleg.

