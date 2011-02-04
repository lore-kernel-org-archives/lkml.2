Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1BDPAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:00:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab1BDPAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:00:49 -0500
Date: Fri, 4 Feb 2011 10:00:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>
Subject: Re: Query about kdump_msg hook into crash_kexec()
Message-ID: <20110204150047.GC32190@redhat.com>
References: <20110203020528.GA21603@redhat.com>
 <20110203121302.93B9.A69D9226@jp.fujitsu.com>
 <20110203141850.93C2.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203141850.93C2.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 02:20:53PM +0900, KOSAKI Motohiro wrote:
> > AFAIK, kexec is used sneak rebooting way when the system face unexpected
> > scenario on some devices. (Some embedded is running very long time, then 
> > it can't avoid memory bit corruption. all of reset is a last resort. 
> > and a vendor gather logs at periodically checkback).
> > 
> > The main purpose of to introduce KMSG_DUMP_KEXEC is to be separate it
> > from KMSG_DUMP_PANIC. At kmsg_dump() initial patch, KMSG_DUMP_PANIC 
> > is always called both kdump is configured or not. But it's no good idea
> > the same log is to be appeared when both kexec was successed and failured.
> > Moreover someone don't want any log at kexec phase. They only want logs
> > when real panic (ie kexec failure) route. Then, I've separated it to two.
> > Two separated argument can solve above both requreiment.
> 
> A bit additional explanation, An original patch have kmsg_dump(KMSG_DUMP_PANIC)
> callsite at following point. I didn't think it makes either embedded or 
> kdump folks happiness. Thus I moved it after crash_kexec().
> 
> 
> ---------------------------------------------------------------------
> @@ -74,6 +75,7 @@ NORET_TYPE void panic(const char * fmt, ...)
>         dump_stack();
>  #endif
> 
> +       kmsg_dump(KMSG_DUMP_PANIC);
>         /*
>          * If we have crashed and we have a crash kernel loaded let it handle
>          * everything else.
>          * Do we want to call this before we try to display a message?
>          */
>         crash_kexec(NULL);
> ---------------------------------------------------------------------

And I think to compensate for that somebody introduced additional
kmsg_dump(KEXEC) call inside crash_kexec() and put it under CONFIG
option so that one can change the behavior based on config options.

I think this makes the logic somewhat twisted and an unnecessary call
inside crash_kexec(). So until and unless there is a strong reason we
can get rid of KEXEC event and move kmsg_dump call before crash_kexec()
for now and see how does it go, IMHO.

Vivek
