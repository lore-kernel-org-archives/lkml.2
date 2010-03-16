Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417Ab0CPXnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 19:43:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:58322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab0CPXnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 19:43:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=JoHwJqWf3XOCDMzHNQKq64it14F8BNXKt1mEfuu2v5UbnvglKQYh1n+0xm4wjGj+w
	V6zJgneRIxxdn5J83WRzg==
Date: Tue, 16 Mar 2010 16:43:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Bob Sleigh <bobslgh@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] oom_kill: set default process to kill
In-Reply-To: <79c603601003160708s7fb45682rdec739776d0f5e81@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1003161639500.30209@chino.kir.corp.google.com>
References: <79c603601003160708s7fb45682rdec739776d0f5e81@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, Bob Sleigh wrote:

> ---
>  mm/Kconfig    |    9 +++++++++
>  mm/oom_kill.c |   10 ++++++++++
>  2 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9c61158..3911730 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -287,3 +287,12 @@ config NOMMU_INITIAL_TRIM_EXCESS
>           of 1 says that all excess pages should be trimmed.
> 
>           See Documentation/nommu-mmap.txt for more information.
> +
> +config MM_USUAL_SUSPECT
> +       string "Default executable name to be killed by the OOM killer"
> +       default ""
> +       help
> +         This option sets the default executable name to be killed when we run
> +         out of memory.
> +
> +         If unsure, set to "firefox-bin".
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 35755a4..333fa46 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -300,6 +300,16 @@ static struct task_struct
> *select_bad_process(unsigned long *ppoints,
>                 if (p->signal->oom_adj == OOM_DISABLE)
>                         continue;
> 
> +#ifdef CONFIG_MM_USUAL_SUSPECT
> +               /*
> +                * Select the task if matching the usual suspect.
> +                */
> +               if (strcmp(p->comm, CONFIG_MM_USUAL_SUSPECT)) {
> +                       chosen = p;
> +                       continue;
> +               }
> +#endif
> +
>                 points = badness(p, uptime.tv_sec);
>                 if (points > *ppoints || !chosen) {
>                         chosen = p;

I'm assuming that you wrote this to make a point rather than for it to be 
considered for merging since this patch doesn't work for a couple reasons: 
(i) strcmp() returns 0 when strings match, so this patch actually selects 
every task _except_ the configured task, and (ii) you never set "points" 
to be anything so its not guaranteed to be selected.

I have a patchset pending that completely rewrites the oom killer, so it 
would be helpful if you could test that and let me know your feedback if 
it still isn't meeting you needs.  The patchset can be found at

	http://www.kernel.org/pub/linux/kernel/people/rientjes/oom-killer-rewrite

for 2.6.34-rc1.  Thanks.
