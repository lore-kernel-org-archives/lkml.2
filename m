Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1EEWG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 18:06:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51580 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752727Ab1EEWG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 18:06:26 -0400
Date: Thu, 5 May 2011 15:06:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 1/1] coredump: use task comm instead of (unknown)
Message-Id: <20110505150601.a4457970.akpm@linux-foundation.org>
In-Reply-To: <1304494354-21487-1-git-send-email-jslaby@suse.cz>
References: <4DC0FFAB.1000805@gmail.com>
	<1304494354-21487-1-git-send-email-jslaby@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 May 2011 09:32:34 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> If we don't know the file corresponding to the binary (i.e. exe_file
> is unknown), use "task->comm (path unknown)" instead of simple
> "(unknown)" as suggested by ak.
> 
> The fallback is the same as %e except it will append "(path unknown)".
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andi Kleen <andi@firstfloor.org>
> ---
>  fs/exec.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 5ee7562..0a4d281 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1555,7 +1555,7 @@ static int cn_print_exe_file(struct core_name *cn)
>  
>  	exe_file = get_mm_exe_file(current->mm);
>  	if (!exe_file)
> -		return cn_printf(cn, "(unknown)");
> +		return cn_printf(cn, "%s (path unknown)", current->comm);
>  
>  	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
>  	if (!pathbuf) {

Direct access to current->comm is racy since we added
prctl(PR_SET_NAME).

Hopefully John Stultz will soon be presenting us with a %p modifier for
displaying task_struct.comm.

But we should get this settled pretty promptly as this is a form of
userspace-visible API.  Use get_task_comm() for now.

Also, there's nothing which prevents userspace from rewriting
task->comm to something which contains slashes (this seems bad).  If
that is done, your patch will do Bad Things - it should be modified to
use cn_print_exe_file()'s slash-overwriting codepath.

