Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab2JTPTr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 11:19:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab2JTPTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 11:19:46 -0400
Date: Sat, 20 Oct 2012 17:21:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] pidns: limit the nesting depth of pid namespaces
Message-ID: <20121020152100.GA28039@redhat.com>
References: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12, Andrew Vagin wrote:
>
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


Acked-by: Oleg Nesterov <oleg@redhat.com>



> ---
>  kernel/pid_namespace.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index b051fa6..598bfb3 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -70,12 +70,18 @@ err_alloc:
>  	return NULL;
>  }
>
> +/* MAX_PID_NS_LEVEL is needed for limiting size of 'struct pid' */
> +#define MAX_PID_NS_LEVEL 32
> +
>  static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
>  {
>  	struct pid_namespace *ns;
>  	unsigned int level = parent_pid_ns->level + 1;
>  	int i, err = -ENOMEM;
>
> +	if (level > MAX_PID_NS_LEVEL)
> +		goto out;
> +
>  	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
>  	if (ns == NULL)
>  		goto out;
> --
> 1.7.1
>

