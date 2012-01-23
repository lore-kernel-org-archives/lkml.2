Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab2AWPeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:34:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2AWPeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:34:08 -0500
Date: Mon, 23 Jan 2012 16:33:50 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Add sysfs format attribute for pmu device
Message-ID: <20120123153350.GB1821@m.redhat.com>
References: <20120109152855.GA1597@m.brq.redhat.com>
 <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1326717103-10287-6-git-send-email-jolsa@redhat.com>
 <m1bopupi3v.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bopupi3v.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 07:13:24AM -0800, Eric W. Biederman wrote:
> Jiri Olsa <jolsa@redhat.com> writes:
> 
> > Adding 'format' attribute for pmu device that contains
> > a syntax description on how to construct raw events.
> >
> > The event configuration is described in following
> > struct pefr_event_attr attributes:
> >
> >   config
> >   config1
> >   config2
> >
> > Each line of the format file describes mapping of name
> > and bitfield definition within one of abve attributes.
> >
> > eg:
> >   event   config:0-7
> >   umask   config:8-15
> >   usr     config:16
> >   os      config:17
> >   edge    config:18
> >   any     config:21
> >   inv     config:23
> >   cmask   config:24-31
> >
> > Line syntax:
> >   line:      NAME config ':' bits
> >   config:    'config' | 'config1' | 'config2"
> >   bits:      bits ',' bit_term | bit_term
> >   bit_term:  VALUE '-' VALUE | VALUE
> >
> > Adding event_format callback to the struct pmu, which provides
> > the format information. The pmu shall override this function
> > and provide its own specific format information.
> >
> > If not overloaded the default format information is used:
> >
> >   config  config:0-63
> >   config1 config1:0-63
> >   config2 config2:0-63
> >
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> 
> > @@ -5492,8 +5492,31 @@ type_show(struct device *dev, struct device_attribute *attr, char *page)
> >  	return snprintf(page, PAGE_SIZE-1, "%d\n", pmu->type);
> >  }
> >  
> > +static ssize_t perf_default_event_format(struct pmu *pmu, char *page)
> > +{
> > +	ssize_t ret;
> > +
> > +	ret  = sprintf(page,       "config  config:0-63\n");
> > +	ret += sprintf(page + ret, "config1 config1:0-63\n");
> > +	ret += sprintf(page + ret, "config2 config2:0-63\n");
> 
> This looks like abuse of sysfs.  The rule is one value per file.
> When you start adding newlines I can't see how this format attribute can
> be considered one value.

ops, missed that rule.. I think we can carry the syntax files
within perf, or have it builtin somehow.. or procfs? :) PeterZ?

thanks,
jirka
