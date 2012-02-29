Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab2B2Uxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 15:53:45 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:24495
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756001Ab2B2Uxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 15:53:42 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F4E9041.1080203@am.sony.com>
Date: Wed, 29 Feb 2012 12:53:21 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Questions about ptrace on a dying process
References: <4F4E6915.1010209@am.sony.com> <20120229185056.GA11757@redhat.com>
In-Reply-To: <20120229185056.GA11757@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 10:50 AM, Oleg Nesterov wrote:
> On 02/29, Tim Bird wrote:
>>
>> ptrace maintainers (and interested parties)...
>>
>> I'm working on a crash handler for Linux, which uses ptrace to retrieve information
>> about a process during it's coredump.  Specifically, from within a core handler
>> program (started within do_coredump() as a user_mode_helper), I would like to make
>> ptrace calls against the dying process.
> 
> Which calls? just curious.

Right now, I'm using:
	PTRACE_ATTACH, PTRACE_GETREGS,
	PTRAGE_PEEKTEXT and PTRACE_GETSIGINFO


>> My problem is that the process state is not entering into TASK_TRACED, when
>> I do an PTRACE_ATTACH against it.
> 
> Yes, it can never do ptrace_stop() in do_coredump() paths.

That's what I figured.

> Perhaps you can use PTRACE_O_TRACEEXIT. PTRACE_EVENT_EXIT will be reported
> after the coredumping. I think the core handler should close the pipe first,
> otherwise the dumping tracee will wait for the handler forever.
>
> However. You need PTRACE_SEIZE, not PTRACE_ATTACH. And this can only work
> with the recent patch from Denys which allows to pass PTRACE_O_TRACEEXIT
> with PTRACE_SEIZE (currently in -mm tree).
> 
> Just in case, it could have other threads sleeping in TASK_UNINTERRUPTIBLE
> until do_coredump() completes. But these threads have already passed
> ptrace_event(PTRACE_EVENT_EXIT).

I'll look at these and see if they might work.  I've determined
that there are some funny races for accessing /proc, using ptrace,
and reading the coredump from stdin (in the core pipe handler)
associated with the technique I'm currently using. Maybe some
of these other ptrace requests or options would help out.

Thanks very much for the suggestions.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

