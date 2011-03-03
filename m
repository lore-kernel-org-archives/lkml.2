Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab1CCHld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 02:41:33 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21694 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab1CCHlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 02:41:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gYHaySz30RRpx447dW6GQAQi2RRNMUoAhdNhvqIHfwHGG/xe/LCbHKPSojX0uKmp0d
         kZAyzxC9YgzPZIHy6pgA==
MIME-Version: 1.0
In-Reply-To: <4D6F346E.9070606@cn.fujitsu.com>
References: <4D6F3461.6060406@cn.fujitsu.com>
	<4D6F346E.9070606@cn.fujitsu.com>
Date: Thu, 3 Mar 2011 08:41:29 +0100
Message-ID: <AANLkTikp+Qvjr4KUmkEshL0VEhE5n6Yto_JLGUXZmiph@mail.gmail.com>
Subject: Re: [PATCH 2/4] perf cgroup: Fix unmatched call to perf_detach_cgroup()
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
> In the failure path, we call perf_detach_cgroup(), but we didn't
> call perf_get_cgroup() prio to it.
>
the funny thing is that I had this change at some point. But apparently
it got lost in the many revisions of the patch. Thanks for fixing it.

Acked-by: Stephane Eranian <eranian@google.com>

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/perf_event.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> index 4a955fd..dca92b2 100644
> --- a/kernel/perf_event.c
> +++ b/kernel/perf_event.c
> @@ -412,6 +412,9 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
>        cgrp = container_of(css, struct perf_cgroup, css);
>        event->cgrp = cgrp;
>
> +       /* must be done before we fput() the file */
> +       perf_get_cgroup(event);
> +
>        /*
>         * all events in a group must monitor
>         * the same cgroup because a task belongs
> @@ -420,9 +423,6 @@ static inline int perf_cgroup_connect(int fd, struct perf_event *event,
>        if (group_leader && group_leader->cgrp != cgrp) {
>                perf_detach_cgroup(event);
>                ret = -EINVAL;
> -       } else {
> -               /* must be done before we fput() the file */
> -               perf_get_cgroup(event);
>        }
>  out:
>        fput_light(file, fput_needed);
> --
> 1.6.3
>
