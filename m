Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966249Ab2DLXfL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:35:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999Ab2DLXfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:35:09 -0400
Date: Thu, 12 Apr 2012 16:35:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/2] mm: set task exit code before complete_vfork_done()
Message-Id: <20120412163507.6b8c6d94.akpm@linux-foundation.org>
In-Reply-To: <20120412080948.26401.23572.stgit@zurg>
References: <20120409200336.8368.63793.stgit@zurg>
	<20120412080948.26401.23572.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 12:09:48 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> kthread_stop() uses task->vfork_done for synchronization. The exiting kthread
> shouldn't do complete_vfork_done() until it sets ->exit_code.
> 
> fix for mm-correctly-synchronize-rss-counters-at-exit-exec.patch
> 
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/exit.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/exit.c b/kernel/exit.c
> index eb12719..70875a6 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -960,6 +960,9 @@ void do_exit(long code)
>  
>  	acct_update_integrals(tsk);
>  
> +	/* Set exit_code before complete_vfork_done() in mm_release() */
> +	tsk->exit_code = code;
> +
>  	/* Release mm and sync mm's RSS info before statistics gathering */
>  	mm_release(tsk, tsk->mm);
>  
> @@ -975,7 +978,6 @@ void do_exit(long code)
>  		tty_audit_exit();
>  	audit_free(tsk);
>  
> -	tsk->exit_code = code;
>  	taskstats_exit(tsk, group_dead);
>  

So does this patch address Oleg's objection to
mm-correctly-synchronize-rss-counters-at-exit-exec.patch?
