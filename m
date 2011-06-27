Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908Ab1F0C7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 22:59:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54911 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756149Ab1F0C61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 22:58:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E07F1C0.2070305@jp.fujitsu.com>
Date: Mon, 27 Jun 2011 11:58:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: segoon@openwall.com
CC: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        rientjes@google.com, wilsons@start.ca, security@kernel.org,
        eparis@redhat.com, solar@openwall.com
Subject: Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
In-Reply-To: <1308917318-4749-1-git-send-email-segoon@openwall.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/24 21:08), Vasiliy Kulikov wrote:
> /proc/PID/io may be used for gathering private information.  E.g. for
> openssh and vsftpd daemons wchars/rchars may be used to learn the
> precise password length.  Restrict it to processes being able to ptrace
> the target process.
> 
> ptrace_may_access() is needed to prevent keeping open file descriptor of
> "io" file, executing setuid binary and gathering io information of the
> setuid'ed process.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

This description seems makes sense to me. But Vasilly, I have one question.
Doesn't this change break iotop command or other userland tools?


> ---
>  fs/proc/base.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 14def99..5ae25d1 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2712,6 +2712,9 @@ static int do_io_accounting(struct task_struct *task, char *buffer, int whole)
>  	struct task_io_accounting acct = task->ioac;
>  	unsigned long flags;
>  
> +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> +		return -EACCES;
> +

I think this check need a comment. Usually procfs don't use ptrace_may_access() directly
(see mm_for_maps) because it's racy against exec(). However I think your code is ok.
because a few bytes io accounting leak has no big matter.


