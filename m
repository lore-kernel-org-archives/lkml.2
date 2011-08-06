Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab1HFNQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 09:16:09 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42489 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab1HFNQF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 09:16:05 -0400
MIME-Version: 1.0
In-Reply-To: <20110806130037.GD23937@htj.dyndns.org>
References: <20110806121247.GC23937@htj.dyndns.org> <4E3D3768.3070108@mit.edu> <20110806130037.GD23937@htj.dyndns.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sat, 6 Aug 2011 09:15:45 -0400
X-Google-Sender-Auth: uCY4ukHT9wXsSdvvtd4cRgNfCSg
Message-ID: <CAObL_7FeZQpnOzpXHqSviZdBRUCL+rODbQOBb+6JPSd3PB=fig@mail.gmail.com>
Subject: Re: [EXAMPLE CODE] Parasite thread injection and TCP connection hijacking
To: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@us.ibm.com>, Pavel Emelyanov <xemul@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, S@mit.edu,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 6, 2011 at 9:00 AM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Sat, Aug 06, 2011 at 08:45:28AM -0400, Andy Lutomirski wrote:
>> > 2. Decide where to inject the foreign code and save the original code
>> >    with PTRACE_PEEKDATA.  Tracer can poke any mapped area regardless
>> >    of protection flags but it can't add execution permission to the
>> >    code, so it needs to choose memory area which already has X flag
>> >    set.  The example code uses the page the %rip is in.
>>
>> If the process is executing from the vsyscall page, then you'll
>> probably fail.  (Admittedly, this is rather unlikely, given that the
>> vsyscalls are now exactly one instruction.)  Presumably you also
>> fail if executing from a read-only MAP_SHARED mapping.
>
> Heh, yeah, I originally thought about scanning /proc/PID/maps to look
> for the page to use but was lazy and just used %rip.  I think that
> should work.  I'll note the problem in README.
>
>> Windows has a facility to more-or-less call mmap on behalf of
>> another process, and another one to directly inject a thread into a
>> remote process.  It's traditional to use them for this type of
>> manipulation. Perhaps Linux should get the same thing.  (Although
>> you could accomplish much the same thing if you could create a task
>> with your mm but the tracee's fs.)
>
> Actually, the only thing we need on x86_64 is two bytes for the
> syscall instruction because all params are passed through registers
> anyway.  We can just set up parameters for mmap, turn on single step,
> point %rip to syscall in the vsyscall page.  So, either way, I don't
> think this would be too difficult to solve.

Not any more -- that syscall instruction is gone as of 3.1.  You could
search through the vdso to find a syscall, but that seems fragile.

Why not just add a ptrace command to issue a syscall?

--Andy
