Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1BDO6G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 09:58:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621Ab1BDO6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 09:58:04 -0500
Date: Fri, 4 Feb 2011 09:58:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110204145801.GB32190@redhat.com>
References: <20110203094715.939C.A69D9226@jp.fujitsu.com>
 <20110203020528.GA21603@redhat.com>
 <20110203121302.93B9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203121302.93B9.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 01:52:01PM +0900, KOSAKI Motohiro wrote:

[..]
> > Seconly there are two more important things.
> > 
> > - Why do you need a notification from inside crash_kexec(). IOW, what
> >   is the usage of KMSG_DUMP_KEXEC.
> 
> AFAIK, kexec is used sneak rebooting way when the system face unexpected
> scenario on some devices. (Some embedded is running very long time, then 
> it can't avoid memory bit corruption. all of reset is a last resort. 
> and a vendor gather logs at periodically checkback).
> 
> The main purpose of to introduce KMSG_DUMP_KEXEC is to be separate it
> from KMSG_DUMP_PANIC. At kmsg_dump() initial patch, KMSG_DUMP_PANIC 
> is always called both kdump is configured or not. But it's no good idea
> the same log is to be appeared when both kexec was successed and failured.
> Moreover someone don't want any log at kexec phase. They only want logs
> when real panic (ie kexec failure) route. Then, I've separated it to two.
> Two separated argument can solve above both requreiment.

This point is not very clear to me. Let me add some details.

- crash_kexec() path is not taken during regular kexec boot. It is only
  taken when first kernel has crashed and we want to boot in kdump
  kernel

- If kdump fails, most likely you will either be hung or panic in second
  kernel or something like that.

- Current code looks as follows.

        if (mutex_trylock(&kexec_mutex)) {
                if (kexec_crash_image) {
                        struct pt_regs fixed_regs;

                        kmsg_dump(KMSG_DUMP_KEXEC);

                        crash_setup_regs(&fixed_regs, regs);
                        crash_save_vmcoreinfo();
                        machine_crash_shutdown(&fixed_regs);
                        machine_kexec(kexec_crash_image);
                }
                mutex_unlock(&kexec_mutex);

If a kdump kernel is not loaded you will call kmsg_dump(PANIC) and if
a kdump kernel is loaded you will call kmsg_dump(KEXEC). This is
irrespective of the fact whether kdump succeeds or fails.

- ramoops driver is not differentiating between KMSG_DUMP_KEXEC or
  KMSG_DUMP_PANIC. Similiarly mtdoops driver is not differentiating
  between two reasons. IOW, to me there does not seem to be any difference
  between events KMSG_DUMP_KEXEC and KMSG_DUMP_PANIC.

So we should simply get rid of extra event KMSG_DUMP_KEXEC?

> 
> 
> > - One can anyway call kmsg_dump() outside crash_kexec() before it so
> >   that kmsg_dump notification will go out before kdump gets the control.
> >   What I am arguing here is that it is not necessarily a very good idea
> >   because external modules can try to do any amount of unsafe actions
> >   once we export the hook.
> 
> I wrote why I don't think I added new risk. (shortly, It can be a lot of
> another way)
> Can you please tell me your view of my point? I'm afraid I haven't 
> understand your worry. So, I hope to understand it before making 
> alternative fixing patch.

Once you provide a hook to modules they can try doing anything. As long
as modules keep it really simple, it probably is fine. But what if
they start doing some writes to regular file system/devices in an 
attempt to save kernel logs or even some more data and that can lead
to hard lockups or further corruption and possibly resulting in kdump
not even getting a chance to run.

> 
> >   Doing this is still fine if kdump is not configured as anyway syste would
> >   have rebooted. But if kdump is configured, then we are just reducing
> >   the reliability of the operation by passing the control in the hands
> >   of unaudited code and trusting it when kernel data structures are
> >   corrupt.
> 
> At minimum, I'm fully agree we need reliable kdump. I only put a doubtness
> this removing is a real solution or not.
> 
> >   So to me, sending out kmsg_dump notifications are perfectly fine when
> >   kdump is not configured. But if it is configured, then it probably is
> >   not a good idea. Anyway, if you have configured the system to capture
> >   the full dump, why do you also need kmsg_dump. And if you are happy
> >   with kmsg_dump() then you don't need kdump. So these both seem to be
> >   mutually exclusive anyway.
> 
> Honestly, I haven't heared anyone are using both at the same time. But
> I can guess some reason. 1) If the system is very big box, kdump is
> really slooooooow operation. example Some stock exchange system have half
> terabytes memory and it mean dump delivery need to hald days at worse. But
> market should open just 9:00 at next day. So, summry information (eg log and
> trace information) spoiling is important thing. 2) Two sequence crash (ie
> crash kdump reboot-start next-crash-before-finish-reboot) can override former
> dump image. Usually admin _guess_ the reason of two are same and report boss so.
> But unfortunatelly customers at high end area often refuse a _guess_ report.
> 
> Or, it's for business competition reason. As far as I heared, IBM and HP 
> UNI*X system can save the logs both dump and special flash device. 
> 
> PS: FWIW, Hitach folks have usage idea for their enterprise purpose, but 
>     unfortunately I don't know its detail. I hope anyone tell us it.

If we keep the kmsg dump driver simple I guess things will be just fine in
most of the cases. So as I said in other mail, I am fine with kmsg
notifications being sent before crash_kexec(). Atleast we can audit in
kernel driver code and bigger worry is vendor specific outside the tree
modules. But I think we can live with that and down the line possibly
provide a tunable to change this behavior if it becomes an issue.

So until and unlesss we have a very clear reason of differentiating
between KEXEC and PANIC event, lets get rid of it. So far I have not
been able to understand what's the difference between two.

Thanks
Vivek 
