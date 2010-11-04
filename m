Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab0KDDkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:40:49 -0400
Received: from amber.ccs.neu.edu ([129.10.116.51]:59722 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0KDDkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <4CD08419.5050803@kernel.org>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu> <4CD08419.5050803@kernel.org>
From: Kapil Arya <kapil@ccs.neu.edu>
Date: Wed, 3 Nov 2010 23:40:25 -0400
Message-ID: <AANLkTinOg6n3ZA+0gHzw9LouRuUmJ7DJwHtABRy5c=gM@mail.gmail.com>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
To: Tejun Heo <tj@kernel.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Gene Cooperman <gene@ccs.neu.edu>,
        Kapil Arya <kapil@ccs.neu.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry for resending the message; the last message contained some html
tags and was rejected by server)

We would like to thank the previous post for bringing up the topic
of kernel C/R versus userland C/R.  We are two of the developers of DMTCP
(userland checkpointing):  Distributed MultiThreaded CheckPointing .
	     http://dmtcp.sourceforge.net
We had waited to write to the kernel developers because we had wanted
to ensure that DMTCP is sufficiently robust before wasting the time of the
kernel developers.  This thread seems like a good opportunity to begin
a dialogue.

In fact, we only became aware of Linux kernel C/R this September.
Of course, we were aware of Oren Laadan's fine earlier work on ZapC
for distributed checkpointing using the Linux kernel (CLUSTER-2005).
We have a high respect for Oren Laadan and the other Linux C/R developers,
as well as for the developers of BLCR (a C/R kernel module with a userland
component that is widely used in HPC batch faciliites).

By coincidence, when we became aware of Linux C/R, we were already in
the middle of development for a major new release of DMTCP (from version
1.1.x to 1.2.0).  We just finished that release.  Among other features,
this release supports checkpointing of GNU 'screen', and we have tested
screen in some common use cases (with vim, with emacs, etc.).  While it
supports ssh (e.g. checkpointing OpenMPI, which uses ssh), it doesn't yet
support _interactive_ ssh sessions.  That will come in the next release.

We believe that both Linux C/R and DMTCP are becoming quite mature, and
that in general, one can achieve good application coverage with either.

In our personal view, a key difference between in-kernel and userland
approaches is the issue of security.  The Linux C/R developers state
the issue very well in their FAQ (question number 7):
> https://ckpt.wiki.kernel.org/index.php/Faq :
> 7. Can non-root users checkpoint/restart an application ?
>
> For now, only users with CAP_SYSADMIN privileges can C/R an
> application. This is to ensure that the checkpoint image has not been
> tampered with and will be treated like a loadable kernel-module.

The previous posts also brought up the issue of external connections.
While DMTCP has been developed over six years, in the last year we
have concentrated especially on the issue of external connections.
While we've accumulated many war stories, one will illustrate the point.
Most Linux distros link vi to vim.  Vim supports mouse and other operations
via the X11 server.  When vim starts up, it connects to the X11
server (which may be local, or remote if ssh uses X11 forwarding).
On transparent checkpoint and restart, vim expects to continue
talking to the X11 server.  Currently, DMTCP recognizes such
X11 server connections and refuses them.  Vim still survives without
its mouse and other X11 services.  For the future, we are considering
a more flexible approach that will take account of the X11 protocol.

Strategies like these are easily handled in userspace.  We suspect
that while one may begin with a pure kernel approach, eventually,
one will still want to add a userland component to achieve this kind
of flexibility, just as BLCR has already done.

					   Best wishes,
                                           - Gene Cooperman and Kapil Arya
					     from the DMTCP team

On Tue, Nov 2, 2010 at 5:35 PM, Tejun Heo <tj@kernel.org> wrote:
> (cc'ing lkml too)
> Hello,
>
> On 11/02/2010 08:30 PM, Oren Laadan wrote:
>> Following the discussion yesterday, here is a linux-cr diff that
>> that is limited to changes to existing code.
>>
>> The diff doesn't include the eclone() patches. I also tried to strip
>> off the new c/r code (either code in new files, or new code within
>> #ifdef CONFIG_CHECKPOINT in existing files).
>>
>> I left a few such snippets in, e.g. c/r syscalls templates and
>> declaration of c/r specific methods in, e.g. file_operations.
>>
>> The remaining changes in this patch include new freezer state
>> ("CHECKPOINTING"), mostly refactoring of exsiting code, and a bit
>> of new helpers.
>>
>> Disclaimer: don't try to compile (or apply) - this is only intended
>> to give a ballpark of how the c/r patches change existing code.
>
> The patch size itself isn't too big but I still think it's one scary
> patch mostly because the breadth of the code checkpointing needs to
> modify and I suspect that probably is the biggest concern regarding
> checkpoint-restart from implementation point of view.
>
> FWIW, I'm not quite convinced checkpoint-restart can be something
> which can be generally useful.  In controlled environments where the
> target application behavior can be relatively well defined and
> contained (including actions necessary to rollback in case something
> goes bonkers), it would work and can be quite useful, but I'm afraid
> the states which need to be saved and restored aren't defined well
> enough to be generally applicable.  Not only is it a difficult
> problem, it actually is impossible to define common set of states to
> be saved and restored - it depends on each application.
>
> As such, I have difficult time believing it can be something generally
> useful.  IOW, I think talking about its usage in complex environments
> like common desktops is mostly handwaving.  What about X sessions,
> network connections, states established in other applications via dbus
> or whatnot?  Which files need to be snapshotted together?  What about
> shared mmaps?  These questions are not difficult to answer in generic
> way, they are impossible.
>
> There is a very distinctive difference between system wide
> suspend/hibernation and process checkpointing.  Most programs are
> already written with the conditions in mind which can be caused by
> system level suspend/hibernation.  Most programs don't expect to be
> scheduled and run in any definite amount of time.  There usually
> are provisions for loss or failure of resources which are out of the
> local system.  There are corner cases which are affected and those
> programs contain code to respond to suspend/hibernation.  Please note
> that this is about userland application behavior but not
> implementation detail in the kernel.  It is a much more fundamental
> property.
>
> So, although checkpoint-restart can be very useful for certain
> circumstances, I don't believe there can be a general implementation.
> It inevitably needs to put somewhat strict restrictions on what the
> applications being checkpointed are allowed to do.  And after my
> train of thought reaches there, I fail to see what the advantages of
> in-kernel implementation would be compared to something like the
> following.
>
>  http://dmtcp.sourceforge.net/
>
> Sure, in-kernel implementation would be able to fake it better, but I
> don't think it's anything major.  The coverage would be slightly
> better but breaking the illusion wouldn't take much.  Just push it a
> bit further and it will break all the same.  In addition, to be
> useful, it would need userland framework or set of workarounds which
> are aware of and can manipulate userland states anyway.  For workloads
> for which checkpointing would be most beneficial (HPC for example), I
> think something like the above would do just fine and it would make
> much more sense to add small features to make userland checkpointing
> work better than doing the whole thing in the kernel.
>
> I think in-kernel checkpointing is in awkward place in terms of
> tradeoff between its benefits and the added complexities to implement
> it.  If you give up coverage slightly, userland checkpointing is
> there.  If you need reliable coverage, proper virtualization isn't too
> far away.  As such, FWIW, I fail to see enough justification for the
> added complexity.  I'll be happy to be proven wrong tho.  :-)
>
> Thank you.
>
> --
> tejun
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>
