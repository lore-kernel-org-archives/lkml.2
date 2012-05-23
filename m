Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab2EWLrG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 07:47:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab2EWLqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 07:46:50 -0400
Date: Wed, 23 May 2012 13:45:55 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        acme@redhat.com, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com
Subject: Re: [PATCH 02/17] perf: Add ability to attach registers dump to
 sample
Message-ID: <20120523114555.GD1638@m.brq.redhat.com>
References: <1335958638-5160-1-git-send-email-jolsa@redhat.com>
 <1335958638-5160-3-git-send-email-jolsa@redhat.com>
 <20120521130332.GB23687@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521130332.GB23687@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 03:03:35PM +0200, Frederic Weisbecker wrote:
> On Wed, May 02, 2012 at 01:37:03PM +0200, Jiri Olsa wrote:
> > Introducing new sample_type bit PERF_SAMPLE_REGS. Once set,

SNIP

> > diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> > index ddbb6a9..6a8c974 100644
> > --- a/include/linux/perf_event.h
> > +++ b/include/linux/perf_event.h
> > @@ -130,8 +130,9 @@ enum perf_event_sample_format {
> >  	PERF_SAMPLE_STREAM_ID			= 1U << 9,
> >  	PERF_SAMPLE_RAW				= 1U << 10,
> >  	PERF_SAMPLE_BRANCH_STACK		= 1U << 11,
> > +	PERF_SAMPLE_REGS			= 1U << 12,
> 
> Given that we have to provide a reg mask anyway, is this sample type
> necessary? Zeroed mask means we don't want to record regs.

we could do that.. but the idea was to be more generic than that,
following same style as for other features


> 
> >  
> > -	PERF_SAMPLE_MAX = 1U << 12,		/* non-ABI */
> > +	PERF_SAMPLE_MAX = 1U << 13,		/* non-ABI */
> >  };
> >  
> >  /*
> > @@ -163,6 +164,15 @@ enum perf_branch_sample_type {
> >  	 PERF_SAMPLE_BRANCH_HV)
> >  
> >  /*
> > + * Values for sample_regs when PERF_SAMPLE_REGS is set.
> > + * Defines register set to be attached to the sample.
> > + */
> > +enum perf_sample_regs {
> > +	PERF_SAMPLE_REGS_USER	= 1U << 0, /* user registers */
> > +	PERF_SAMPLE_REGS_MAX	= 1U << 1, /* non-ABI */
> > +};
> 
> If this is an enum, we won't be able to record multiple types of regs
> (eg: user regs and event live regs) in a single sample.

it's bits definition.. just the first one ;)
I followed the perf_event.h style with bit definitions, like:

enum perf_event_sample_format {
        PERF_SAMPLE_IP                          = 1U << 0,
        PERF_SAMPLE_TID                         = 1U << 1,
        PERF_SAMPLE_TIME                        = 1U << 2,
        PERF_SAMPLE_ADDR                        = 1U << 3,
        PERF_SAMPLE_READ                        = 1U << 4,
        PERF_SAMPLE_CALLCHAIN                   = 1U << 5,
        PERF_SAMPLE_ID                          = 1U << 6,
        PERF_SAMPLE_CPU                         = 1U << 7,
        PERF_SAMPLE_PERIOD                      = 1U << 8,
        PERF_SAMPLE_STREAM_ID                   = 1U << 9,
        PERF_SAMPLE_RAW                         = 1U << 10,
        PERF_SAMPLE_BRANCH_STACK                = 1U << 11,

        PERF_SAMPLE_MAX = 1U << 12,             /* non-ABI */
};


> 
> > +
> > +/*
> >   * The format of the data returned by read() on a perf event fd,
> >   * as specified by attr.read_format:
> >   *
> > @@ -271,7 +281,16 @@ struct perf_event_attr {
> >  		__u64		bp_len;
> >  		__u64		config2; /* extension of config1 */
> >  	};
> > -	__u64	branch_sample_type; /* enum branch_sample_type */
> > +	__u64	branch_sample_type; /* enum perf_branch_sample_type */
> > +
> > +	__u64	sample_regs; /* enum perf_sample_regs */
> > +
> > +	/*
> > +	 * Arch specific mask for PERF_SAMPLE_REGS_USER setup.
> > +	 * Defines set of user regs to dump on samples.
> > +	 * See asm/perf_regs.h for details.
> > +	 */
> > +	__u64	sample_regs_user;
> 
> We need to sort that out now. How do we handle normal/compat regs?
> Do we want sample_regs_user_64 and sample_regs_user_32? Or can we
> make it possible with a single field like above? Should we
> expect more modes than just a simple native and compat? I don't
> know much the world outside x86.
> 
> Would be nice to have the opinion of other people on this. Ingo, Peter, others?

to sum up what we discussed earlier with Stephane and with you on irc:

SAMPLE registers:
  the point is what registers (32  or 64 bits) to store for sample,
  if there's compat task (32 bit) running under 64 bit kernel

  The answer is 64 ;) because if there's an interrupt or exception,
  it's allways 64bits registers that are stored on entering.

  The post unwind then need to figure out that it has 32 bit process
  and convert 64bit registers from SAMPL into 32 bits, and provide this
  info to libunwind.

perf_event_attr register mask:
  current state is that when under 64bit, the mask is expected
  to have 64bit registers (and 32bit registers for 32 bit kernel)

  if there's 32bit perf running under 64 bit kernel, it needs to be
  smart enough to ask for 64 bit registers..

  the other way is to include registers ARCH ID in perf_event_attr request,
  specifying what registers (32/64) you want for your samples..

  I'd stay with having always having:
      64bits registers for 64 bit kernel and
      32bit registers for 32 bit kernel

  userspace can allways do the registers conversion if needed


jirka
