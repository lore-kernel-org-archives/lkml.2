Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab1CCHkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:40:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21176 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1CCHkq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:40:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=F6Snntq+2CBCJg0DC8yRRXM86eePCA2BV+/hqavkQkcn3nOIHhPiJI3xnQZRwpKxMY
         ddHe0MftdSgDaTVaDbWg==
MIME-Version: 1.0
In-Reply-To: <4D6F3461.6060406@cn.fujitsu.com>
References: <4D6F3461.6060406@cn.fujitsu.com>
Date: Thu, 3 Mar 2011 08:40:42 +0100
Message-ID: <AANLkTinqRMyq-OdqBu3XoH7PmuGyzPiA8uor9jSWvWJu@mail.gmail.com>
Subject: Re: [PATCH 1/4] perf cgroup: Fix leak of file reference count
From: Stephane Eranian <eranian@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 3, 2011 at 7:25 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> In perf_cgroup_connect(), fput_light() is missing in a failure
> path.
>
Yes, you're right.

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 64a018e..4a955fd 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -404,8 +404,10 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
>                return -EBADF;
>
>        css = cgroup_css_from_dir(file, perf_subsys_id);
> -       if (IS_ERR(css))
> -               return PTR_ERR(css);
> +       if (IS_ERR(css)) {
> +               ret = PTR_ERR(css);
> +               goto out;
> +       }
>
>        cgrp = container_of(css, struct perf_cgroup, css);
>        event->cgrp = cgrp;
> @@ -422,6 +424,7 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
>                /* must be done before we fput() the file */
>                perf_get_cgroup(event);
>        }
> +out:
>        fput_light(file, fput_needed);
>        return ret;
>  }
> --
> 1.6.3
>
