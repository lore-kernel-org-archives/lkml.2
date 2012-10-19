Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134Ab2JSOZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 10:25:27 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:37257 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759120Ab2JSOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 10:25:22 -0400
MIME-Version: 1.0
In-Reply-To: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
References: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
Date: Fri, 19 Oct 2012 18:25:21 +0400
Message-ID: <CANaxB-yw+onpghQ8pHxrdr21etJ-FYROYhiUo3Yw53EoZGSMcg@mail.gmail.com>
Subject: Re: [PATCH] pidns: limit the nesting depth of pid namespaces
From: Andrey Wagin <avagin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Vagin <avagin@openvz.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew and Oleg,

Andrew, what do you think about this patch? I reworked it according
with your comments to the previous version.

Oleg, could you send Ack in this version, if it's ok for you.

Thanks.

2012/10/12 Andrew Vagin <avagin@openvz.org>:
> 'struct pid' is a "variable sized struct" - a header with an array
> of upids at the end.
>
> A size of the array depends on a level (depth) of pid namespaces. Now
> a level of pidns is not limited, so 'struct pid' can be more than one
> page.
>
> Looks reasonable, that it should be less than a page. MAX_PIS_NS_LEVEL
> is not calculated from PAGE_SIZE, because in this case it depends on
> architectures, config options and it will be reduced, if someone adds a
> new fields in struct pid or struct upid.
>
> I suggest to set MAX_PIS_NS_LEVEL = 32, because it saves ability to
> expand "struct pid" and it's more than enough for all known for me
> use-cases.  When someone finds a reasonable use case, we can add a
> config option or a sysctl parameter.
>
> In addition it will reduce effect of another problem, when we have many
> nested namespaces and the oldest one starts dying.  zap_pid_ns_processe
> will be called for each namespace and find_vpid will be called for each
> process in a namespace. find_vpid will be called minimum max_level^2 / 2
> times. The reason of that is that when we found a bit in pidmap, we
> can't determine this pidns is top for this process or it isn't.
>
> vpid is a heavy operation, so a fork bomb, which create many nested
> namespace, can do a system inaccessible for a long time.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  kernel/pid_namespace.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index b051fa6..598bfb3 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -70,12 +70,18 @@ err_alloc:
>         return NULL;
>  }
>
> +/* MAX_PID_NS_LEVEL is needed for limiting size of 'struct pid' */
> +#define MAX_PID_NS_LEVEL 32
> +
>  static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
>  {
>         struct pid_namespace *ns;
>         unsigned int level = parent_pid_ns->level + 1;
>         int i, err = -ENOMEM;
>
> +       if (level > MAX_PID_NS_LEVEL)
> +               goto out;
> +
>         ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
>         if (ns == NULL)
>                 goto out;
> --
> 1.7.1
>
