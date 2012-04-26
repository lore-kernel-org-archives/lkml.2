Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758238Ab2DZQGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 12:06:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872Ab2DZQGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 12:06:44 -0400
Date: Thu, 26 Apr 2012 17:28:40 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, rostedt@goodmis.org,
        robert.richter@amd.com, fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com
Subject: Re: [PATCH 02/16] perf: Unified API to record selective sets of arch
 registers
Message-ID: <20120426152840.GC1659@m.brq.redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
 <1334661441-4420-3-git-send-email-jolsa@redhat.com>
 <CABPqkBRqG5WhWYY5viVW3j89WUrpmkk1j7VA=oUhY_TGXg=14g@mail.gmail.com>
 <20120423103350.GB1720@m.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423103350.GB1720@m.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 12:33:50PM +0200, Jiri Olsa wrote:
> On Mon, Apr 23, 2012 at 12:10:57PM +0200, Stephane Eranian wrote:
> > On Tue, Apr 17, 2012 at 1:17 PM, Jiri Olsa <jolsa@redhat.com> wrote:

SNIP

> > How are you going to deal with 32-bit binaries sampled on a 64-bit system?
> 
> I dont have the solution right now... but seems like compat tasks need more
> thinking even before go ahead with this patchset.. since it's going affect
> the perf_event_attr and could bite us in future.
hi,
got more info on the compat task unwind

- for 32 bit task running under 64 bit env. the 64 bits user
  registers values are stored on kernel stack when entering
  the kernel via exception or interrupt, like for native
  64 bit task

  So I think we can keep the current interface as far as
  compat tasks are concerned, since we will get 64 bits
  registers all the time anyway.

  The place that will take care of compat task unwind
  is the post processing unwind.

  For each processed sample we:
     - get the sample and translate IP into MAP and DSO
     - read DSO ELF class and figure out wether we deal with
       64 or 32 bit task
     - run libunwind interface with proper task class info,
       which gets us to next bullet:

- 64 bit libunwind does not support unwind of 32 bit tasks ;)
  so unless that change, I can see just one hacky way of doing
  this via 32 bit libunwind being loaded in separate 32 bit
  process and doing remote unwind for us..

  I'll try to follow on this to see if there'd be some better
  libunwind interface solution.. but thats quite longterm ;)


As for the sample registers interface.

Currently we have:

  u64 user_sample_regs
  - if != 0 we provide the user registers with mask specified
    by its value

  - it will stay for compat tasks as well
  - we could use PERF_SAMPLE_USER_REGS sample type instead of the != 0
    check to be more consistent, but that would eat up one sample bit
    unnecessary

In some previous email you suggested some generic interface like

    attr->sample_type |= PERF_SAMPLE_REGS
    attr->sample_regs = EAX | EBX | EDI | ESI |.....
    attr->sample_reg_mode = { INTR, PRECISE, USER }

I think we can have something like:

    attr->sample_type |= PERF_SAMPLE_REGS
    attr->sample_reg_mode = { INTR, PRECISE, USER }

but in case we want eg both USER and INTR modes together then we still
need to have:

  u64 user_sample_regs
  u64 intr_sample_regs
  ...

for the register modes mask definition. Some mode combinations might be
useless, but I think this could work.. we could always customize our
needs with new mode ;)

I'll start to work on this unless I hear some screaming ;)

thoughts? ;)


thanks and sorry for long email,
jirka
