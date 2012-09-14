Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2INT3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 15:29:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39896 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759973Ab2INT3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 15:29:40 -0400
Date: Fri, 14 Sep 2012 12:29:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Daniel P. Berrange" <berrange@redhat.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
        Michal Hocko <mhocko@suse.cz>, Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [RFC] cgroup TODOs
Message-ID: <20120914192935.GO17747@google.com>
References: <20120913205827.GO7677@google.com>
 <20120914091032.GA6819@redhat.com>
 <20120914135830.GB6221@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120914135830.GB6221@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(cc'ing Lennart and Kay)

On Fri, Sep 14, 2012 at 09:58:30AM -0400, Vivek Goyal wrote:
> I am little concerned about above and wondering how systemd and libvirt
> will interact and behave out of the box.
> 
> Currently systemd does not create its own hierarchy under blkio and
> libvirt does. So putting all together means there is no way to avoid
> the overhead of systemd created hierarchy.
> 
> \
> |
> +- system
>      |
>      +- libvirtd.service
>               |
>               +- virt-machine1
>               +- virt-machine2
> 
> So there is now way to avoid the overhead of two levels of hierarchy
> created by systemd. I really wish that systemd gets rid of "system"
> cgroup and puts services directly in top level group. Creating deeper
> hieararchices is expensive.
> 
> I just want to mention it clearly that with above model, it will not
> be possible for libvirt to avoid hierarchy levels created by systemd.
> So solution would be to keep depth of hierarchy as low as possible and
> to keep controller overhead as low as possible.

Yes, if we're do full unified hierarchy, nesting should happen iff
resource control actually requires the nesting so that tree depth is
kept minimal.  Nesting shouldn't be used purely for organizational
purposes.

> Now I know that with blkio idling kills performance. So one solution
> could be that on anything fast, don't use CFQ. Use deadline and then
> group idling overhead goes away and tools like systemd and libvirt don't
> have to worry about keeping track of disks and what scheduler is running.
> They don't want to do it and expect kernel to get it right.

I personally don't think the level of complexity we have in cfq is
something useful for the SSDs which are getting ever better.  cfq is
allowed to use a lot of processing overhead and complexity because
disks are *so* slow.  The balance already has completely changed with
SSDs and we should be doing something a lot simpler most likely based
on iops for them - be it deadline or whatever.

blkcg support is currently tied to cfq-iosched which sucks but I think
that could be the only way to achieve any kind of acceptable blkcg
support for rotating disks.  I think what we should do is abstract out
the common organization part as much as possible so that we don't end
up duplicating everything for blk-throttle, cfq and, say, deadline.

Thanks.

-- 
tejun
