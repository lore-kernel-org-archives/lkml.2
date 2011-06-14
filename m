Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab1FNWOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 18:14:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228Ab1FNWOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 18:14:22 -0400
Date: Tue, 14 Jun 2011 18:13:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, xiyou.wangcong@gmail.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, jwilson@redhat.com, seiji.aguchi@hds.com
Subject: Re: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about
 kdump_msg hook into crash_kexec())
Message-ID: <20110614221340.GJ2525@redhat.com>
References: <20110203095837.93A2.A69D9226@jp.fujitsu.com>
 <20110203020703.GB21603@redhat.com>
 <20110203135324.93BC.A69D9226@jp.fujitsu.com>
 <20110526131028.7052a893.akpm@linux-foundation.org>
 <4DE3277D.8070109@jp.fujitsu.com>
 <20110531215126.GW16382@redhat.com>
 <4DF0A7B8.6030102@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DF0A7B8.6030102@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 08:00:08PM +0900, KOSAKI Motohiro wrote:
> Hi
> 
> Sorry for the delay. I had got stuck LinuxCon Japan and piled up plenty
> paper works.
> 
> >>> I think I can agree your proposal. But could you please explain why do 
> >>> you think kmsg _before_ kdump and kmsg _in_ kdump are so different? 
> >>> I think it is only C level difference. CPU don't care C function and 
> >>> anyway the kernel call kmsg_dump() because invoke second kernel even 
> >>> if you proposal applied. 
> >>> It is only curious. I'm not against your proposal. 
> >>> Thanks. 
> > 
> > Few reasons.
> > 
> > - There is no correlation between crash_kexec() and kdump_msg(). What
> >   you are creating is equivalent of panic notifiers and calling those
> >   notifiers before dump happened. So calling it inside of crash_kexec()
> >   does not make much sense from code point of view.
> 
> Thank you for the replay. I got you _think_ no makes sense, but I haven't
> explain what you talk about the code of "code point of view".
> If you read the code, you can understand kdump_msg() and panic_notifiers
> are not same point.
> 
> 
> > - Why does somebody need to keep track of event KMSG_DUMP_KEXEC?
> 
> I believe I answered already at last thread.
> 
> http://groups.google.com/group/linux.kernel/browse_thread/thread/1084f406573d76ac/daa1a08804385089?q=kexec%3A+remove+KMSG_DUMP_KEXEC&lnk=ol&
> 

Frankly speaking I never understood it. The only thing I got is that
you are saying embedded devices want to do something upon a KEXEC and
I do not understand what's that action embedded devices want to take
upon an KEXEC.

And it is not just KEXEC, I am also curious about hooks in places
like emergency_restart(). Who needs to know about it and is it
safe to do.

So if would be great if you could explain it in detail again.

> 
> > - There is one kernel CONFIG option introduce which looks completely
> >   superfluous.
> 
> What you mean "superfluous"? We already have billion kernel CONFIG.
> Is it also bad?

We have lots of config options but every config option goes through
some thought process and it is taken in if it makes sense. In this
case this additional config option did not make any sense.

> 
> > My general take on the whole issue.
> > 
> > - In general I think exporting a hook to module so that they can do
> >   anything before crash is a bad idea. Now this can be overloaded to
> >   do things like sending crash notifications in clustered environement
> >   where we recommend doing it in second kernel.
> 
> ??
> It's not my issue and I haven't talked about such thing. I guess you
> confuse I and Aguch-san or someone else.

Once you export the hook to a module, anybody can do that. In the
past people have asked for it reapeatedly. So I am just giving you
one example that what will people start doing once the hook is
there.

> 
> > 
> > - Even if we really have to do it, there seemed to be two concern
> >   areas.
> > 
> > 	- Reliability of kdump_msg() generic infrastructure and its
> >   	  capability in terms of handling races with other cpus and
> > 	  NMIs.
> > 
> > 	- Reliability of module which is getting the callback from
> > 	  kdump_msg().
> 
> Indeed. I thought Aguch-san said he promised he work on improve them.
> However it doesn't happen yet. Okay, I
> 
> 
> >  I think in one of the mails I was discussing that common infrastructure
> >  between kdump and kmsg_dump() can be put in a separate function, like
> >  stopping all cpus etc to avoid races in generic infrastrucutre and
> >  then first we can all kmsg_dump() and then crash_kexec().
> 
> Nice idea! Yes. I didn't think enterprise folks start to use this feature
> and it now happen.
> If nobody are working on this, I'll do it.

It would be great if you could work on it and make sure kdump_msg()
and crash_kexec() could share common infrastructure which takes care
of common actions like stopping cpus, taking care of NMIs and invocation
of panic() on mutliple cpus etc.

> 
> 
> >  But this still does not provide us any protection against modules getting
> >  control after crash and possiblly worsen the situation.
> 
> I think this doesn't big matter. If module author hope to get hook, they
> can use kprobe in nowadays. I don't think we can make perfect kprobe protection.
> I think I wrote this at last thread too.
> 
> Probably most reliability stupid module detect way is, watching lkml and revewing
> kmsg_dump() user conteniously. However, if you strongly worry about this issue,
> I can agree we make tiny foolish module protection. (but I don't have concrete
> idea yet)

I do worry about modules. Once the system has paniced, I personally don't
think that anbody and everybody should be able to look at that event and
take whatever actions they want to.

Having said that personally I like the idea of being able to save 
backtrace on some non volatile storage and access it over next boot
through pstore interface.

So if care is taken to make kmsg_dump() generic infrastructure fool proof
probably it is good start and then we can look into module thing later.

Thanks
Vivek
