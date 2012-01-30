Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2A3Jwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 04:52:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab2A3Jwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 04:52:41 -0500
Date: Mon, 30 Jan 2012 10:52:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>, acme@redhat.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
Message-ID: <20120130095223.GB1552@m.brq.redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-6-git-send-email-jolsa@redhat.com>
 <4F231256.8080905@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F231256.8080905@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 01:08:38PM -0800, Corey Ashford wrote:
> On 01/27/2012 06:34 AM, Jiri Olsa wrote:
> > Adding sysfs group 'format' attribute for pmu device that
> > contains a syntax description on how to construct raw events.
> > 
> > The event configuration is described in following
> > struct pefr_event_attr attributes:
> > 
> >   config
> >   config1
> >   config2
> > 
> > Each sysfs attribute within the format attribute group,
> > describes mapping of name and bitfield definition within
> > one of above attributes.
> > 
> > eg:
> >   "/sys/...<dev>/format/event" contains "config:0-7"
> >   "/sys/...<dev>/format/umask" contains "config:8-15"
> >   "/sys/...<dev>/format/usr"   contains "config:16"
> > 
> > the attribute value syntax is:
> > 
> >   line:      config ':' bits
> >   config:    'config' | 'config1' | 'config2"
> >   bits:      bits ',' bit_term | bit_term
> >   bit_term:  VALUE '-' VALUE | VALUE
> > 
> > Adding format_defined bool to the struct pmu to specify wether
> > pmu defines its own set of format attributes (within the
> > attr_groups member) or the default format attributes should be
> > used:
> >   "/sys/...<dev>/format/config"  contains "config:0-63"
> >   "/sys/...<dev>/format/config1" contains "config1:0-63"
> >   "/sys/...<dev>/format/config2" contains "config2:0-63"
> 
> 
> Hi Jiri,
> 
> I've been out of the perf_events loop for some time, but I did finally
> notice your patch series thread.
> 
> I think what you've done is very good and I'm excited to see progress in
> this area.  However, it's not clear to me that it is as generalized as
> it needs to be for some PMU's.  I say this because not all events on a
> given PMU will have the same needed fields.

ok, I wasn't aware of this

> 
> As an example, the IBM PowerEN processor has roughly 20 different PMU's
> on it.  Some of those PMU's are quite complex and divide their events up
> into subsets, each with different fields.  For example, some events may
> have a PID matching field, and others may have an bus number matching
> field, or matching mode field, etc.  The fields are different widths,
> and may overlap in the config/1/2 space.
> 
> It seems that there are two approaches you could take:
> 
> 1) Keep your format, but allow the fields to overlap in the bit space.
> For example:
> 
>   "/sys/...<dev>/format/event" contains "config:0-7"
>   "/sys/...<dev>/format/pidmatch" contains "config:8-15"
>   "/sys/...<dev>/format/busmatch"   contains "config:8-13"
> 
> Note that busmatch overlaps pidmatch

currently format fields definitions may overlap, there's no check
to prevent that

> 
> 2) Create event groups that have their overlapping config space
> separated out:
> 
>   "/sys/...<dev>/format/event" contains "config:0-7"
> 
>   "/sys/...<dev>.1/format/pidmatch" contains "config:8-15"
> 
>   "/sys/...<dev>.2/format/busmatch"   contains "config:8-13"
> 
> 
> Notice the .1 and .2 on the <dev>.
> 
> This might help the user understand which fields go together.  I'm not
> sold on the .1 syntax... you could do it as <dev>.<event-group-name>/ or
> <dev>/<event-group-name>/... or whatever seems to make the most sense
> and is relatively easy to implement and use.

Though I'm not sure we want allow separate devices inside single pmu,
I think we could have multiple format groups if necessary :)

some quick ideas:

1) having format group attribute under format like:
   <dev>/format/group1/..
   <dev>/format/group2/..
   <dev>/format/group2/..
   ...

2) having format group name within the format attribute name like:
   <dev>/format/group1-krava1
   <dev>/format/group1-krava2
   <dev>/format/group2-krava3
   ...

3) having group name inside the foramt attributes like:
   cat <dev>/format/group1-krava1
   group1 config:0-1,62-63


I think I like the most ad 1)..

We could have something like default format directory if there's
only a single format group, like:
   <dev>/format/default/krava1
   <dev>/format/default/krava2
   ...

The perf event syntax could have something like '::' to classify
format attribute with a group like (none would go to default dir):

   cpu/group1::config=1,group2::config1=2,config2=3/u
or 
   cpu::group1/config=1,config1=2,config2=3/u


Or we could say the format field names could not overlap and then
we dont need to specify group at all :) It'd be just for user's
awareness..

Any idea if we at all want to go this way? ;)

thanks,
jirka
