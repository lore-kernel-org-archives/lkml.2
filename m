Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2HTJ4I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab2HTJ4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:56:05 -0400
Date: Mon, 20 Aug 2012 11:55:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] perf, x86: Making hardware events translations
 available in sysfs
Message-ID: <20120820095539.GA1176@krava.brq.redhat.com>
References: <1341866270-4915-1-git-send-email-jolsa@redhat.com>
 <1341866270-4915-2-git-send-email-jolsa@redhat.com>
 <CABPqkBQ7ZFw2c706JwvMVq1i1LCGo4108MCvynMqpXkPCbk39g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ7ZFw2c706JwvMVq1i1LCGo4108MCvynMqpXkPCbk39g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:25:42AM +0200, Stephane Eranian wrote:
> On Mon, Jul 9, 2012 at 10:37 PM, Jiri Olsa <jolsa@redhat.com> wrote:

SNIP

> > +static ssize_t event_sysfs_data(char *page, u64 config)
> > +{
> > +       u64 event  = (config & ARCH_PERFMON_EVENTSEL_EVENT) |
> > +                    (config & AMD64_EVENTSEL_EVENT) >> 24;
> > +       u64 umask  = (config & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
> > +       u64 inv    = (config & ARCH_PERFMON_EVENTSEL_INV) >> 23;
> > +       u64 cmask  = (config & ARCH_PERFMON_EVENTSEL_CMASK) >> 24;
> > +       ssize_t ret;
> > +
> > +       /*
> > +        * We have whole page size to spend and just little data
> > +        * to write, so we can safely use sprintf.
> > +        */
> > +       ret = sprintf(page, "event=0x%02llx", event);
> > +
> > +       if (umask)
> > +               ret += sprintf(page + ret, ",umask=0x%02llx", umask);
> > +
> > +       if (inv)
> > +               ret += sprintf(page + ret, ",inv");
> > +
> > +       if (cmask)
> > +               ret += sprintf(page + ret, ",cmask=0x%02llx", cmask);
> > +
> 
> You are not handling the model specific modifiers such as any_thread on Intel.
> It's not used right now. But you should handle the case now. That will avoid
> problems in the future.

ok, will add those

> 
> > +       ret += sprintf(page + ret, "\n");
> > +
> > +       return ret;
> > +}

SNIP

> >  static const struct attribute_group *x86_pmu_attr_groups[] = {
> >         &x86_pmu_attr_group,
> >         &x86_pmu_format_group,
> > +       &x86_pmu_events_group,
> >         NULL,
> >  };
> >
> You are not checking whether or not the generic event is even available on the
> host core PMU. You don't want to expose generic events which are not available.

thats what patch 2 does

> And if you do this, then you need to take care of the other arch as well. They
> also deserve the extended syntax.

hm, I could try to add something for ppc, but that's where my arch
hw availability ends

thanks,
jirka
