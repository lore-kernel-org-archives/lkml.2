Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759696Ab2CGSxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 13:53:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757586Ab2CGSxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 13:53:35 -0500
Date: Wed, 7 Mar 2012 19:46:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Dmitry ADAMUSHKA (EXT)" <dmitry.adamushka_ext@softathome.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
        wouter.cloetens@softathome.com,
        dmitry adamushko <dmitry.adamushko@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 'khelper' (child) is stuck in endless loop: do_signal() and
	!user_mode(regs)
Message-ID: <20120307184615.GA29005@redhat.com>
References: <1144797072.59663.1331142646789.JavaMail.root@storentr1.softathome.com> <1830531676.59669.1331142673402.JavaMail.root@storentr1.softathome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1830531676.59669.1331142673402.JavaMail.root@storentr1.softathome.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

I can't read this email carefully now, will do tomorrow.

But,

On 03/07, Dmitry ADAMUSHKA (EXT) wrote:
>
> Now, the assumptions (the question is whether these are true for the recent kernels):
>
> 1) TIF_SIGPENDING can be set for 'khelper' while it's running in ____call_usermodehelper()
>    between (a) flush_signal_handlers() and (b) kernel_execve() => so TIF_SIGPENDING is set;

Yes, but it is not khelper. It is another kernel thread. Yes, its
->comm[] was copied from parent, so ps/etc can show it as khelper.

> 2) kernel_execve() can fail in ____call_usermodehelper().
>
> The later one is less of an assumption; let's say, it fails due to a shortage of memory (or whatever).
>
> If (1) is true, then
>
> the pre-conditions:
>
> - a kernel space task;
>
> 'khelper' running ____call_usermodehelper() in our case.
>
> - TIF_SIGPENDING is set.
>
> A signal has been delivered, say, as a result of kill(-1, SIGKILL).
>
> The endless loop is as follows:
>
> * syscall_exit_work:
>  - work_pending:            // start_of_the_loop

We shouldn't be here. This is the kernel thread.

And if start_thread() was already called, then

>  - work_notify_sig:
>    - do_notify_resume()
>      - do_signal()          ==> if (!user_mode(regs)) return; so signals are not handled

user_mode() is no longer true.

Once again, I can be wrong, I'll read this email tomorrow.

Oleg.

