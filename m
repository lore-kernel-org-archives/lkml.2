Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab2DWKeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:34:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab2DWKeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:34:18 -0400
Date: Mon, 23 Apr 2012 12:33:50 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com
Subject: Re: [PATCH 02/16] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120423103350.GB1720@m.brq.redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
 <1334661441-4420-3-git-send-email-jolsa@redhat.com>
 <CABPqkBRqG5WhWYY5viVW3j89WUrpmkk1j7VA=oUhY_TGXg=14g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABPqkBRqG5WhWYY5viVW3j89WUrpmkk1j7VA=oUhY_TGXg=14g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 12:10:57PM +0200, Stephane Eranian wrote:
> On Tue, Apr 17, 2012 at 1:17 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> > This brings a new API to help the selective dump of registers on
> > event sampling, and its implementation in x86.
> >
> > - The informations about the desired registers will be passed
> >  to a single u64 mask. It's up to the architecture to map the
> >  registers into the mask bits.
> >
> > - The architecture must provide a non-zero and unique id to
> >  identify the origin of a register set because interpreting a
> >  register dump requires to know from which architecture it comes.
> >  The achitecture is considered different between the 32 and 64 bits
> >  version. x86-32 has the id 1, x86-64 has the id 2.
> >
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  arch/x86/include/asm/perf_regs.h    |   16 ++++++
> >  arch/x86/include/asm/perf_regs_32.h |   84 +++++++++++++++++++++++++++++
> >  arch/x86/include/asm/perf_regs_64.h |  101 +++++++++++++++++++++++++++++++++++
> >  include/asm-generic/perf_regs.h     |   23 ++++++++
> >  4 files changed, 224 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/x86/include/asm/perf_regs.h
> >  create mode 100644 arch/x86/include/asm/perf_regs_32.h
> >  create mode 100644 arch/x86/include/asm/perf_regs_64.h
> >  create mode 100644 include/asm-generic/perf_regs.h
> >
> > diff --git a/arch/x86/include/asm/perf_regs.h b/arch/x86/include/asm/perf_regs.h
> > new file mode 100644
> > index 0000000..80b7fbe
> > --- /dev/null
> > +++ b/arch/x86/include/asm/perf_regs.h
> > @@ -0,0 +1,16 @@
> > +#ifndef _ASM_X86_PERF_REGS_H
> > +#define _ASM_X86_PERF_REGS_H
> > +
> > +enum {
> > +       PERF_REGS_VERSION_NONE   = 0UL,
> > +       PERF_REGS_VERSION_X86_32 = 1UL,
> > +       PERF_REGS_VERSION_X86_64 = 2UL,
> > +};
> > +
> I don't really like the term VERSION here. It's not a versioning
> problem you're trying to solve. It's an ABI problem, unless I am
> mistaken. You should rename to PERF_REGS_ABI_X86_32 and
> PERF_REGS_ABI_X86_64.
> 
> I assume the NONE is here to cover the case where you don't
> have a user machine state, i.e., hit a kernel thread. Is that right?

right

> 
> 
> > +#ifdef CONFIG_X86_32
> > +#include "perf_regs_32.h"
> > +#else
> > +#include "perf_regs_64.h"
> > +#endif
> > +
> How are you going to deal with 32-bit binaries sampled on a 64-bit system?

I dont have the solution right now... but seems like compat tasks need more
thinking even before go ahead with this patchset.. since it's going affect
the perf_event_attr and could bite us in future.

I'll see what I can do about that and send out new patchset

jirka
