Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab1BCEwI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:52:08 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36988 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1BCEwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:52:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Cc: kosaki.motohiro@jp.fujitsu.com,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
In-Reply-To: <20110203020528.GA21603@redhat.com>
References: <20110203094715.939C.A69D9226@jp.fujitsu.com> <20110203020528.GA21603@redhat.com>
Message-Id: <20110203121302.93B9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Feb 2011 13:52:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Feb 03, 2011 at 09:55:41AM +0900, KOSAKI Motohiro wrote:
> > Hi
> > 
> > > Hi,
> > > 
> > > I noticed following commit which hooks into crash_kexec() for calling
> > > kmsg_dump().
> > > 
> > > I think it is not a very good idea to pass control to modules after
> > > crash_kexec() has been called. Because modules can try to take locks
> > > or try to do some other operations which we really should not be doing
> > > now and fail kdump also. The whole design of kdump is built on the
> > > fact that in crashing kernel we do minimal thing and try to make 
> > > transition to second kernel robust. Now with this hook, kmsg dumper
> > > breaks that assumption.
> > 
> > I guess you talked about some foolish can shoot their own foot. if so,
> > Yes. Any kernel module can make kernel panic or more disaster result.
> 
> Yes, the difference is that once a fool shoots his foot, kernel tries
> to take a meaningful action to figure out what went wrong. Like displayig
> an oops backtrace or like dumping a core (if kdump is configured) so
> that one can figure out who was the fool and what did who do.
> 
> Now think give the control to two fools. First fool shoots his foot
> and then kernel transfers the control to another fool which completely
> screws up the situation and one can not save the core.

If you really want to full control, you should disable CONFIG_MODULES,
kprobes, ftrace and perf. We have a lot of kernel capturing way already.
So, only one feature diabling don't solve anything. Alternatively, 
I can imagine to improve security modules and audit loaded kernel 
module (and other injection code) more carefully.

So, I'm curious why do you hate so much a part of them and not all of them.



> > > Anyway, if an image is loaded and we have setup to capture dump also
> > > why do we need to save kmsg with the help of an helper. I am assuming
> > > this is more of a debugging aid if we have no other way to capture the
> > > kernel log buffer. So if somebody has setup kdump to capture the
> > > vmcore, why to call another handler which tries to save part of the
> > > vmcore (kmsg) separately.
> > 
> > No.
> > 
> > kmsg_dump() is desingned for embedded.
> 
> Great. And I like the idea of trying to save some useful information 
> to non volatile RAM or flash or something like that.

Yeah, thanks.

> 
> > kexec for non dumping purpose. (Have you seen your embedded devices 
> > show "Now storing dump image.." message?)
> 
> No I have not seen. Can you explain a bit more that apart from kernel
> dump, what are the other purposes of kdump. 
> 
> > 
> > Anyway, you can feel free to avoid to use ksmg_dump().
> 
> Yes, that is one more way but this information is not even exported to
> user space to figure out if there are any registerd users of kmsg_dump.
> 
> Seconly there are two more important things.
> 
> - Why do you need a notification from inside crash_kexec(). IOW, what
>   is the usage of KMSG_DUMP_KEXEC.

AFAIK, kexec is used sneak rebooting way when the system face unexpected
scenario on some devices. (Some embedded is running very long time, then 
it can't avoid memory bit corruption. all of reset is a last resort. 
and a vendor gather logs at periodically checkback).

The main purpose of to introduce KMSG_DUMP_KEXEC is to be separate it
from KMSG_DUMP_PANIC. At kmsg_dump() initial patch, KMSG_DUMP_PANIC 
is always called both kdump is configured or not. But it's no good idea
the same log is to be appeared when both kexec was successed and failured.
Moreover someone don't want any log at kexec phase. They only want logs
when real panic (ie kexec failure) route. Then, I've separated it to two.
Two separated argument can solve above both requreiment.


> - One can anyway call kmsg_dump() outside crash_kexec() before it so
>   that kmsg_dump notification will go out before kdump gets the control.
>   What I am arguing here is that it is not necessarily a very good idea
>   because external modules can try to do any amount of unsafe actions
>   once we export the hook.

I wrote why I don't think I added new risk. (shortly, It can be a lot of
another way)
Can you please tell me your view of my point? I'm afraid I haven't 
understand your worry. So, I hope to understand it before making 
alternative fixing patch.

>   Doing this is still fine if kdump is not configured as anyway syste would
>   have rebooted. But if kdump is configured, then we are just reducing
>   the reliability of the operation by passing the control in the hands
>   of unaudited code and trusting it when kernel data structures are
>   corrupt.

At minimum, I'm fully agree we need reliable kdump. I only put a doubtness
this removing is a real solution or not.

>   So to me, sending out kmsg_dump notifications are perfectly fine when
>   kdump is not configured. But if it is configured, then it probably is
>   not a good idea. Anyway, if you have configured the system to capture
>   the full dump, why do you also need kmsg_dump. And if you are happy
>   with kmsg_dump() then you don't need kdump. So these both seem to be
>   mutually exclusive anyway.

Honestly, I haven't heared anyone are using both at the same time. But
I can guess some reason. 1) If the system is very big box, kdump is
really slooooooow operation. example Some stock exchange system have half
terabytes memory and it mean dump delivery need to hald days at worse. But
market should open just 9:00 at next day. So, summry information (eg log and
trace information) spoiling is important thing. 2) Two sequence crash (ie
crash kdump reboot-start next-crash-before-finish-reboot) can override former
dump image. Usually admin _guess_ the reason of two are same and report boss so.
But unfortunatelly customers at high end area often refuse a _guess_ report.

Or, it's for business competition reason. As far as I heared, IBM and HP 
UNI*X system can save the logs both dump and special flash device. 

PS: FWIW, Hitach folks have usage idea for their enterprise purpose, but 
    unfortunately I don't know its detail. I hope anyone tell us it.



