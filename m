Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187Ab0IUJip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 05:38:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab0IUJio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 05:38:44 -0400
Subject: Re: [RFC PATCH 0/2] perf_events: add support for per-cpu
 per-cgroup monitoring (v3)
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
        davem@davemloft.net, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
        eranian@gmail.com, robert.richter@amd.com, acme@redhat.com,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
References: <4c88dc9c.991ce30a.3d91.3e0e@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Sep 2010 11:38:19 +0200
Message-ID: <1285061899.2275.824.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 15:05 +0200, Stephane Eranian wrote:
> The cgroup to monitor is designated by passing a file descriptor opened
> on a new per-cgroup file in the cgroup filesystem (perf_event.perf). The
> option must be activated by setting perf_event_attr.cgroup=1 and passing
> a valid file descriptor in perf_event_attr.cgroup_fd. Those are the only
> two ABI extensions. 

> +++ b/include/linux/perf_event.h
> @@ -215,8 +215,9 @@ struct perf_event_attr {
>                                  */
>                                 precise_ip     :  2, /* skid constraint       */
>                                 mmap_data      :  1, /* non-exec mmap data    */
> +                               cgroup         :  1, /* cgroup aggregation    */
>  
> -                               __reserved_1   : 46;
> +                               __reserved_1   : 45;
>  
>         union {
>                 __u32           wakeup_events;    /* wakeup every n events */
> @@ -226,6 +227,8 @@ struct perf_event_attr {
>         __u32                   bp_type;
>         __u64                   bp_addr;
>         __u64                   bp_len;
> +
> +       int                     cgroup_fd;
>  };
>  
>  /*

I'm not sure I like this much.. so we attach to {pid,cpu}, for nodes we
can use cpu_to_node(cpu), which would suggest to use
cgroup_of_task(pid), except that a task can be part of multiple cgroups,
so its not unique.

One thing we could do is pass this cgroup identifier in the pid field
and use PERF_FLAG_CGROUP or something. Currently the syscall signature
uses pid_t, but I think we can safely change that to int.

You create a special new file in the cgroup stuff, I'm not sure about
that either, but its not something I feel too strongly about, why
wouldn't a fd of any file or even directory of that cgroup work? Do the
cgroup people have an opinion?
