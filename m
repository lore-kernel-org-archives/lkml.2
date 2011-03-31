Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706Ab1CaRlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:41:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:36537 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1CaRlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:41:05 -0400
Message-ID: <4D94BC9D.3040009@windriver.com>
Date: Thu, 31 Mar 2011 12:40:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Dongdong Deng <libfetion@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        KGDB Mailing List <Kgdb-bugreport@lists.sourceforge.net>
Subject: Re: [PATCH -tip] kgdb, x86: Pull up NMI notifier handler priority
References: <4D8A58E1.5090509@openvz.org>	<AANLkTimU3Hw5ZSo86Fv4RUtNPtS3kZBoWm4kh4MQaymu@mail.gmail.com> <AANLkTim_EDeYGu6_rsSh_3zDTW7mN5+Gwsb0t4HjKx6o@mail.gmail.com>
In-Reply-To: <AANLkTim_EDeYGu6_rsSh_3zDTW7mN5+Gwsb0t4HjKx6o@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Mar 2011 17:40:45.0224 (UTC) FILETIME=[C37AFA80:01CBEFCA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 12:24 AM, Cyrill Gorcunov wrote:
> If Jason is ok with such splitting -- I dont mind either ;)
>
> On Thursday, March 24, 2011, Dongdong Deng <libfetion@gmail.com> wrote:
>> On Thu, Mar 24, 2011 at 4:32 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>>> kgdb needs IPI to be sent and handled before perf
>>> or anything else NMI, otherwise kgdb hangs with bootup
>>> self-tests (found on P4 HT SMP machine). Raise its priority
>>> so that we're called first in a notifier chain.
>>>

I talked with Cyrill outside the mailing list since he pinged me and I will summarize here.

My initial thought about the patch Deng Dongdong posted was that it was really ugly to have kgdb registered in the notifier chain twice.  I would be willing to live with this for now if we agree that when jump labels are merged to the kernel that we can make use of that instead.

The jump labels would allow us to invoke the debugger directly when the debugger is active much like we do when CONFIG_KGDB_LOW_LEVEL_TRAP is set.  In fact the code that is ifdef'ed with CONFIG_KGDB_LOW_LEVEL_TRAP can make use of the same jump label as the NMI entry and no longer be #ifdef'ed when jump labels come to pass.

The very discussion of the patch raised the question of "why not always have the debugger be first?"  The answer for that lies in that some code needs to run before the debugger to keep the system running assuming you are planning on restarting it after entering the debugger.   The generic die notifier is used for lots of circumstances and the priority the debugger cares about only matter for a select few exception types.

The kmmio, mce-inject, and crash_nmi_nb (from reboot.c) are good examples of in tree code that should run with a higher priority than the debugger because the debugger doesn't know what to do with these code paths, so it sits last in line hoping someone else will deal with the exception else enter the debugger.  For the trap paths the debugger needs to be first in line to deal with the case where where a breakpoint is in a notifier to avoid non-recoverable recursive faults. For NMI it appears we need to run before the perf code or the perf code will eat an nmi event intended for kgdb and result in a dead locked system.

The net result.   I'll sign-off on the kgdb change and add a TODO item to wait for the jump patching to enter the kernel.

Cyrill, I am assuming this is something we want to aim to merge into the 2.6.39 as a regression fix?  I'll try to get a version of Deng Dongdong's patch into linux-next as soon as possible in the mean time.

Cheers,
Jason.
