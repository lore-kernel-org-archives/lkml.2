Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462Ab2C3QPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:15:02 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:36180 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473Ab2C3QO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:14:56 -0400
Date: Fri, 30 Mar 2012 16:15:00 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Serge E. Hallyn" <serge@hallyn.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, keescook@chromium.org
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120330161500.GA32247@mail.hallyn.com>
References: <20120328075549.GA2204@moon>
 <20120328081639.GB2286@moon>
 <20120328194312.GA22211@mail.hallyn.com>
 <20120328194613.GA3678@redhat.com>
 <20120328213044.GA26190@peqn>
 <20120328213736.GM2204@moon>
 <20120329023053.GA10187@mail.hallyn.com>
 <20120330123122.GB2024@moon>
 <20120330141219.GC3693@sergelap>
 <20120330144035.GC2024@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120330144035.GC2024@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> On Fri, Mar 30, 2012 at 09:12:19AM -0500, Serge Hallyn wrote:
> ...
> > > 
> > > Yes, I wanna take a look on Eric's set first just to get right
> > > "picture" of everything. And I wanted to find a minimal solution
> > > with current kernel code base which could be extended in future.
> > > 
> > > That said I guess the current init-ns-only approach should do the
> > > trick for a while. And (thanks for pointing) I need to add a test
> > > if a caller which tries to obtain uids has enought credentials
> > > for that (probably CAP_FOWNER), right?
> > 
> > Sorry, I'm not sure which caller you mean.  Neither f_setown nor
> > f_getown require privilege right now.  Oh, you mean at restart?
> 
> I meant the dumper. Yes, at moment f_get/setown requires no privileges
> but I'm not sure if uid/euid is same or less sensible information
> than pid, that's why I though CAP_FOWNER might be worth to add, no?

Hmm, I would say no, but that might be a good question for kees.

IMO it's not sensitive information and so no sense requiring privilege
(and encouraging handing out of extra privilage to get at the info)

Cc:ing kees.

> > f_setown to someone else's uid/pid means you may cause a signal to
> > be sent to them.  So CAP_KILL might be good?  You do through that
> > signal get *some* info about the file writes, though not contents.
> > So yeah, maybe (CAP_KILL|CAP_FOWNER).
> ...
> > > I suspect operating with kuid's will be a way more easier.
> > 
> > Yeah, I keep going back and forth on which makes more sense.  But
> > kuid's probably make more sense, even though they aren't what
> > userspace in container will see.  When you restore, the mapping
> > will give userspace what it expects;  and if you're going to
> > restart in a container with a different mapping, then you'll
> > have to convert the filesystem as well since its inodes will
> > store kuids, so may as well also convert the kuids in the
> > checkpoint image then.
> 
> Agreed (if only I'm not missimg somethig ;)
> 
> 	Cyrill
