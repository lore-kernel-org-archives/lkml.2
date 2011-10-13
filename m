Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1JMHTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:19:15 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35142 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab1JMHTO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:19:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=gJwO+v10zNzFNsbzhdQv2wqNqpK67dujnVzEVRSKXJzEmrC3AByWL6DZoX/dn/E7M
	Cs+JLNw4GvwKbjp0z2vJQ==
MIME-Version: 1.0
In-Reply-To: <1318242268-2234-2-git-send-email-glommer@parallels.com>
References: <1318242268-2234-1-git-send-email-glommer@parallels.com> <1318242268-2234-2-git-send-email-glommer@parallels.com>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 13 Oct 2011 00:18:49 -0700
Message-ID: <CAHH2K0awiPZZ9EJLyZy_p_ehf0-waQ-vGUAhAZEpdCMnYqKidA@mail.gmail.com>
Subject: Re: [PATCH v6 1/8] Basic kernel memory functionality for the Memory Controller
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org,
        kirill@shutemov.name, avagin@parallels.com, devel@openvz.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 3:24 AM, Glauber Costa <glommer@parallels.com> wrote:
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 06eb6d9..bf00cd2 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
...
> @@ -255,6 +262,31 @@ When oom event notifier is registered, event will be delivered.
>   per-zone-per-cgroup LRU (cgroup's private LRU) is just guarded by
>   zone->lru_lock, it has no lock of its own.
>
> +2.7 Kernel Memory Extension (CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
> +
> + With the Kernel memory extension, the Memory Controller is able to limit

Extra leading space before 'With'.

> +the amount of kernel memory used by the system. Kernel memory is fundamentally
> +different than user memory, since it can't be swapped out, which makes it
> +possible to DoS the system by consuming too much of this precious resource.
> +Kernel memory limits are not imposed for the root cgroup.
> +
> +Memory limits as specified by the standard Memory Controller may or may not
> +take kernel memory into consideration. This is achieved through the file
> +memory.independent_kmem_limit. A Value different than 0 will allow for kernel

s/Value/value/

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 3508777..d25c5cb 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
...
> +static int kmem_limit_independent_write(struct cgroup *cont, struct cftype *cft,
> +                                       u64 val)
> +{
> +       cgroup_lock();
> +       mem_cgroup_from_cont(cont)->kmem_independent_accounting = !!val;
> +       cgroup_unlock();

I do not think cgroup_lock,unlock are needed here.  The cont and
associated cgroup should be guaranteed by the caller to be valid.
Does this lock provide some other synchronization?
