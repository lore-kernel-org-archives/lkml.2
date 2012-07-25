Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab2GYMMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 08:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab2GYMMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 08:12:42 -0400
Date: Wed, 25 Jul 2012 14:12:30 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 02/11] perf kvm: set name for VM process in guest machine
Message-ID: <20120725121229.GC946@krava.brq.redhat.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
 <1342826756-64663-3-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342826756-64663-3-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 05:25:47PM -0600, David Ahern wrote:
> COMM events are not generated in the context of a guest machine, so the
> thread name is never set for the VMM process. For example, the qemu-kvm
> name applies to the process in the host machine, not the guest machine.
> So, samples for guest machines are currently displayed as:
> 
>     99.67%     :5671  [unknown]         [g] 0xffffffff81366b41
> 
> where 5671 is the pid of the VMM. With this patch the samples in the guest
> machine are shown as:
> 
>     18.43%  [guest/5671]  [unknown]           [g] 0xffffffff810d68b7

Tested-by: Jiri Olsa <jolsa@redhat.com>


> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  tools/perf/util/map.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
> index a1f4e36..8668569 100644
> --- a/tools/perf/util/map.c
> +++ b/tools/perf/util/map.c
> @@ -7,6 +7,7 @@
>  #include <stdio.h>
>  #include <unistd.h>
>  #include "map.h"
> +#include "thread.h"
>  
>  const char *map_type__name[MAP__NR_TYPES] = {
>  	[MAP__FUNCTION] = "Functions",
> @@ -585,7 +586,21 @@ int machine__init(struct machine *self, const char *root_dir, pid_t pid)
>  	self->kmaps.machine = self;
>  	self->pid	    = pid;
>  	self->root_dir      = strdup(root_dir);
> -	return self->root_dir == NULL ? -ENOMEM : 0;
> +	if (self->root_dir == NULL)
> +		return -ENOMEM;
> +
> +	if (pid != HOST_KERNEL_ID) {
> +		struct thread *thread = machine__findnew_thread(self, pid);
> +		char comm[64];
> +
> +		if (thread == NULL)
> +			return -ENOMEM;
> +
> +		snprintf(comm, sizeof(comm), "[guest/%d]", pid);
> +		thread__set_comm(thread, comm);
> +	}
> +
> +	return 0;
>  }
>  
>  static void dsos__delete(struct list_head *self)
> -- 
> 1.7.10.1
> 
