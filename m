Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2FMNZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 09:25:56 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:59061 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688Ab2FMNZz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 09:25:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120613132354.GC2538@m.brq.redhat.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
	<1339420814-7379-3-git-send-email-jolsa@redhat.com>
	<CABPqkBRsBegm6gv6agHcGb0Hh1EWCV5gjVnbbwPHh-eOfROCuw@mail.gmail.com>
	<20120613131240.GB2538@m.brq.redhat.com>
	<CABPqkBRdVMzocJu_SJbU81wg6Ef=KgbXw-18tb+bZEon79fVDA@mail.gmail.com>
	<20120613132354.GC2538@m.brq.redhat.com>
Date: Wed, 13 Jun 2012 15:25:53 +0200
Message-ID: <CABPqkBTqZjqtzikJJvX+ppiR3E=u0gfAXk0=EGhAMDdA8EiMqA@mail.gmail.com>
Subject: Re: [PATCH 02/19] perf: Add ability to attach user level registers
 dump to sample
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, gorcunov@openvz.org,
        tzanussi@gmail.com, mhiramat@redhat.com, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com, asharma@fb.com,
        benjamin.redelings@nescent.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 3:23 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Wed, Jun 13, 2012 at 03:18:54PM +0200, Stephane Eranian wrote:
>> On Wed, Jun 13, 2012 at 3:12 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> > On Wed, Jun 13, 2012 at 01:16:44PM +0200, Stephane Eranian wrote:
>> >> On Mon, Jun 11, 2012 at 3:19 PM, Jiri Olsa <jolsa@redhat.com> wrote:
>> >> > Introducing sample_regs_user bitmask into perf_event_attr
>> >> > struct to define the user level registers we want to attach
>> >> > to the sample. The dump itself is triggered once the
>> >> > sample_regs_user is not empty.
>> >> >
>> >> > Only user level registers are dump at the moment. Meaning the
>> >> > register values of the user space context as it was before the
>> >> > user entered the kernel for whatever reason (syscall, irq,
>> >> > exception, or a PMI happening in userspace).
>> >> >
>> >> > The layout of the sample_regs_user bitmap is described in
>> >> > asm/perf_regs.h for archs that support register dump.
>> >> >
>> >> > This is going to be useful to bring Dwarf CFI based stack
>> >> > unwinding on top of samples.
>> >> >
>> >> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> >> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
>> >> > ---
>> >> >  include/linux/perf_event.h |   10 ++++++-
>> >> >  kernel/events/core.c       |   61 ++++++++++++++++++++++++++++++++++++++++++++
>> >> >  2 files changed, 70 insertions(+), 1 deletions(-)
>> >> >
>> >> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
>> >> > index 1ce887a..d66cbeb 100644
>> >> > --- a/include/linux/perf_event.h
>> >> > +++ b/include/linux/perf_event.h
>> >> > @@ -271,7 +271,13 @@ struct perf_event_attr {
>> >> >                __u64           bp_len;
>> >> >                __u64           config2; /* extension of config1 */
>> >> >        };
>> >> > -       __u64   branch_sample_type; /* enum branch_sample_type */
>> >> > +       __u64   branch_sample_type; /* enum perf_branch_sample_type */
>> >> > +
>> >> > +       /*
>> >> > +        * Defines set of user regs to dump on samples.
>> >> > +        * See asm/perf_regs.h for details.
>> >> > +        */
>> >> > +       __u64   sample_regs_user;
>> >> >  };
>> >> That's not enough. You also need to define PERF_SAMPLE_USER_REGS
>> >> for sample_type. Although the sample_regs_users might look like it's enough
>> >> to capture regs, there is a problem when it comes to parsing the record. You
>> >> need an ordering guarantee that is explicitly spelled out in the API (the header
>> >> file). In your current patch, I have no way of knowing that sample_regs_users
>> >> are saved after BRANCH_STACK (should you have that enabled). Remember
>> >> that you can turn on/off sampled infos at will in sample_type. Yet to find the
>> >> infos when parsing, you need to know the order.
>> >
>> > Well, the sample_regs_user != 0 substitute the PERF_SAMPLE_USER_REGS bit.
>> > The behaviour is the same as if there was that bit defined..
>> >
>> No it's not the same.  Looking at sample_regs_user != 0, do you know in which
>> order the regs array is going to appear RELATIVE to the other captured
>> information?
>>
>> Take sample_type = IP|CPU|PERIOD, sample_regs_users = EAX
>>
>> Now, I get the raw record, want to parse it. Which comes first the user_regs
>> or the IP, CPU, PERIOD?
>>
>> Worst, I add more entries to PERF_SAMPLE_*, are they laid out before or
>> after the regs?
>
> after.. but only because I know that.. yep, I think you're right,
> we should track it in the sample_type enum.. I'll add those 2 bits
>
Good thanks.

> jirka
