Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab2IZWch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 18:32:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:40059 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526Ab2IZWcg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 18:32:36 -0400
Message-ID: <506381B2.2060806@parallels.com>
Date: Thu, 27 Sep 2012 02:29:06 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <devel@openvz.org>, <linux-mm@kvack.org>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 04/13] kmem accounting basic infrastructure
References: <CAOS58YNj-L4ocwn-c27ho4WPW41MKOeJbnLZ8N8r4eUkoxC7GA@mail.gmail.com> <50634105.8060302@parallels.com> <20120926180124.GA12544@google.com> <50634FC9.4090609@parallels.com> <20120926193417.GJ12544@google.com> <50635B9D.8020205@parallels.com> <20120926195648.GA20342@google.com> <50635F46.7000700@parallels.com> <20120926201629.GB20342@google.com> <50637298.2090904@parallels.com> <20120926221046.GA10453@mtj.dyndns.org>
In-Reply-To: <20120926221046.GA10453@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.3.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2012 02:10 AM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Thu, Sep 27, 2012 at 01:24:40AM +0400, Glauber Costa wrote:
>> "kmem_accounted" is not a switch. It is an internal representation only.
>> The semantics, that we discussed exhaustively in San Diego, is that a
>> group that is not limited is not accounted. This is simple and consistent.
>>
>> Since the limits are still per-cgroup, you are actually proposing more
>> user-visible complexity than me, since you are adding yet another file,
>> with its own semantics.
> 
> I was confused.  I thought it was exposed as a switch to userland (it
> being right below .use_hierarchy tripped red alert). 

Remember I was the one more vocally and radically so far trying to get
rid of use_hierarchy. I should have been more clear - and I was, as soon
as I better understood the nature of your opposition - but this is
precisely what I meant by "inherently different".

> 
> So, the proposed behavior is to allow enabling kmemcg anytime but
> ignore what happened inbetween?  Where the knob is changes but the
> weirdity seems all the same.  What prevents us from having a single
> switch at root which can only be flipped when there's no children?

So I view this very differently from you. We have no root-only switches
in memcg. This would be a first, and this is the kind of thing that adds
complexity, in my view.

You have someone like libvirt or a systemd service using memcg. It
probably starts at boot. Once it is started, it will pretty much prevent
switching of any global switch like this.

And then what? If you want a different behavior you need to go kill all
your services that are using memcg so you can get the behavior you want?
And if they happen to be making a specific flag choice by design, you
just say "you really can't run A + B together" ?

I myself think global switches are an unnecessary complication. And let
us not talk about use_hierarchy, please. If it becomes global, it is
going to be as part of a phase out plan anyway. The problem with that is
not that it is global, is that it shouldn't even exist.

> 
> Backward compatibility is covered with single switch and I really
> don't think "you can enable limits for kernel memory anytime but we
> don't keep track of whatever happened before it was flipped the first
> time because the first time is always special" is a sane thing to
> expose to userland.  Or am I misunderstanding the proposed behavior
> again?
> 

You do keep track. Before you switch it for the first time, it all
belongs to the root memcg.
