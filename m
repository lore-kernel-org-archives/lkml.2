Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab0C3QuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 12:50:05 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36957 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0C3QuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 12:50:03 -0400
Message-ID: <4BB22BB0.8030208@linux.vnet.ibm.com>
Date: Tue, 30 Mar 2010 09:49:52 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Dan Terpstra <terpstra@eecs.utk.edu>, Philip Mucci <mucci@eecs.utk.edu>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC] perf_events: support for uncore a.k.a. nest units
References: <4B560ACD.4040206@linux.vnet.ibm.com> <d3f22a1003290213x7d7904an59d50eb6a8616133@mail.gmail.com> <1269934931.8575.6.camel@minggr.sh.intel.com>
In-Reply-To: <1269934931.8575.6.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 12:42 AM, Lin Ming wrote:
> Hi, Corey
>
> How is this going now? Are you still working on this?
> I'd like to help to add support for uncore, test, write code or anything
> else.
>
> Thanks,
> Lin Ming

I haven't been actively working on adding infrastructure for nest PMUs 
yet.  At the moment we are working on supporting nest events for IBM's 
Wire-Speed processor, using the current infrastructure, because of the 
time limitations.  Using the existing infrastructure is definitely not 
ideal, but for this processor, it's workable.

There are still a lot of issues to solve for adding this infrastructure:

1) Does perf_events need a new context type (in addition to per-task and 
per-cpu)?  This is partly because we don't want to be mixing the 
rotation of CPU-events with nest events.  Each PMU really ought to have 
its own event list.

2) How do we deal with accessing PMU's which require slow access methods 
(e.g. internal serial bus)?  The accesses may need to be placed on 
worker threads so that they don't affect the performance of context 
switches and system ticks.

3) How exactly do we represent the PMU's in the pseudofs (/sys or 
/proc)?  And how exactly does the user specify the PMU to perf_events?
Peter Zijlstra and Stephane Eranian both recommended opening the PMU 
with open() and then passing the resulting fd in through the 
perf_event_attr struct.

4) How do we choose a CPU to do the housekeeping work for a particular 
nest PMU.  Peter thought that user space should still specify the it via 
open_perf_event() cpu parameter, but there's also an argument to be made 
for the kernel choosing the best CPU to handle the job, or at least make 
it optional for the user to choose the CPU.

I'm sure there are other issues as well.  If you'd like to start working 
on some (or all!) of these, you are more than welcome to.  I think we 
need to toss around some more ideas before committing much to code at 
this point.

- Corey
