Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab0KBVcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 17:32:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:51875 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab0KBVcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 17:32:21 -0400
Message-ID: <4CD08419.5050803@kernel.org>
Date: Tue, 02 Nov 2010 22:35:21 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
In-Reply-To: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 02 Nov 2010 21:32:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing lkml too)
Hello,

On 11/02/2010 08:30 PM, Oren Laadan wrote:
> Following the discussion yesterday, here is a linux-cr diff that
> that is limited to changes to existing code.
> 
> The diff doesn't include the eclone() patches. I also tried to strip
> off the new c/r code (either code in new files, or new code within
> #ifdef CONFIG_CHECKPOINT in existing files).
> 
> I left a few such snippets in, e.g. c/r syscalls templates and 
> declaration of c/r specific methods in, e.g. file_operations.
> 
> The remaining changes in this patch include new freezer state
> ("CHECKPOINTING"), mostly refactoring of exsiting code, and a bit
> of new helpers.
> 
> Disclaimer: don't try to compile (or apply) - this is only intended
> to give a ballpark of how the c/r patches change existing code.

The patch size itself isn't too big but I still think it's one scary
patch mostly because the breadth of the code checkpointing needs to
modify and I suspect that probably is the biggest concern regarding
checkpoint-restart from implementation point of view.

FWIW, I'm not quite convinced checkpoint-restart can be something
which can be generally useful.  In controlled environments where the
target application behavior can be relatively well defined and
contained (including actions necessary to rollback in case something
goes bonkers), it would work and can be quite useful, but I'm afraid
the states which need to be saved and restored aren't defined well
enough to be generally applicable.  Not only is it a difficult
problem, it actually is impossible to define common set of states to
be saved and restored - it depends on each application.

As such, I have difficult time believing it can be something generally
useful.  IOW, I think talking about its usage in complex environments
like common desktops is mostly handwaving.  What about X sessions,
network connections, states established in other applications via dbus
or whatnot?  Which files need to be snapshotted together?  What about
shared mmaps?  These questions are not difficult to answer in generic
way, they are impossible.

There is a very distinctive difference between system wide
suspend/hibernation and process checkpointing.  Most programs are
already written with the conditions in mind which can be caused by
system level suspend/hibernation.  Most programs don't expect to be
scheduled and run in any definite amount of time.  There usually
are provisions for loss or failure of resources which are out of the
local system.  There are corner cases which are affected and those
programs contain code to respond to suspend/hibernation.  Please note
that this is about userland application behavior but not
implementation detail in the kernel.  It is a much more fundamental
property.

So, although checkpoint-restart can be very useful for certain
circumstances, I don't believe there can be a general implementation.
It inevitably needs to put somewhat strict restrictions on what the
applications being checkpointed are allowed to do.  And after my
train of thought reaches there, I fail to see what the advantages of
in-kernel implementation would be compared to something like the
following.

  http://dmtcp.sourceforge.net/

Sure, in-kernel implementation would be able to fake it better, but I
don't think it's anything major.  The coverage would be slightly
better but breaking the illusion wouldn't take much.  Just push it a
bit further and it will break all the same.  In addition, to be
useful, it would need userland framework or set of workarounds which
are aware of and can manipulate userland states anyway.  For workloads
for which checkpointing would be most beneficial (HPC for example), I
think something like the above would do just fine and it would make
much more sense to add small features to make userland checkpointing
work better than doing the whole thing in the kernel.

I think in-kernel checkpointing is in awkward place in terms of
tradeoff between its benefits and the added complexities to implement
it.  If you give up coverage slightly, userland checkpointing is
there.  If you need reliable coverage, proper virtualization isn't too
far away.  As such, FWIW, I fail to see enough justification for the
added complexity.  I'll be happy to be proven wrong tho.  :-)

Thank you.

-- 
tejun
