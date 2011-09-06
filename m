Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328Ab1IFXG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 19:06:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48365 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1IFXGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 19:06:51 -0400
Date: Wed, 7 Sep 2011 08:06:45 +0900
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Add new PTRACE_O_TRACESTOP option, make it control
 new ptrace behavior.
Message-ID: <20110906230645.GB16976@htj.dyndns.org>
References: <201109042311.18793.vda.linux@googlemail.com>
 <1315242384.1888.64.camel@dhcp-25-63.brq.redhat.com>
 <20110906200818.GA28349@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906200818.GA28349@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 06, 2011 at 10:08:18PM +0200, Oleg Nesterov wrote:
> On 09/05, Denys Vlasenko wrote:
> > PTRACE_SEIZE does not assume PTRACE_O_TRACESTOP, but with this patch
> > it allows any PTRACE_O_opts to be set at attach time
> 
> Well. This assumes that the only difference with PTRACE_SEIZE is the
> new stop/interrupt behaviour. I am not sure this is "safe" to assume.
> 
> Tejun, what do you think?

The biggest problem would be locking against the tracee.  Currently,
it's assumed that the behavior is determined at seize/attach time and
stay that way.  Tracee behaves differently to maintain compatibility
or show the new behavior.  If the state changes on the fly, we need to
change how tracee behaves.  Maybe we'll need some re-trap trickery or
can just get away with making tracee always behave in the new way and
somehow present it differently if !TRACESTOP.

That said, I can't see much point in this excercise.  Why does this
even matter?  This is almost purely cosmetic and any effect on the
usability of the API is so too.  The gained easiness of the API change
is in the realm of a few if statements.  There's nothing to be gained
by allowing flipping TRACESTOP.  Why would any program which is aware
of the new behavior turn it off and if not why would we want to
complicate things by supporting a feature which wouldn't be useful
risking higher chance of breakage (both from increased complexity and
lack of usage)?

ptrace is an ugly interface.  Some of that is inherent but probably
most of it is from how it was designed and has evolved over time.  As
far as I'm concerned, the goals are making it feature-complete and not
deviating too much from what's already there.

ptrace is painful to use with or without PTRACE_O_TRACESTOP.  IMHO, if
we want to address this issue, a better approach would be implementing
a wrapper library which hides the silliness of the kernel interface
and provides useable set of interface and information.

Thanks.

-- 
tejun
