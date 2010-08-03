Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab0HCTp6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 15:45:58 -0400
Received: from mail.openrapids.net ([64.15.138.104]:42737 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757516Ab0HCTp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 15:45:56 -0400
Date: Tue, 3 Aug 2010 15:45:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100803194553.GA27688@Krystal>
References: <20100714193652.GA13630@nowhere> <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com> <20100714221418.GA14533@nowhere> <20100714223107.GA2350@Krystal> <20100714224853.GC14533@nowhere> <20100714231117.GA22341@Krystal> <20100714233843.GD14533@nowhere> <20100715162631.GB30989@Krystal> <1280855904.1923.675.camel@laptop> <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinydcsYG6wj06bj0++EfiWUMQnZk=QvLQp=S8YB@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 15:27:19 up 192 days, 22:04,  7 users,  load average: 0.07, 0.05,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Tue, Aug 3, 2010 at 10:18 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > FWIW I really utterly detest the whole concept of sub-buffers.
> 
> I'm not quite sure why. Is it something fundamental, or just an
> implementation issue?

The real issue here, IMHO, is that Perf has tied gory ring buffer implementation
details to the userspace perf ABI, and there is now strong unwillingness from
Perf developers to break this ABI.

About the sub-buffer definition: it only means that a buffer is splitted into
many regions. Their boundary are synchronization points between the data
producer and consumer. This involves padding the end of regions when records do
not fit in the remaining space.

I think that the problem lays in that Peter wants all his ring-buffer data to be
side-to-side, without padding. He needs this because the perf ABI, presented to
the user-space perf program, requires this: every implementation detail is
exposed to user-space through a mmap'd memory region (yeah, even the control
data is touched by both the kernel and userland through that shared page).

When Perf has been initially proposed, I've thought that because the perf
user-space tool is shipped along with the kernel sources, we could change the
ABI easily afterward, but Peter seems to disagree and wants it to stay the as it
is for backward compatibility and not offending contributors. If I had known
this when the ABI first came in, I would have surely nack'd it.

Now we are stucked with this ABI which exposes every tiny ring buffer
implementation detail to userspace, which simply kills any future enhancement.

Thanks,

Mathieu

P.S.: I'm holding back reply to the rest of your email to increase focus on the
fundamental perf ABI problem.

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
