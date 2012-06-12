Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab2FLKRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 06:17:36 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48560 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092Ab2FLKRf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 06:17:35 -0400
MIME-Version: 1.0
In-Reply-To: <1339479468-3815-4-git-send-email-zheng.z.yan@intel.com>
References: <1339479468-3815-1-git-send-email-zheng.z.yan@intel.com>
	<1339479468-3815-4-git-send-email-zheng.z.yan@intel.com>
Date: Tue, 12 Jun 2012 12:17:33 +0200
Message-ID: <CABPqkBRepH-=j3Y9qJ1kXTkTv3_p0wC=Kzu+q=7rdxwk8vxk6A@mail.gmail.com>
Subject: Re: [PATCH V5 03/13] perf: Allow pmu to choose cpu on which to
 install event
From: Stephane Eranian <eranian@google.com>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, jolsa@redhat.com,
        andi@firstfloor.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 7:37 AM, Yan, Zheng <zheng.z.yan@intel.com> wrote:
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
>
> Allow the pmu->event_init callback to change event->cpu, so pmu can
> choose cpu on which to install event.
>
So now, the user can say perf record -e xxxx -C 1 -a and then get nothing
out of perf report -C1 because under the cover the kernel has swapped
it for another CPU?

> Signed-off-by: Zheng Yan <zheng.z.yan@intel.com>
> ---
>  kernel/events/core.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index d71a2d6..2c05027 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -6302,7 +6302,7 @@ SYSCALL_DEFINE5(perf_event_open,
>        /*
>         * Get the target context (task or percpu):
>         */
> -       ctx = find_get_context(pmu, task, cpu);
> +       ctx = find_get_context(pmu, task, event->cpu);
>        if (IS_ERR(ctx)) {
>                err = PTR_ERR(ctx);
>                goto err_alloc;
> @@ -6375,16 +6375,16 @@ SYSCALL_DEFINE5(perf_event_open,
>        mutex_lock(&ctx->mutex);
>
>        if (move_group) {
> -               perf_install_in_context(ctx, group_leader, cpu);
> +               perf_install_in_context(ctx, group_leader, event->cpu);
>                get_ctx(ctx);
>                list_for_each_entry(sibling, &group_leader->sibling_list,
>                                    group_entry) {
> -                       perf_install_in_context(ctx, sibling, cpu);
> +                       perf_install_in_context(ctx, sibling, event->cpu);
>                        get_ctx(ctx);
>                }
>        }
>
> -       perf_install_in_context(ctx, event, cpu);
> +       perf_install_in_context(ctx, event, event->cpu);
>        ++ctx->generation;
>        perf_unpin_context(ctx);
>        mutex_unlock(&ctx->mutex);
> --
> 1.7.10.2
>
