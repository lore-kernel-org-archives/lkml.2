Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668Ab2ADSTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:19:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56174 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2ADSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:19:48 -0500
Date: Wed, 4 Jan 2012 22:19:43 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 2/4] proc: Show namespaces IDs in /proc/pid/ns/* files
Message-ID: <20120104181943.GJ2621@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.725686255@openvz.org>
 <m1d3b0gg3r.fsf@fess.ebiederm.org>
 <20120104112632.GH2621@moon>
 <m1pqezfj1z.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1pqezfj1z.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 09:56:24AM -0800, Eric W. Biederman wrote:
...
> >
> > Hi Eric, thanks a lot for comments! I must admit I never though about
> > nested checkpoint/restore simply because even plain and direct CR still
> > has a number of problems which are not yet addressed.
> >
> > As to return such ID in ino field (if I understand you right -- you
> > propose to return such ID as inode of kstat structure) -- I don't think
> > it would be right either. Instead of one iteface applied to all objects
> > we export there will be a few different approaches instead -- for net-ns
> > it would be dev+ino, for tasks and other members of task-structure
> > it'll be IDs from /proc (as implemented in another patches). I like
> > more Kyle's idea about object_id() call which would simply return the
> > entrypted ID to user-space and it'll be up to user-space to do anything
> > it wants with such pieces of information.
> 
> Right now everything thing that is exported is dev+ino.  My objection
> is that you are adding yet another interface to get that information.
> 
> I already have patches that already implement dev+ino for the namespaces
> so I fully expect that to happen independently of your patches.  My
> priority is to get the rest of the namespaces exported which requires
> a bit more review.
> 

Ah, good to know, could you please point me where I can get them and try
at least dev+ino part out?

> > Yes, there will be no way to restore such IDs later but the interface
> > is not supposed to work this way.
> 
> It sounds like it won't be possible to retrofit the ability to restore
> the IDs later.  If the path to what will be needed to support nested
> checkpoint/restore is not clear the user space interface is broken
> by design. And since it is broken by design I say the design needs
> to bake more before we think of baking it.
> 

I'm not against of chaging/improving design at all. If there some other
ways to retrieve this kind of information I'm gladly dropping patches
piece-by-piece.

> > All this mess only because of lack
> > of way to figure out which task resources are shared and which are not.
> > Maybe if we can carry CLONE_ flags from copy_process()/unshare()/setns()
> > (and which else modify task resources?) inside task_struct and provide
> > these flags back to user-space we might not need the IDs helpers at all.
> > But I think such approach might end up in a pretty big patch bloating
> > the kernel. In turn I wanted to bring as minimum new functionality as
> > possible *with* a way to completely turn it off if user don't need it.
> 
> The tricky case is file descriptors and file descriptors can be passed
> over unix domain sockets in arbitrary ways.
> 

Not really, what about other members of task-structure, such as mm, files
and others? If I export this bits I have to export them somehow in a safe
way which would not reveal too much of kernel internals.

> If you can find a way to do this without id helpers that sounds like
> a good design.
> 

Yes, I'm trying to find some other way but without much luck at moment.
Once I have something to show -- of course I send it to lkml immediately.

> I have a nasty feeling that by trying to do this piecemeal instead of
> in one big system call you are slowly painting yourself into a corner
> from which you can not get out.
> 

Yes again, that was the reason the patches flew to LKML -- just
to obtain as much comments as possible and find some sane way.

	Cyrill
