Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1JZBYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 21:24:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:6045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab1JZBYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 21:24:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=vXdlxZ8U9Wy46rkJIZNa9iPlp/VDleT//uj5AFI8jEBKP+yB9pw4XvtwEyMD9em26
	3Q4nVaW056jpqcxenUfXg==
MIME-Version: 1.0
In-Reply-To: <1319591228-20397-1-git-send-email-msb@chromium.org>
References: <1319591228-20397-1-git-send-email-msb@chromium.org>
Date: Tue, 25 Oct 2011 18:24:02 -0700
X-Google-Sender-Auth: oMzUepGVldJsc0-ifHXKAVoAMRw
Message-ID: <CACBanvpnL-UunA9FLoUuXtz0i1EAToQWav0ZPZ5e7fsnDf9o2w@mail.gmail.com>
Subject: Re: [PATCH] exec: log when wait_for_dump_helpers aborts due to a signal
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 6:07 PM, Mandeep Singh Baines <msb@chromium.org> wrote:
> To allow coredump pipe readers to look at /proc/<pid> of the crashing
> process, the kernel waits for the reader to exit. However, the wait
> is silently aborted if the crashing process is signalled.
>
> This patch, logs whenever wait_for_dump_helpers is aborted or in order
> to assist in debugging cases where /proc/<pid> is gone.
>
> Alternatively, we may want to consider not aborting on a signal. You
> could always break the loop by killing the reader process.
>

Not checking for signal pending might not be such a bad idea. If you're stuck in
wait_for_dump_helpers, it means the reader is stuck so you'll want to kill it.
Once you kill the reader, the loop will exit naturally.

> Reference: http://crosbug.com/21559
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Earl Chew <earl_chew@agilent.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/exec.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 25dcbe5..5d4190d 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2030,7 +2030,14 @@ static void wait_for_dump_helpers(struct file *file)
>        pipe->readers++;
>        pipe->writers--;
>
> -       while ((pipe->readers > 1) && (!signal_pending(current))) {
> +       while (pipe->readers > 1) {
> +               if (signal_pending(current)) {
> +                       pr_info("wait_for_dump_helpers[%d]: "
> +                               "aborted due to signal\n",
> +                               task_pid_nr(current));
> +                       break;
> +               }
> +
>                wake_up_interruptible_sync(&pipe->wait);
>                kill_fasync(&pipe->fasync_readers, SIGIO, POLL_IN);
>                pipe_wait(pipe);
> --
> 1.7.3.1
>
>
