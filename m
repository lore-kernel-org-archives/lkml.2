Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2F2HvI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 03:51:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714Ab2F2HvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 03:51:07 -0400
Date: Fri, 29 Jun 2012 09:50:43 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 03/23] perf: Add ability to attach user level registers
 dump to sample
Message-ID: <20120629075043.GD940@krava.brq.redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
 <1340120894-9465-4-git-send-email-jolsa@redhat.com>
 <20120627151059.GG20638@somewhere.redhat.com>
 <CABPqkBTdL7rt4YF1SYdo4N7BaK3TOvXJqfs3Te2Asmm_-jA_Ag@mail.gmail.com>
 <20120627152359.GI20638@somewhere.redhat.com>
 <1340810729.10063.66.camel@twins>
 <20120627153002.GJ20638@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627153002.GJ20638@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 05:30:05PM +0200, Frederic Weisbecker wrote:
> On Wed, Jun 27, 2012 at 05:25:29PM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-06-27 at 17:24 +0200, Frederic Weisbecker wrote:
> > > On Wed, Jun 27, 2012 at 05:13:44PM +0200, Stephane Eranian wrote:
> > > > On Wed, Jun 27, 2012 at 5:11 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > > > On Tue, Jun 19, 2012 at 05:47:54PM +0200, Jiri Olsa wrote:
> > > > >> @@ -4061,6 +4105,19 @@ void perf_prepare_sample(struct perf_event_header *header,
> > > > >>               }
> > > > >>               header->size += size;
> > > > >>       }
> > > > >> +
> > > > >> +     if (sample_type & PERF_SAMPLE_REGS_USER) {
> > > > >> +             /* regs dump available bool */
> > > > >> +             int size = sizeof(u64);
> > > > >> +
> > > > >> +             data->regs_user = perf_sample_regs_user(regs);
> > > > >> +             if (data->regs_user) {
> > > > >> +                     u64 mask = event->attr.sample_regs_user;
> > > > >> +                     size += hweight64(mask) * sizeof(u64);
> > > > >> +             }
> > > > >> +
> > > > >> +             header->size += size;
> > > > >
> > > > > We'll need to remove the 64 bits registers for compat tasks but other than
> > > > > that, it looks ok.
> > > > You cannot do this. You cannot remove register values from under the hood.
> > > > The only way the user has to parse the sample is the sample_regs_users bitmask.
> > > > You have to return 0 for those unexisting regs for compat tasks.
> > > 
> > > You mean fill unexisting reg values with 0? Yeah that works.
> > 
> > What does x32 look like? Is that still reported as a compat task? If so,
> > we should record all registers and not 0 out anything.
> 
> To make it simple, we could always use the x86-64 registers mask interface for everyone:
> native 32 bits kernel, compat 32 bits task, 64 bits everything. And we can't fill an x86-64
> value because we are dealing with a native/compat 32 task we just fill out the requested value
> with 0.
> 
> On post processing time, userspace can know if it's dealing with 32 bits task or not anyway, so
> it knows what to skip and what is relevant.

well, thats basically what we have now..

when the kernel is compiled for 32 bits, the bitmask allows to store:

ax, bx, cx, dx, si, di, bp, sp, ip, flags, cs, ds, es, fs, gs, ss

and when  kernel is compiled for 64 bits, the bitmask adds 64bit stuff:

ax, bx, cx, dx, si, di, bp, sp, ip, flags, cs, ds, es, fs, gs, ss
r8, r9, r10, r11, r12, r13, r14, r15


- 32 bits kernel is straightforward

- for 64 bits kernel we store whatever bitmask instructs to,
  regardless if we are in compat task or native 64,
  user space will deal with that in post processing


jirka
