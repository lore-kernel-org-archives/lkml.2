Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715Ab0FUO0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 10:26:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37658 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab0FUO0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 10:26:23 -0400
To: Linux Containers <containers@lists.osdl.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@parallels.com>
References: <1276706068-18567-1-git-send-email-louis.rilling@kerlabs.com>
	<4C19F0A3.2050707@parallels.com> <m1631hdbdu.fsf@fess.ebiederm.org>
	<20100617213638.GB4182@redhat.com>
	<20100618082738.GE16877@hawkmoon.kerlabs.com>
	<20100618162734.GB7404@redhat.com>
	<20100621111127.GI16877@hawkmoon.kerlabs.com>
	<m1vd9c4k67.fsf@fess.ebiederm.org>
	<20100621141518.GA3773@hawkmoon.kerlabs.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 21 Jun 2010 07:26:15 -0700
In-Reply-To: <20100621141518.GA3773@hawkmoon.kerlabs.com> (Louis Rilling's message of "Mon\, 21 Jun 2010 16\:15\:18 +0200")
Message-ID: <m1iq5c4g3c.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.5.249;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.5.249
X-SA-Exim-Rcpt-To: containers@lists.osdl.org, xemul@parallels.com, linux-kernel@vger.kernel.org, xemul@openvz.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.osdl.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] procfs: Do not release pid_ns->proc_mnt too early
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Louis Rilling <Louis.Rilling@kerlabs.com> writes:

> On 21/06/10  5:58 -0700, Eric W. Biederman wrote:
>> Louis Rilling <Louis.Rilling@kerlabs.com> writes:
>> 
>> > On 18/06/10 18:27 +0200, Oleg Nesterov wrote:
>> >> On 06/18, Louis Rilling wrote:
>> >> >
>> >> > On 17/06/10 23:36 +0200, Oleg Nesterov wrote:
>> >> > > On 06/17, Eric W. Biederman wrote:
>> >> > > >
>> >> > > > The task->children isn't changed until __unhash_process() which runs
>> >> > > > after flush_proc_task().
>> >> > >
>> >> > > Yes. But this is only the current implementation detail.
>> >> > > It would be nice to cleanup the code so that EXIT_DEAD tasks are
>> >> > > never sit in ->children list.
>> >> > >
>> >> > > > So we should be able to come up with
>> >> > > > a variant of do_wait() that zap_pid_ns_processes can use that does
>> >> > > > what we need.
>> >> > >
>> >> > > See above...
>> >> > >
>> >> > > Even if we modify do_wait() or add the new variant, how the caller
>> >> > > can wait for EXIT_DEAD tasks? I don't think we want to modify
>> >> > > release_task() to do __wake_up_parent() or something similar.
>> >> >
>> >> > Indeed, I was thinking about calling __wake_up_parent() from release_task()
>> >> > once parent->children becomes empty.
>> >> >
>> >> > Not sure about the performance impact though. Maybe some WAIT_NO_CHILDREN flag
>> >> > in parent->signal could limit it. But if EXIT_DEAD children are removed from
>> >> > ->children before release_task(), I'm afraid that this becomes impossible.
>> >> 
>> >> Thinking more, even the current do_wait() from zap_pid_ns_processes()
>> >> is not really good. Suppose that some none-init thread is ptraced, then
>> >> zap_pid_ns_processes() will hange until the tracer does do_wait() or
>> >> exits.
>> >
>> > Is this really a bad thing? If somebody ptraces a task in a pid namespace, that
>> > sounds reasonable to have this namespace (and it's init task) pinned.
>> 
>> Louis.  Have you seen this problem hit without my setns patch?
>
> Yes. I hit it with Kerrighed patches.  I also have an ugly reproducer on
> 2.6.35-rc3 (see attachments). Ugly because I introduced artifical delays
> in release_task(). I couldn't trigger the bug without it, probably because the
> scheduler is too kind :)
>
> I'm using memory poisoining (SLAB and DEBUG_SLAB) to make it easy to observe the
> bug.
>
> Example:
> # ./proc_flush_task-bug-reproducer 1
>
>> 
>> I'm pretty certain that this hits because there are processes do_wait
>> does not wait for, in particular processes in a disjoint process tree.
>
> Indeed do_wait() misses EXIT_DEAD children.
>
>> 
>> So at this point I am really favoring killing the do_wait and making
>> this all asynchronous.
>
> Any idea about how to do it?

Some variant of the patches Oleg just recently posted.  I'm still not
comfortable with the extending the kernel mount to the entire lifetime
of the pid_namespace.  But it certainly is better than a lot of the
alternatives.


Eric
