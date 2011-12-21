Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1LUA3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:29:01 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57018 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab1LUA27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:28:59 -0500
Date: Wed, 21 Dec 2011 04:28:53 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>,
        Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Rik van Riel <riel@redhat.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Android low memory killer vs. memory pressure notifications
Message-ID: <20111221002853.GA11504@oksana.dev.rtsoft.ru>
References: <20111219025328.GA26249@oksana.dev.rtsoft.ru>
 <20111219121255.GA2086@tiehlicka.suse.cz>
 <alpine.DEB.2.00.1112191110060.19949@chino.kir.corp.google.com>
 <20111220145654.GA26881@oksana.dev.rtsoft.ru>
 <alpine.DEB.2.00.1112201322170.22077@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1112201322170.22077@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 01:36:00PM -0800, David Rientjes wrote:
> On Tue, 20 Dec 2011, Anton Vorontsov wrote:
> 
> > Hm, assuming that metadata is no longer an issue, why do you think avoiding
> > cgroups would be a good idea?
> > 
> 
> It's helpful for certain end users, particularly those in the embedded 
> world, to be able to disable as many config options as possible to reduce 
> the size of kernel image as much as possible, so they'll want a minimal 
> amount of kernel functionality that allows such notifications.  Keep in 
> mind that CONFIG_CGROUP_MEM_RES_CTLR is not enabled by default because of 
> this (enabling it, CONFIG_RESOURCE_COUNTERS, and CONFIG_CGROUPS increases 
> the size of the kernel text by ~1%),

So for 2MB kernel that's about 20KB of an additional text... This seems
affordable, especially as a trade-off for the things that cgroups may
provide.

The fact is, for desktop and server Linux, cgroups slowly becomes a
mandatory thing. And the reason for this is that cgroups mechanism
provides some very useful features (in an extensible way, like plugins),
i.e. a way to manage and track processes and its resources -- which is the
main purpose of cgroups.

And that's exactly what we want for low memory killer -- manage processes
and track its resources.

No doubt that Android is very different from desktop and server Linux
usage, but that does not mean that it has to use different kernel
interfaces.


As Alan Cox pointed out, we should probably focus on improving (if needed)
existing solutions, instead of duplicating functionality for the sake of
doing the same thing, but in a more "lightweight" and ad-hocish way.

By going "alternative" (to cgroups) way, we're risking to end up with the
same thing but under some different name.

> and it's becoming increasingly 
> important for certain workloads to be notified of low memory conditions 
> without any restriction on its usage other than the amount of RAM that the 
> system has

I'm not sure what you mean here. Mem_cg may provide a way to the
userland to be notified on low memory conditions, i.e. amount of RAM
that the system has -- the same thing as /dev/mem_notify would do...

(Though, as of current mem_cg, I believe that root memory.usage_in_bytes
does not account memory used by the kernel itself, so today it seems not
possible to use 'memory thresholds' feature to track total amount of RAM
available in the system.)

> so that they can trigger internal memory freeing, explicit 
> memory compaction from the command line, drop caches, reducing scheduling 
> priority, etc.

Mem_cg provides a mere resources tracking and notification mechanism,
I'm not sure how it could restrict what exactly apps would do with it.
They as well may trigger internal memory freeing, drop caches etc., no?

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
