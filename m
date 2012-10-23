Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab2JWX5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:57:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933579Ab2JWX45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:56:57 -0400
Date: Tue, 23 Oct 2012 16:56:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] pidns: limit the nesting depth of pid namespaces
Message-Id: <20121023165651.88af399d.akpm@linux-foundation.org>
In-Reply-To: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
References: <1350045042-1369134-1-git-send-email-avagin@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012 16:30:42 +0400
Andrew Vagin <avagin@openvz.org> wrote:

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

hm, OK.  This will kind-of fix the free_pid_ns()-excessive-recursion
issue which we already fixed by other means ;)

I don't think this problem is serious enough to bother backporting into
-stable but I guess we can/should do it in 3.7.  Agree?

I think that returning -ENOMEM in response to an excessive nesting
attempt is misleading - the system *didn't* run out of memory.  EINVAL
is better?



From: Andrew Morton <akpm@linux-foundation.org>
Subject: pidns-limit-the-nesting-depth-of-pid-namespaces-fix

return -EINVAL in response to excessive nesting, not -ENOMEM

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid_namespace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces-fix kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-limit-the-nesting-depth-of-pid-namespaces-fix
+++ a/kernel/pid_namespace.c
@@ -78,11 +78,15 @@ static struct pid_namespace *create_pid_
 {
 	struct pid_namespace *ns;
 	unsigned int level = parent_pid_ns->level + 1;
-	int i, err = -ENOMEM;
+	int i;
+	int err;
 
-	if (level > MAX_PID_NS_LEVEL)
+	if (level > MAX_PID_NS_LEVEL) {
+		err = -EINVAL;
 		goto out;
+	}
 
+	err = -ENOMEM;
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
_

