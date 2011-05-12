Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1ELQIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 12:08:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308Ab1ELQIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 12:08:30 -0400
Date: Thu, 12 May 2011 18:06:49 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 10/11] ptrace: move JOBCTL_TRAPPING wait to wait(2) and
	ptrace_check_attach()
Message-ID: <20110512160649.GE18599@redhat.com>
References: <1304869745-1073-1-git-send-email-tj@kernel.org> <1304869745-1073-11-git-send-email-tj@kernel.org> <20110511164947.GA26383@redhat.com> <20110511195333.GE24245@mtj.dyndns.org> <20110512102325.GF1030@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110512102325.GF1030@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Wed, May 11, 2011 at 09:53:33PM +0200, Tejun Heo wrote:
> > > As for ptrace_check_attach(), it can simply do wait_event(), we
> > > only need to verify the caller is the tracer. No need to play with
> > > lock/unlock/retry.
> > >
> > > What do you think?
> >
> > Hmmm... interesting.  Yeah, the state is visible only through wait(2)
> > and ptrace(2) and for wait(2) TRAPPING is as good as STOPPED/TRACED
> > and we can wait all we want in ptrace_check_attach().  I'll think more
> > about it but seems like a nice idea.
>
> Eh, problem.  Please consider the following scenario.
>
> * A task is in TASK_STOPPED.  current->exit_code contains zero.
>
> * Tracer seizes the task which triggers TRAPPING.
>
> * Tracer wait(2)s which sees TRAPPING but tracee->exit_code is still
>   zero.

At first glance, this is easy to fix. do_signal_stop() can set
->exit_code unconditionally as it did before.

> I think retrying and ensuring that tracee is in the expected state
> after going through the regular trapping procedure is better way to
> handle this.  Bypassing wait(2) seems smart and simple but it entails
> much more subtleties than simple stupid waiting/retrying.

Agreed. But this wait_event(!TRAPPING) logic has a lot of subtleties
too.

Oleg.

