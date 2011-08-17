Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab1HQH1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:27:53 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49506 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896Ab1HQH1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:27:52 -0400
Date: Wed, 17 Aug 2011 09:27:46 +0200
From: Tejun Heo <tj@kernel.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kthreads: allow_signal: don't play with ->blocked
Message-ID: <20110817072746.GI4254@htj.dyndns.org>
References: <1313071035-12047-1-git-send-email-matt@console-pimps.org>
 <1313071035-12047-42-git-send-email-matt@console-pimps.org>
 <20110816180644.GJ29190@redhat.com>
 <20110816194427.GA6602@redhat.com>
 <20110816194450.GB6602@redhat.com>
 <20110816195121.GG2803@mtj.dyndns.org>
 <1313531422.3436.218.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313531422.3436.218.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 16, 2011 at 10:50:22PM +0100, Matt Fleming wrote:
> On Tue, 2011-08-16 at 21:51 +0200, Tejun Heo wrote:
> > I agree with the patchset but given that daemonize() isn't all that
> > popular and you already posted most (or was it all?) conversions,
> > wouldn't it be better to do this in a single patchset?  ie. Convert
> > all daemonize() users, kill daemonize(), and drop the hack from
> > allow_signal().
> 
> But because daemonize() is exported by the kernel should it go through
> the Documentation/feature-removal-schedule.txt procedure? And if so, can
> the allow_signal() patch still go in before daemonize() is removed?

IMHO, not really.  APIs get modified and dropped all the time and only
small fraction goes through feature-removal-schedule.  For APIs which
are widely used and/or difficult to migrate from, it sure makes sense
to do the staged removal but in this case it's an interface which is
quite unpopular and with relatively easy workaround (just use
kthread).

The worst thing we can do regarding API change is silently changing
semantics while not changing the interface.  For this patchset I don't
think it would matter all that much but is going that route.
ie. allow_signal() behavior is proposed to be changed because
in-kernel daemonize() users don't depend on it while leaving
daemonize() alone.  This is much worse than simply removing
daemonize() with sufficient explanation in the commit message.
Out-of-kernel user which depended on the combination working would now
be left with code which compiles fine but behaves differently, which
sucks big time.

These changes _are_ related and interdependent, and routing these
small changes through different trees often end up delaying things
unnecessarily.  One subsystem maintainer forgets to apply a patch or
send pull request and it can get easily drawn out half a year and
people forget what the original change was about after a while often
leading to half done conversions.  So, let's please collect all the
related patches into one series, drop all in-kernel daemonize() users,
kill daemonize() and then change allow_signal() behavior.

Thanks.

-- 
tejun
