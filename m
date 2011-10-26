Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768Ab1JZRiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:38:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909Ab1JZRix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:38:53 -0400
Date: Wed, 26 Oct 2011 18:54:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, Earl Chew <earl_chew@agilent.com>,
        Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec: log when wait_for_dump_helpers aborts due to a
	signal
Message-ID: <20111026165400.GB18076@redhat.com>
References: <1319591228-20397-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319591228-20397-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25, Mandeep Singh Baines wrote:
>
> To allow coredump pipe readers to look at /proc/<pid> of the crashing
> process, the kernel waits for the reader to exit. However, the wait
> is silently aborted if the crashing process is signalled.

Well, yes... But note that this signal_pending() is only used because
with TIF_SIGPENDING we have the problems anyway.

Oh. I promise myself I'll make do_coredump() killable and cleanup this
all every time I look at this code...

> This patch, logs whenever wait_for_dump_helpers is aborted or in order
> to assist in debugging cases where /proc/<pid> is gone.

I don't really understand why this is useful. The reader process
can complain if it can't collect the data (say, /proc/pid goes away
or EOF doesn't come).



As for the patch itself,

> -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> +	while (pipe->readers > 1) {
> +		if (signal_pending(current)) {
> +			pr_info("wait_for_dump_helpers[%d]: "
> +				"aborted due to signal\n",
> +				task_pid_nr(current));
> +			break;
> +		}
> +
>  		wake_up_interruptible_sync(&pipe->wait);

This can't help in general. If signal_pending() == T, it is quite
possible that pipe_write() already failed before.

Oleg.

