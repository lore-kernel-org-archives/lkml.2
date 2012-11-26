Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191Ab2KZM1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 07:27:05 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:51460 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab2KZM1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 07:27:03 -0500
MIME-Version: 1.0
In-Reply-To: <20121126094403.GB10312@moon>
References: <20121121141627.GB21030@redhat.com>
	<20121121173043.F0319592076@miso.sublimeip.com>
	<20121122161238.GA27078@redhat.com>
	<20121126094403.GB10312@moon>
Date: Mon, 26 Nov 2012 16:27:01 +0400
Message-ID: <CANaxB-yCSrUMQbjrZPMoHp0hN+uUuRDCW6yRazFYX1YR_di9dQ@mail.gmail.com>
Subject: Re: vdso && cr (Was: arch_check_bp_in_kernelspace: fix the range check)
From: Andrey Wagin <avagin@gmail.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Amnon Shiloh <u3557@miso.sublimeip.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/26 Cyrill Gorcunov <gorcunov@openvz.org>:
> On Thu, Nov 22, 2012 at 05:12:38PM +0100, Oleg Nesterov wrote:
>> On 11/22, Amnon Shiloh wrote:
>> >
>> > Now however, that "vsyscall" was effectively replaced by vdso, it
>> > creates a new problem for me and probably for anyone else who uses
>> > some form of checkpoint/restore:
>>
>> Oh, sorry, I can't help here. I can only add Cyrill and Pavel, they
>> seem to enjoy trying to solve the c/r problems.
>
> Hi Oleg, Amnon, sorry for delay on this message. First of all, I'm
> not vDSO specialist but as to c/r aspect of it I've had in mind the
> the following scenario: we dump vDSO area either complete euther simply
> remember the functions addresses it provides, then on restore we replace
> the functions prologue with jmp instruction which would point to the
> vDSO entries provided us by a kernel. But again, I didn't spend much time
> for vDSO yet.

I think this approach should work. Here is a bit more details:
1. A task will be not dumped in vdso code. If a task is in vdso code,
we will try to catch it again.
2. Only addresses of vdso symbols will be dumped.
3. On restore we will compare addresses of symbols. If addresses are
not changes, a new vdso will be mapped instead of old one. If they are
changed, a new vdso will be mapped in a free space and the old vdso
will be replaced on a proxy library, where all functions are replaced
on jumps to suitable functions in the new vdso.

Looks simple and does not required to hack a kernel.

>
>         Cyrill
