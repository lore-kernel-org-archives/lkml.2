Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452Ab2BANOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 08:14:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55732 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab2BANOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 08:14:08 -0500
Date: Wed, 1 Feb 2012 14:13:40 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] perf: Adding sysfs group format attribute for pmu
 device
Message-ID: <20120201131340.GC1655@m.brq.redhat.com>
References: <1326717103-10287-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-1-git-send-email-jolsa@redhat.com>
 <1327674868-10486-6-git-send-email-jolsa@redhat.com>
 <4F231256.8080905@linux.vnet.ibm.com>
 <20120130095223.GB1552@m.brq.redhat.com>
 <4F289486.2050107@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F289486.2050107@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 05:25:26PM -0800, Corey Ashford wrote:
> On 01/30/2012 01:52 AM, Jiri Olsa wrote:
> > On Fri, Jan 27, 2012 at 01:08:38PM -0800, Corey Ashford wrote:
> >> On 01/27/2012 06:34 AM, Jiri Olsa wrote:
> >>> Adding sysfs group 'format' attribute for pmu device that
> >>> contains a syntax description on how to construct raw events.
> >>>

SNIP

> >> This might help the user understand which fields go together.  I'm not
> >> sold on the .1 syntax... you could do it as <dev>.<event-group-name>/ or
> >> <dev>/<event-group-name>/... or whatever seems to make the most sense
> >> and is relatively easy to implement and use.
> > 
> > Though I'm not sure we want allow separate devices inside single pmu,
> > I think we could have multiple format groups if necessary :)
> > 
> > some quick ideas:
> > 
> > 1) having format group attribute under format like:
> >    <dev>/format/group1/..
> >    <dev>/format/group2/..
> >    <dev>/format/group2/..
> >    ...
> > 
> > 2) having format group name within the format attribute name like:
> >    <dev>/format/group1-krava1
> >    <dev>/format/group1-krava2
> >    <dev>/format/group2-krava3
> >    ...
> > 
> > 3) having group name inside the foramt attributes like:
> >    cat <dev>/format/group1-krava1
> >    group1 config:0-1,62-63
> > 
> > 
> > I think I like the most ad 1)..
> > 
> > We could have something like default format directory if there's
> > only a single format group, like:
> >    <dev>/format/default/krava1
> >    <dev>/format/default/krava2
> >    ...
> > 
> > The perf event syntax could have something like '::' to classify
> > format attribute with a group like (none would go to default dir):
> > 
> >    cpu/group1::config=1,group2::config1=2,config2=3/u
> 
> The "[::<group>|]" syntax is good.
> 
> Are you are suggesting that a single event could use multiple groups
> because they may share some common fields, such as the event code?  If
> so, I think that might be confusing.   I think it would be better to
> have every group fully lay out the bits in the config{,1,2} fields so
> that you only need to specify one group per event, even if that leads to
> some redundancy (e.g. group1..n all have an eventcode field.)

ok, it'd be the 'cpu::group1/config=1,config1=2,config2=3/u' then..

but let's see what Peter thinks about this, since he first suggested
to 'fix' this by having separate pmu drivers.. not format groups :)

> 
> Something I missed before is that your config sysfs attribute group can
> look like:
> 
> config1:0-1,62-63
> 
> How does the user specify a value for these two bit fields, or does he
> concatenate the bit fields together, and perf will split it apart again?
> e.g. cpu/group1::config1=1,2/u   ?

user just set the value for the field and perf makes sure it is spread
over the config[12] bits as configured

so as for your example, following format definiton:
	# cat <pmu>/format/krava
        config1:0-1,62-63

with user settings:
	cpu/krava=15/u

fills bits 0,1,62,63 of config1 with 1s

> 
> 
> > or 
> >    cpu::group1/config=1,config1=2,config2=3/u
> > 
> > 
> > Or we could say the format field names could not overlap and then
> > we dont need to specify group at all :) It'd be just for user's
> > awareness..
> 
> perf would then "want" to check for overlap and also for fields coming
> from different groups.  In some cases, I think you'd want to have the
> same name for a field, but have the field a different size, or perhaps a
> different interpretation.   For example "busid" might be a desirable
> name for fields in two different event groups, but their sizes and
> position are different.  Of course the quick fix is to name them
> uniquely, but since they are in subdirectories, it isn't really obvious
> that the names have to be unique.
> 
> One other comment that occurs to me is that it would be nice for perf to
> know when a supplied value is out of range, or will have undefined
> results.  For example, a field may be 8 bits wide, but not all 8-bit
> values are legal.  For example, there may be 208 events, and the codes
> may be somehwhat or even very sparsely encoded.  So, ideally, a config
> field in sysfs might look like this:
> 
> config1:0-7:0x0-0xd8,0xdb-0xe2,0xe4-0xe6
> 
> This way perf could check for valid values before stuffing them into
> registers, and give a good error message to the user.  If there is no
> restriction field, it would be assumed all of the possible values are valid.
> 
> I think the kernel code needs to check for bad values as well, because
> people can bypass the restrictions exposed by sysfs and use the
> perf_events API directly.

ok, I think some kind of such restriction could be added as optional ':'
behind the current format if needed.. np

thanks,
jirka
