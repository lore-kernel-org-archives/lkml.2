Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1IWJmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:42:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669Ab1IWJmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:42:20 -0400
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
From: Mike Galbraith <mgalbraith@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>
In-Reply-To: <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 11:42:16 +0200
Message-ID: <1316770936.6641.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 02:12 -0700, David Rientjes wrote:
> On Fri, 23 Sep 2011, Mike Galbraith wrote:
> 
> > Done, your ACK added as well.
> > 
> > kworkers can be born in a cpuset, leaving them adrift on an unsinkable ship.
> > Allow them to be moved to the root cpuset so the cpuset can be destroyed.
> > 
> 
> Thanks Li for the cc since I introduced this flag.
> 
> Does this even work?

Yup, but..

> You've modified cpuset_can_attach() to allow the attach for the cgroup 
> interface, but the actual function that attaches the task in the cpuset 
> code should fail since it does set_cpus_allowed_ptr() which should return 
> -EINVAL because of the PF_THREAD_BOUND.  That should have emitted a 
> WARN_ON() if this patch was tested.

..you're right that it warns.  It was tested, but I didn't notice that
it had griped at me.

> kworkers can always move themselves to the root cpuset, so that's probably 
> the better way of handling this than requiring userspace to do so.

kworker is sleeping in a cpuset that the user wants to depopulate and
destroy.  I wasn't requiring the user to do that, was allowing him to.

> And it seems like the workqueue code has a comment specifically about cpu 
> hotplug and why changing their cpumask shouldn't be allowed that was added 
> by Tejun Heo in db7bccf45cb8 ("workqueue: reimplement CPU hotplugging 
> support using trustee").  So let's cc him here as well at his 
> non-kernel.org address.

No, we don't want top muck around with their masks.

	-Mike

