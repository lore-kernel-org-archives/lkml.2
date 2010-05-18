Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0ERRxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:53:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43897 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab0ERRxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:53:24 -0400
MIME-Version: 1.0
Message-ID: <1dc4abc2-6455-4b95-90f6-c86bf56ff39a@default>
Date: Tue, 18 May 2010 10:49:55 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <1273887635-27610-1-git-send-email-venki@google.com>>
 <87tyq9mqrz.fsf@basil.nowhere.org>>
 <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>>
 <20100515121424.38f5b389@infradead.org>>
 <e07ac2f3-4a82-41d9-aa41-49a94435e7b7@default>>
 <20100515224305.17a04022@infradead.org>>
 <alpine.LFD.2.00.1005161113450.3199@localhost.localdomain>>
 <5adf3fee-0f7b-4039-b13f-619640cc4b88@default>>
 <20100516220638.2baf315d@infradead.org> <1274176698.5605.7358.camel@twins>>
 <20100518112509.GD22675@basil.fritz.box> <1274183935.5605.7726.camel@twins>>
 <4BF2C30F.6030502@zytor.com> <1274201536.5605.8347.camel@twins
 4BF2C881.60807@zytor.com>
In-Reply-To: <4BF2C881.60807@zytor.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BF2D3F1.00DF:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Tuesday, May 18, 2010 11:04 AM
> To: Peter Zijlstra
> Cc: Andi Kleen; Arjan van de Ven; Dan Magenheimer; Thomas Gleixner;
> Venkatesh Pallipadi; Ingo Molnar; Chris Mason; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] x86: Export tsc related information in sysfs
> 
> On 05/18/2010 09:52 AM, Peter Zijlstra wrote:
> > On Tue, 2010-05-18 at 09:40 -0700, H. Peter Anvin wrote:
> >>
> >> The problem is that you throw the baby (vsyscall) out with the
> bathwater
> >> (user rdtsc).
> >
> > Well, we could only flip the CR4 bit when we mark the TSC unsuitable
> for
> > gtod. That should be plenty good to tag all userspace trying to use
> it,
> > since more than half my machines don't use TSC for clocksource.
> 
> This might be an option, although it would have to be an *option*.
> There are restricted uses of the TSC in userspace which are still
> useful
> (mainly involving performance analysis and/or CPU-locked processes).

(Though I expect tglx/arjan/andi/mingo to disagree with this proposal
for similar reasons as the original one that started this thread...)

Proposal:

/sys/devices/system/tsc/native (writable by root):

0 = (default) Kernel dynamically controls TSC emulation.
  When the kernel deems TSC usable as a clocksource, rdtsc
  will be executed directly by the CPU.  When the kernel deems
  TSC unsafe to use, rdtsc will be trapped and emulated.
1 = TSC emulation is never enabled.  Programs using rdtsc
  directly are subject to the many known and sometimes rare
  and subtle vagaries of TSC.
2 = TSC emulation is always enabled (for debug only)
3 = Processes using TSC will be treated as if they executed
  an illegal instruction.  [? Can the kernel recognize
  use of rdtsc in a vsyscall and emulate so that,
  even though vsyscall is slower, all other rdtsc
  in userspace are illegal?] [? Can/should this be
  enforced only on non-root processes?]

/sys/devices/system/tsc/system_count (writable by root):

Contains a count of all TSC emulations, system-wide.
Writable to allow reset to zero.

/sys/devices/system/tsc/pid_counters (writable by root):

0 = (default) TSC counts are system-wide only
1 = TSC counted per pid (at performance penalty)
    counters in /proc/PID/tsc_count

/proc/PID/tsc_count (readonly):

If /sys/devices/system/tsc_pid_counters is 1,
contains the count of rdtsc instructions emulated
for this PID.

(Note: except for the actual instruction emulation
which will be faithful, rdtscp will be treated and
counted as a rdtsc.)
