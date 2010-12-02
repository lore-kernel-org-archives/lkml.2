Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150Ab0LBWco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 17:32:44 -0500
Received: from www.tglx.de ([62.245.132.106]:36028 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758069Ab0LBWcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 17:32:43 -0500
Date: Thu, 2 Dec 2010 23:32:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf: Prevent buildid collection running forever
In-Reply-To: <alpine.LFD.2.00.1012022208300.2653@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1012022323390.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012022208300.2653@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Dec 2010, Thomas Gleixner wrote:

> Collecting the buildids after a long perf run can result in running
> forever.
> 
> The reason is that the perf_ops which buildids uses are not having the
> .comm function set. Sounds weird, but the way how perf fork/mmap
> handling works explains it:
> 
> On fork the new task in perf userspace inherits the registered memory
> maps of the parent. This is almost correct (it's ignoring
> MADV_DONTFORK) for threads and forks. For new processes the extra
> "comm" event is generated which then removes the parent mappings from
> the child. The buildid code ignores the comm event and therefor the
> parents mappings are kept. When tracing e.g. a kernel compile then the
> inherited process chain can be pretty long and every child gets the
> old and partially replaced mappings of the various ancestors, which
> leads to an endless shuffling in map_groups__fixup_overlappings()
> 
> Add the default comm event for now to "fix" this.

<REMOVE THIS>

> The real fix is to transport this information at clone/fork time with
> the event, which is easy as the kernel knows it already. That would
> avoid that whole inherit/clone/remove heuristics in the postprocessing
> tools.

</REMOVE THIS>

Gah. I confused myself. Grr. commit 4385d580f2 explains the magic, but
we really should have done the explicit PERF_RECORD_EXEC or at least
made the .comm thing mandatory.

It's so fricking non obvious that the map flush happens in
thread__set_comm(). 

Yours grumpy

      tglx
