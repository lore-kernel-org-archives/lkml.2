Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030282Ab2CGUFp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:05:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57559 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748Ab2CGUFn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <20120307184615.GA29005@redhat.com>
References: <1144797072.59663.1331142646789.JavaMail.root@storentr1.softathome.com>
	<1830531676.59669.1331142673402.JavaMail.root@storentr1.softathome.com>
	<20120307184615.GA29005@redhat.com>
Date: Wed, 7 Mar 2012 21:05:43 +0100
Message-ID: <CAO6Zf6C_0e=mdz=iZQtBvVn35Dp6KCBzXfo0PPLm1vs5h7inLA@mail.gmail.com>
Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and !user_mode(regs)
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>,
        Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
        wouter.cloetens@softathome.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

> On 03/07, Dmitry ADAMUSHKA (EXT) wrote:
>>
>> Now, the assumptions (the question is whether these are true for the recent kernels):
>>
>> 1) TIF_SIGPENDING can be set for 'khelper' while it's running in ____call_usermodehelper()
>>    between (a) flush_signal_handlers() and (b) kernel_execve() => so TIF_SIGPENDING is set;
>
> Yes, but it is not khelper. It is another kernel thread. Yes, its
> ->comm[] was copied from parent, so ps/etc can show it as khelper.

Sure, that's why I indicated 'khelper' (child).

>
>> 2) kernel_execve() can fail in ____call_usermodehelper().
>>
>> The later one is less of an assumption; let's say, it fails due to a shortage of memory (or whatever).
>>
>> If (1) is true, then
>>
>> the pre-conditions:
>>
>> - a kernel space task;
>>
>> 'khelper' running ____call_usermodehelper() in our case.
>>
>> - TIF_SIGPENDING is set.
>>
>> A signal has been delivered, say, as a result of kill(-1, SIGKILL).
>>
>> The endless loop is as follows:
>>
>> * syscall_exit_work:
>>  - work_pending:            // start_of_the_loop
>
> We shouldn't be here. This is the kernel thread.

Note that kernel_execve() is backed up by a full fledged syscall (not
just a function call, at least on MIPS and x86), so I assume that all
the usual syscall-related stuff applies here as well.

>
> And if start_thread() was already called, then
>
>>  - work_notify_sig:
>>    - do_notify_resume()
>>      - do_signal()          ==> if (!user_mode(regs)) return; so signals are not handled
>
> user_mode() is no longer true.

!user_mode() is true. Note, the failure of kernel_execve() is one of
the pre-conditions. So we have a kernel thread returning from a real
syscall (hence, syscall_exit and co) with TIF_SIGPENDING.

>
> Once again, I can be wrong, I'll read this email tomorrow.
>

Great, thanks!


-- Dmitry
