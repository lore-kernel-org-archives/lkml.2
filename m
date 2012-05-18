Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725Ab2ERNX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 09:23:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761708Ab2ERNX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 09:23:56 -0400
Message-ID: <4FB64D5B.1030301@redhat.com>
Date: Fri, 18 May 2012 10:23:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v24b] RAS: Add a tracepoint for reporting memory controller
 events
References: <1337287277-523-1-git-send-email-mchehab@redhat.com> <20120517214859.GA16777@aftab.osrc.amd.com> <20120518071244.GE429@gmail.com> <20120518095638.GA20215@aftab.osrc.amd.com> <4FB62BAB.90808@redhat.com> <20120518124338.GJ20215@aftab.osrc.amd.com>
In-Reply-To: <20120518124338.GJ20215@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 18-05-2012 09:43, Borislav Petkov escreveu:

(offensive/ironic comments skipped)

> you fail to see that I'm trying to make this as generic as possible and
> not fit it into anything so that EVERYONE can use it.

Tracepoints are generic enough. Everyone can use it. If need new fields are
needed, just add a new tracepoint. Converting it into a new printk way
won't make it usable by everyone. It will just make the ABI unstable.

For sure the fields required for memory errors are different than the ones
required by PCI, CPU or other types of hardware.

>> There are several issues on relying at the Kernel error counters: they
>> don't have decay or any other kind of logic that would allow detecting
>> bursts.
> 
> Guess what, you can do decay very successfully in userspace.

Yes, if and only if userspace receives the errors on a proper way.

>> So, on a machine running for 30 days with, let's say, 10 corrected
>> errors, it is not possible to tell if they were all generated on a
>> burst (because of some temporary interference) or if they are sparse
>> errors generated at the same DRAM, indicating a bad memory.
> 
> Why not, you don't have timestamps?

At the error counters? No.

There are timestamps at printk's, but printk's can't be reliably parsed, as
formats are not consistent among drivers, and the "ABI" can break on every 
Kernel release.

>> With this simple change, the tool can be improved to provide a more
>> consistent memory error report, as userspace should not be worried on
>> parsing fields that may change in future without notice.
> 
> Which userspace, your userspace? What happens if another userspace comes
> with slightly different error formatting requirements? We change the
> kernel again or we can't because this tracepoint is being used and we
> add another tracepoint and let the bloat begin?

As said before, this is not about error formatting requirements! TP_printk() macro
does formatting. I'm not discussing TP_printk() output.

All Userspace tools require access to the error fields.

The real issue with tracepoint is to provide access to the structured data that
userspace needs (so, what fields should be exported), and not about what printk
formats. With regards to the printk format there's already an agreement that
seems to satisfy you, me and Tony.

By adding all fields there at the tracepoint, no changes will be needed inside
Kernel to satisfy any userspace requirements, and the ABI will be reliable and
stable.

>> Also, doing that will avoid the extra effort of joining everything into
>> a single string, and then breaking them back into their individual fields
>> on userspace.
> 
> I'm being told this is very easy to do in userspace in your garden
> variety language.

Well, ask the one that told you that to write a parser that will get all 
EDAC error reports on all drivers, on several kernel versions using dmesg.
This is not easy, as the messages are not consistent, the right fields are 
sometimes at the wrong places, and different kernel versions have different
printk's.

Just to give you an example, this is how sb_edac currently outputs an error:

EDAC MC1: CE row 10, channel 0, label "DIMM_5": 1 Unknown error(s): memory scrubbing on FATAL area : cpu=6 Err=0008:00c2 (ch=2), addr = 0x22719d0780 => socket=1, Channel=3(mask=8), rank=4

The above error happened at the memory controlled by the second CPU socket,
at slot #1 of channel 3.

A similar report for amd64_edac (if amd64 would have 4 channels) would be:

EDAC MC1: amd64_edac: row 1, channel 3, label "DIMM_5" [...]

E. g. the error location fields are on different places. Writing a parser for
that would require to look inside each driver, and will require parsers
rewrite on each kernel version (for example, on this patch series, the '='
delimiter were replaced by ':' due to upstream feedback).

I think we merged some printk change for sb_edac on 3.4. If so, this driver,
that started on 3.3, will have 3 different printk ABI variants: one for
3.3, one for 3.4 and another for 3.5.

Also, as the "mask" needs to be properly parsed, 3.6 will also have yet another
printk format.

Regards,
Mauro
