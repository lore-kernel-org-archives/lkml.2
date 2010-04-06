Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0DFPRb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 11:17:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37486 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0DFPRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 11:17:25 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Grzegorz Nosek <root@localdomain.pl>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
References: <20100321195044.GA23757@megiteam.pl>
	<20100323212834.GH20796@count0.beaverton.ibm.com>
	<20100325213356.GB20541@megiteam.pl>
	<20100326111131.GA8604@redhat.com>
	<20100326115357.GA3345@count0.beaverton.ibm.com>
	<20100326124522.GD17113@megiteam.pl>
	<20100326134709.GB15790@redhat.com>
	<20100406034443.8B40ED477@magilla.sf.frob.com>
	<20100406135345.GC3345@count0.beaverton.ibm.com>
	<20100406143635.GA12315@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 06 Apr 2010 08:17:21 -0700
In-Reply-To: <20100406143635.GA12315@redhat.com> (Oleg Nesterov's message of "Tue\, 6 Apr 2010 16\:36\:35 +0200")
Message-ID: <m1k4sk8vb2.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: oleg@redhat.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, sukadev@us.ibm.com, root@localdomain.pl, roland@redhat.com, matthltc@us.ibm.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> On 04/06, Matt Helsley wrote:
>>
>> On Mon, Apr 05, 2010 at 08:44:43PM -0700, Roland McGrath wrote:
>>
>> > tracehook_report_clone_complete() call is made when that task_struct is no
>> > longer guaranteed to be valid.
>
> Hmm. I missed this.
>
>> Also, if utrace allows multiple tracers and they each
>> exist in a different namespace then storing a pid nr isn't going to work.
>
> Yes, but utrace is simple. ptrace_report_clone() does
>
> 	ctx->eventmsg = child->pid;
>
> we should fix this line and that is all, afaics. Every tracer has a
> separate "struct ptrace_context *ctx".
>
>> So my hunch is, in the long run, we'll need to hold a reference there and
>> drop it when the last tracer detaches
>
> Without utrace only one tracer is possible.
>
> So, I think we should either change do_fork() to get the right tracee_pid_nr,
> or add get/put into do_fork() and change tracehooks as Roland suggested.

For a unicast path where the is no danger of the destination process changing
I don't see why we can't compute the userspace pid_nr.  It only get's tricky
for things like broadcast signals (pgrp, session) when we don't who the
final recipient process will be.

I think that only gets truly bad in the case of unix domain sockets.

Eric
