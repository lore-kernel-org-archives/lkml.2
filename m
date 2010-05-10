Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0EJHRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 03:17:34 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:59440 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916Ab0EJHRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 03:17:33 -0400
Message-ID: <4BE7B3BD.70901@secunet.com>
Date: Mon, 10 May 2010 09:20:29 +0200
From: Mathias Krause <Mathias.Krause@secunet.com>
User-Agent: Icedove 1.5.0.8 (X11/20061208)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel panic on kill(0, SIGTERM) with PGID == 0
References: <4BE01C86.3050908@secunet.com> <20100509184510.GA15219@redhat.com>
In-Reply-To: <20100509184510.GA15219@redhat.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 May 2010 07:17:30.0066 (UTC) FILETIME=[D9F9F320:01CAF010]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello  Oleg,

Oleg Nesterov wrote:
> sorry for delay, vacation.
>

No problem. Thanks for replying.

>> But it even gets worser because process group 0 contains some
>> special processes, like swapper (PID: 0). Normally swapper will never be
>> reachable for userland because PID 0 is handled special by kill(2) but
>> killing the current process group while having a PGID of 0 will also try
>> to kill those special processes like swapper. This ends in the following
>> kernel null pointer deref:
>>
>> [    3.595820] BUG: unable to handle kernel NULL pointer dereference at 000003a8
> 
> Thanks Mathias.
> 
> I think this should be fixed anyway. Could you try the patch below?

See below.

> 
> In any case swapper should be immune to signals, and its ->thread_group
> should be properly initiallized (the patch does only this).
> 
>> [    3.595820]  [<c012b45b>] __group_send_sig_info+0x7b/0xa0
>> [    3.595820]  [<c012b5bd>] group_send_sig_info+0x5d/0x80
>> [    3.595820]  [<c012b628>] __kill_pgrp_info+0x48/0x70
>> [    3.595820]  [<c012b679>] kill_pgrp_info+0x29/0x40
> 
> Looks like, you kernel is old. Any chance you can also test the recent
> kernel?
> 

It's old because it's the result of bisecting the cause of the problem.
It's actually some 2.6.24 kernel but I could reproduce the bug with
2.6.34-rc4, too.

>> May be a minor bug, because it can be work around by calling setpgid(0,0)
>> in init
> 
> setpgid(0,0) just moves the caller's pgrp from PGID 0, that is why it
> helps.
> 

Right.

>> but I think it should be fixed, anyway.
> 
> Completely agreed.
> 
>> A reproducer is attached. It contains a substitute for init that triggers
>> the bug.
> 
> Thanks.
> 
> I didn't try it, but it looks overcomplicated to trigger this bug, or
> I missed something? Afaics, init could be just
> 
> 	int main(void)
> 	{
> 		kill(0, SIGGKILL);
> 	}
> 
> No?
> 

Yes, sure. Killing the process group, while having a PGID of 0 are the
only prerequisites to trigger this bug. In my example I forked a child
and let it do the call to kill to not have init  (PID 1) beeing killed,
too. The kernel doesn't like that. :)
But your example should also work.


> Oleg.
> 
> We should also change INIT_SIGHAND, but _hopefully_ this is enough
> to fix the crash.
> 
> --- x/include/linux/init_task.h
> +++ x/include/linux/init_task.h
> @@ -172,6 +172,7 @@ extern struct cred init_cred;
>  		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
>  		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
>  	},								\
> +	.thread_group	= LIST_HEAD_INIT(tsk.thread_group),		\
>  	.dirties = INIT_PROP_LOCAL_SINGLE(dirties),			\
>  	INIT_IDS							\
>  	INIT_PERF_EVENTS(tsk)						\
> 
> 

This works for me. Thanks.

Tested-by: Mathias Krause <mathias.krause@secunet.com>
