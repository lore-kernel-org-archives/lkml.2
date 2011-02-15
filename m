Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab1BOSjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:39:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1BOSjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:39:44 -0500
Date: Tue, 15 Feb 2011 19:30:28 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xemul@openvz.org, sukadev@us.ibm.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 1/2] pidns: Don't allow new pids after the namespace is
	dead.
Message-ID: <20110215183028.GA15568@redhat.com>
References: <1297788824-20534-1-git-send-email-daniel.lezcano@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297788824-20534-1-git-send-email-daniel.lezcano@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Daniel Lezcano wrote:
>
> In the case of unsharing or joining a pid namespace, it becomes
> possible to attempt to allocate a pid after zap_pid_namespace has
> killed everything in the namespace.  Close the hole for now by simply
> not allowing any of those pid allocations to succeed.

Daniel, please explain more. It seems, a long ago I knew the reason
for this patch, but now I can't recall and can't understand this change.

> --- a/include/linux/pid_namespace.h
> +++ b/include/linux/pid_namespace.h
> @@ -20,6 +20,7 @@ struct pid_namespace {
>  	struct kref kref;
>  	struct pidmap pidmap[PIDMAP_ENTRIES];
>  	int last_pid;
> +	atomic_t dead;

Why atomic_t? It is used as a plain boolean.

And I can't unde

> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -282,6 +282,10 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>  	struct pid_namespace *tmp;
>  	struct upid *upid;
>  
> +	pid = NULL;
> +	if (atomic_read(&ns->dead))
> +		goto out;
> +

So why this is needed?

If we see ns->dead != 0 we are already killed by zap_pid_ns_processes()
which sets ns->dead = 1.

Oleg.

