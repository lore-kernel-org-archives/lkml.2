Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1CWQt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:49:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755Ab1CWQtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:49:55 -0400
Date: Wed, 23 Mar 2011 17:40:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 1/8] job control: Don't set group_stop exit_code if
	re-entering job control stop
Message-ID: <20110323164014.GA22527@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-2-git-send-email-tj@kernel.org> <20110321132024.GA18777@redhat.com> <20110321155250.GE12003@htj.dyndns.org> <20110322184415.GA28038@redhat.com> <20110323084421.GW12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110323084421.GW12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23, Tejun Heo wrote:
>
> Hello,
>
> On Tue, Mar 22, 2011 at 07:44:15PM +0100, Oleg Nesterov wrote:
> > Suppose that debugger PTRACE_CONTs the stopped thread and then it
> > gets SIGSTOP and calls do_signal_stop() again. In theory this all is
> > possible before SIGNAL_STOP_STOPPED. This can confuse real_parent.
> > Say, real_parent itself sends SIGTTIN to the child and naturally
> > expects WIFSTOPPED() == SIGTTIN.
>
> Hmmm... There are two competing signals in that case - SIGTTIN sent by
> the parent and SIGSTOP sent by someone else.

"someone else" can be PTRACE_CONT(SIGSTOP) from the debugger.

> I can't think of a scenario where the parent would be able to
> differentiate the two signals (in the sense that it can say the latter
> is the wrong signal).  If you can, please share.

I didn't mean this is really wrong or can lead to some problems.
Just this looks inconsistent a bit.

> > Not sure I understand... We are setting GROUP_STOP_PENDING | CONSUME
> > again. T2 has already reported ptrace_stop(CLD_STOPPED) to the tracer.
> > It is stopped. Now it will report another CLD_STOPPED after PTRACE_CONT.
>
> Okay, I see.  Maybe we should discern between traced for group stop
> from other traps but then again given the group stop re-entering while
> ptraced it can be considered a relatively consistent behavior.  Yeah,
> but probably better to remove the double reporting.

Yes. I have a vague feeling a new GROUP_STOP_YES_I_AM_STOPPED can
be useful anyway. It should be set by task_participate_group_stop()
if the task participates. We will see.

Oleg.

