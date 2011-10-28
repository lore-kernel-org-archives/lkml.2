Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933847Ab1J1X0d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:26:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780Ab1J1X0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:26:32 -0400
Date: Fri, 28 Oct 2011 16:26:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, Earl Chew <earl_chew@agilent.com>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec: log when wait_for_dump_helpers aborts due to a
 signal
Message-Id: <20111028162631.294c1f8a.akpm@linux-foundation.org>
In-Reply-To: <1319591228-20397-1-git-send-email-msb@chromium.org>
References: <1319591228-20397-1-git-send-email-msb@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Oct 2011 18:07:08 -0700
Mandeep Singh Baines <msb@chromium.org> wrote:

> To allow coredump pipe readers to look at /proc/<pid> of the crashing
> process, the kernel waits for the reader to exit. However, the wait
> is silently aborted if the crashing process is signalled.
> 
> This patch, logs whenever wait_for_dump_helpers is aborted or in order
> to assist in debugging cases where /proc/<pid> is gone.

You don't really describe what problem you're observing.  What's the
use case?  What are you trying to do?  etc.

Because if that is known, we can perhaps find better solutions.

> Alternatively, we may want to consider not aborting on a signal. You
> could always break the loop by killing the reader process.

Well.  Neil's changelog for 61be228a06dc6e8662 is quite nice and tells
us everything we could possibly want to know, except for why it tests
sgnal_pending() :(

Neil, Oleg: can you remember?

> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2030,7 +2030,14 @@ static void wait_for_dump_helpers(struct file *file)
>  	pipe->readers++;
>  	pipe->writers--;
>  
> -	while ((pipe->readers > 1) && (!signal_pending(current))) {
> +	while (pipe->readers > 1) {
> +		if (signal_pending(current)) {
> +			pr_info("wait_for_dump_helpers[%d]: "
> +				"aborted due to signal\n",
> +				task_pid_nr(current));
> +			break;
> +		}
> +

argh, printk("i screwed up").  Hopefully we can find a better solution
to whatever-your-problem is than this!
