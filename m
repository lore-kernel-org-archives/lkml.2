Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0GaAXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 20:23:37 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:51257 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab0GaAXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 20:23:35 -0400
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Daniel Lezcano <dlezcano@free.fr>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Paul Menage <menage@google.com>
Subject: Re: Remaining work for userns
References: <20100729195629.GA13378@hallyn.com>
	<20100729195812.GB19015@hallyn.com>
	<20100729214008.GA2785@count0.beaverton.ibm.com>
	<20100729223957.GA12387@hallyn.com>
	<20100729230052.GB2785@count0.beaverton.ibm.com>
	<20100729232352.GC13902@hallyn.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 30 Jul 2010 17:23:26 -0700
In-Reply-To: <20100729232352.GC13902@hallyn.com> (Serge E. Hallyn's message of "Thu\, 29 Jul 2010 18\:23\:52 -0500")
Message-ID: <m139v0ts75.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Matt Helsley (matthltc@us.ibm.com):
>> On Thu, Jul 29, 2010 at 05:39:57PM -0500, Serge E. Hallyn wrote:
>> > Quoting Matt Helsley (matthltc@us.ibm.com):
>> > > On Thu, Jul 29, 2010 at 02:58:12PM -0500, Serge E. Hallyn wrote:
>> 
>> <snip>
>> 
>> > 
>> > BTW in the past the only reason I saw for keeping ns cgroup was
>> > to lock tasks into a devices cgroup.  Until that lazy guy who was
>> > going to do it gets off his butt and implements user namespaces,
>> > you'll just have to use LSMs, which is the right way.
>> 
>> And the only missing piece of userns is replacing the cred checks
>> right? If so, it might be possible to come up with a coccinelle semantic
>> patch which would do all/most of the hard work -- depends on whether the
>> all the checks fit a small number of semantic patterns.
>
> I think the thing that always puts the brakes on when I get started
> is siginfo_t.  We need some way to reference user namespaces in there,
> without enforcing lifetime rules on siginfo.

As I recall signal delivery in the kernel lands the signal in the
queue of the destination process before the syscall returns.  If that
is true we should be able to handle signal delivery by just doing
whatever conversions are needed during delivery.

aka the userns should just be task->nsproxy->user_ns for
task->signal->queue.  We cannot unshare the user namespace so there
are no nasty races.

I am reminded that I may want to play with the user namespace and
unshare when I get setns refresh and reviewed for inclusion.  Still
none of that should affect the fact that a task should never be
able to change user namespaces.

> What you mention is definately a chunk as well, so if you are interested
> in pursuing that that'd be great.
>
> Also, reviewing the patches at the top of
> http://git.kernel.org/?p=linux/kernel/git/sergeh/linux-cr.git;a=shortlog;h=refs/heads/userns.feb16.1
> to give us some fresh feedback on the general approach is
> valuable.
>
> And from there, the whole discussion (which we've had several times
> in the past) about how to have the VFS map userids should probably be
> had again.  (I believe august 2008 was the last time we really got
> into that)

We now have user_ns_map_uid and user_ns_map_gid in next-next.git
Serge I'm not certain how that interacts with your other work, but
it is definitely something we want to build on.

Eric

