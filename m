Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2ADRyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 12:54:17 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38696 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab2ADRyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 12:54:15 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 2/4] proc: Show namespaces IDs in /proc/pid/ns/* files
References: <20111223124741.711871189@openvz.org>
	<20111223124920.725686255@openvz.org>
	<m1d3b0gg3r.fsf@fess.ebiederm.org> <20120104112632.GH2621@moon>
Date: Wed, 04 Jan 2012 09:56:24 -0800
In-Reply-To: <20120104112632.GH2621@moon> (Cyrill Gorcunov's message of "Wed,
	4 Jan 2012 15:26:32 +0400")
Message-ID: <m1pqezfj1z.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+FUn9K7cLbAvj28l6HjuvN/PSf9nVs1BY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> writes:

> On Tue, Jan 03, 2012 at 10:02:32PM -0800, Eric W. Biederman wrote:
>> Cyrill Gorcunov <gorcunov@openvz.org> writes:
>> 
>> > This patch adds proc_ns_read method which provides
>> > IDs for /proc/pid/ns/* files.
>> 
>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> This is a poorly thought out user interface.  If we are going to return
>> this kind of information and I believe we should we should, we should
>> return the id in the inode field with stat.
>> 
>> Comparing device+inode for equality is the traditional way to see if
>> two objects are the same in unix and there is no reason to make up
>> a new interface to get this functionality.
>> 
>> Furthermore we should always return the information, as it is valuable
>> even outside of the checkpoint/restart context.
>> 
>> I am also concerned that you appear to be building an interface
>> for use by checkpoint/restart that makes it impossible
>> checkpoint/restart the programs using that interface.  The reason
>> is that you appear to be  putting this nebulous id into a global 
>> namespace and as such even if we wanted to I don't see how we could
>> build a version where we could restore the id during a restart.  And
>> the thing is if you start building interfaces with identifiers you can
>> not possibly restore I expect you will find you have painted yourself
>> into a corner.
>> 
>> Using inode from stat avoids painting yourself into a corner because
>> you have the possibility of different mounts with different device
>> numbers having different inode numbers.
>> 
>> For the short term I don't see value in being able to restore the
>> object identifiers, but I do see a lot of value in allowing for a future
>> where nested checkpoint/restart is an option.
>> 
>> Eric
>>
>
> Hi Eric, thanks a lot for comments! I must admit I never though about
> nested checkpoint/restore simply because even plain and direct CR still
> has a number of problems which are not yet addressed.
>
> As to return such ID in ino field (if I understand you right -- you
> propose to return such ID as inode of kstat structure) -- I don't think
> it would be right either. Instead of one iteface applied to all objects
> we export there will be a few different approaches instead -- for net-ns
> it would be dev+ino, for tasks and other members of task-structure
> it'll be IDs from /proc (as implemented in another patches). I like
> more Kyle's idea about object_id() call which would simply return the
> entrypted ID to user-space and it'll be up to user-space to do anything
> it wants with such pieces of information.

Right now everything thing that is exported is dev+ino.  My objection
is that you are adding yet another interface to get that information.

I already have patches that already implement dev+ino for the namespaces
so I fully expect that to happen independently of your patches.  My
priority is to get the rest of the namespaces exported which requires
a bit more review.

> Yes, there will be no way to restore such IDs later but the interface
> is not supposed to work this way.

It sounds like it won't be possible to retrofit the ability to restore
the IDs later.  If the path to what will be needed to support nested
checkpoint/restore is not clear the user space interface is broken
by design.  And since it is broken by design I say the design needs
to bake more before we think of baking it.

> All this mess only because of lack
> of way to figure out which task resources are shared and which are not.
> Maybe if we can carry CLONE_ flags from copy_process()/unshare()/setns()
> (and which else modify task resources?) inside task_struct and provide
> these flags back to user-space we might not need the IDs helpers at all.
> But I think such approach might end up in a pretty big patch bloating
> the kernel. In turn I wanted to bring as minimum new functionality as
> possible *with* a way to completely turn it off if user don't need it.

The tricky case is file descriptors and file descriptors can be passed
over unix domain sockets in arbitrary ways.

If you can find a way to do this without id helpers that sounds like
a good design.

I have a nasty feeling that by trying to do this piecemeal instead of
in one big system call you are slowly painting yourself into a corner
from which you can not get out.

Eric
