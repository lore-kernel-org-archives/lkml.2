Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab0JNJU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:20:27 -0400
Received: from canuck.infradead.org ([134.117.69.58]:49994 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab0JNJUX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:20:23 -0400
Subject: Re: [PATCH v3 2/7] sched: accumulate per-cfs_rq cpu usage
From: Peter Zijlstra <peterz@infradead.org>
To: bharata@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
        Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
        Mike Waychison <mikew@google.com>, Paul Turner <pjt@google.com>,
        Nikhil Rao <ncrao@google.com>
In-Reply-To: <20101012075109.GC9893@in.ibm.com>
References: <20101012074910.GA9893@in.ibm.com>
	 <20101012075109.GC9893@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 11:19:56 +0200
Message-ID: <1287047996.29097.173.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-12 at 13:21 +0530, Bharata B Rao wrote:
> +#ifdef CONFIG_CFS_BANDWIDTH
> +       {
> +               .procname       = "sched_cfs_bandwidth_slice_us",
> +               .data           = &sysctl_sched_cfs_bandwidth_slice,
> +               .maxlen         = sizeof(unsigned int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &one,
> +       },
> +#endif 

So this is basically your scalability knob.. the larger this value less
less frequent we have to access global state, but the less parallelism
is possible due to fewer CPUs depleting the total quota, leaving nothing
for the others.

I guess one could go try and play load-balancer games to try and
mitigate this by pulling this group's tasks to the CPU(s) that have move
bandwidth for that group, but balancing that against the regular
load-balancer goal of well balancing load, will undoubtedly be
'interesting'...


