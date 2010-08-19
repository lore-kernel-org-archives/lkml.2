Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0HSIwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:52:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:10737 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964Ab0HSIwg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:52:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,232,1280732400"; 
   d="scan'208";a="829658621"
Subject: Re: hackbench regression with 2.6.36-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>, alex.shi@intel.com,
        Pavel Emelyanov <xemul@openvz.org>,
        "David S. Miller" <davem@davemloft.net>
In-Reply-To: <m1lj842nph.fsf@fess.ebiederm.org>
References: <1282112318.21202.8.camel@ymzhang.sh.intel.com>
	 <m1lj842nph.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 19 Aug 2010 16:54:20 +0800
Message-Id: <1282208060.2182.34.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 03:56 -0700, Eric W. Biederman wrote:
> "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> writes:
> 
> > Comparing with 2.6.35's result, hackbench (thread mode) has about
> > 80% regression on dual-socket Nehalem machine and about 90% regression
> > on 4-socket Tigerton machines.
> 
> That seems unfortunate.  

> Do you only show a regression in the pthread
> hackbench test?
Yes.

>   Do you show a regression when you use pipes?
No.

> 
> Does the size of the regression very based on the number of loop
> iterations?
No. I tried 1000 and get the similar regression ratio.
I choose a large 2000 loop number because I want to get a stable result.

It's easy to reproduce it. We found it almost on all our machines.

>   I ask because it appears that on the last message the
> sender will exit necessitating that the receiver put the senders pid.
> Which should be atypical.
I don't agree on that. With hackbench, sender would send loops*receiver_num_per_group
messages before exiting.
In addition, 'perf top' shows put_pid is the hottest function in the beginning
after I start hackbench. 

> 
> > Command to start hackbench:
> > #./hackbench 100 thread 2000
> >
> > process mode has no such regression.
> >
> > Profiling shows:
> > #perf top
> >              samples  pcnt function                 DSO
> >              _______ _____ ________________________ ________________________
> >
> >             74415.00 29.9% put_pid                  [kernel.kallsyms]       
> >             38395.00 15.4% unix_stream_recvmsg      [kernel.kallsyms]       
> >             34877.00 14.0% unix_stream_sendmsg      [kernel.kallsyms]       
> >             25204.00 10.1% pid_vnr                  [kernel.kallsyms]       
> >             21864.00  8.8% unix_scm_to_skb          [kernel.kallsyms]       
> >             13637.00  5.5% cred_to_ucred            [kernel.kallsyms]       
> >              6520.00  2.6% unix_destruct_scm        [kernel.kallsyms]       
> >              4731.00  1.9% sock_alloc_send_pskb     [kernel.kallsyms]       
> >
> >
> > With 2.6.35, perf doesn't show put_pid/pid_NR.
> 
> Yes.  2.6.35 is imperfect and can report the wrong pid in some
> circumstances.  I am surprised nothing related to the reference count on
> struct cred does not show up in your profiling traces.
> 

> You are performing statistical sampling so I don't believe the
> percentage of hits per function is the same as the percentage of
> time per function.
Agree. But from performance tuning point of view, percentage of hit is enough
for helping developers to investigate.

I provide 'perf top' data is to help you debug, not to prove your patches
cause the regression. We used bisect to locate them.

> 
> Given that we are talking about a scheduler benchmark that is
> doing something rather artificial (inter thread communication via
> sockets), I don't know that this case is worth worrying about.
Good question. I don't know how about below scenario:
Start 2 processes and every process creates many threads. threads of process 1
communicates with threads of process 2.

> 
> > Alex Shi and I did a quick bisect and located below 2 patches.
> 
> That is a plausible result.  

> The atomic reference counts may
> be causing you to ping pong cache lines between cpus.
Agree.


