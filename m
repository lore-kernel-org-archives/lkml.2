Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab0GNUR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:17:57 -0400
Received: from mail.openrapids.net ([64.15.138.104]:40737 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757516Ab0GNURz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:17:55 -0400
Date: Wed, 14 Jul 2010 16:17:53 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20100714201753.GB22096@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.049012415@efficios.com> <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <20100714193652.GA13630@nowhere> <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 16:11:59 up 172 days, 22:48,  6 users,  load average: 0.04, 0.06,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Wed, Jul 14, 2010 at 12:36 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> >
> > There is also the fact we need to handle the lost NMI, by defering its
> > treatment or so. That adds even more complexity.
> 
> I don't think your read my proposal very deeply. It already handles
> them by taking a fault on the iret of the first one (that's why we
> point to the stack frame - so that we can corrupt it and force a
> fault).

It only handles the case of a single NMI coming in. What happens in this
scenario?

- NMI (1) comes in.
- takes a fault
    - iret
- NMI (2) comes in.
  - nesting detected, popf/ret
- takes another fault
- NMI (3) comes in.
  - nesting detected, popf/ret
- iret faults
  - executes only one extra NMI handler

We miss NMI (3) here. I think this is an important change from a semantic where,
AFAIK, the hardware should be allowed to assume that the CPU will execute as
many nmi handlers are there are NMIs acknowledged.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
