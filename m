Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499Ab1JEWls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 18:41:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48625 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935480Ab1JEWlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 18:41:46 -0400
MIME-Version: 1.0
In-Reply-To: <20111005223055.GG14406@localhost.pp.htv.fi>
References: <20111003090846.GA25136@localhost.pp.htv.fi>
	<CAObL_7GSQFr_PRtKY=H7r=yD7Qk-xvgbg5bV1=nU-qayG-mJdw@mail.gmail.com>
	<20111003173359.GA3072@localhost.pp.htv.fi>
	<CAObL_7Fi3mw5Azyhxx-vsdNuhJm8RewmYS97QvWa0F=cbYvegg@mail.gmail.com>
	<CAFLxGvzpvJ1mgdcbrq+3h5EA+VOhZDR9BY27uWGgsmV4TWYb4A@mail.gmail.com>
	<20111005223055.GG14406@localhost.pp.htv.fi>
Date: Thu, 6 Oct 2011 00:41:45 +0200
Message-ID: <CAFLxGvyL0Mx-9Jru_bt19zipi3AjB+eGPZZC-LsosqaAmfGr2A@mail.gmail.com>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 6, 2011 at 12:30 AM, Adrian Bunk <bunk@stusta.de> wrote:
> On Thu, Oct 06, 2011 at 12:22:34AM +0200, richard -rw- weinberger wrote:
>> On Thu, Oct 6, 2011 at 12:13 AM, Andrew Lutomirski <luto@mit.edu> wrote:
>> > On Mon, Oct 3, 2011 at 10:33 AM, Adrian Bunk <bunk@stusta.de> wrote:
>> >> On Mon, Oct 03, 2011 at 06:04:53AM -0700, Andrew Lutomirski wrote:
>> >>> On Mon, Oct 3, 2011 at 2:08 AM, Adrian Bunk <bunk@stusta.de> wrote:
>> >>> > After upgrading a kernel the existing userspace should just work
>> >>> > (assuming it did work before ;-) ), but when I upgraded my kernel
>> >>> > from 3.0.4 to 3.1.0-rc8 a UML instance didn't come up properly.
>> >>> >
>> >>> > dmesg said:
>> >>> >  linux-2.6.30.1[3800] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb9c498 ax:ffffffffff600000 si:0 di:606790
>> >>> >  linux-2.6.30.1[3856] vsyscall fault (exploit attempt?) ip:ffffffffff600000 cs:33 sp:7fbfb13168 ax:ffffffffff600000 si:0 di:606790
>> >>> >
>> >>> > Looking throught the changelog I ended up at commit 3ae36655
>> >>> > ("x86-64: Rework vsyscall emulation and add vsyscall= parameter").
>> >>> >
>> >>> > Linus suggested in https://lkml.org/lkml/2011/8/9/376 to default to
>> >>> > vsyscall=native.
>> >>> >
>> >>> > That sounds reasonable to me, and fixes the problem for me.
>> >>>
>> >>> At this point in the -rc cycle, this sounds fine.
>> >>>
>> >>> That being said, I'd like to fix it for real for 3.2.  This particular
>> >>> failure is suspicious -- the "vsyscall fault" message means that
>> >>> sys_gettimeofday returned EFAULT, which means that the old (3.0 and
>> >>> before) vgettimeofday should *also* have segfaulted.
>> >>
>> >> This 2.6.30.1 UML kernel binary from 2009 worked for me for all host
>> >> kernels from 2.6.30 to 3.0, and with 3.1.0-rc8 and vsyscall=native
>> >> it also seems to run nicely.
>> >>
>> >> Looking deeper into "a UML instance didn't come up properly",
>> >> the problem is that it comes up in a strange (readonly) state.
>> >>
>> >> There are "Using makefile-style concurrent boot in runlevel S."
>> >> and "Using makefile-style concurrent boot in runlevel 2." in the
>> >> logs with a Debian userspace, but no output from the init scripts
>> >> in these broken bootups (normal messages are in non-broken bootups).
>> >>
>> >> Perhaps the two the messages I see in dmesg on the host are from the
>> >> processes running rcS and rc2 failing early?
>> >>
>> >> In a working startup with a Debian userspace, I'm getting during rcS
>> >>  Setting the system clock.
>> >>  Cannot access the Hardware Clock via any known method.
>> >>  Use the --debug option to see the details of our search for an access method.
>> >>  Unable to set System Clock to: Mon Oct 3 17:01:35 UTC 2011 ... (warning).
>> >>
>> >>> We do have a bit
>> >>> of a bug in that the new code doesn't report si_addr properly, but
>> >>> that sounds unlikely as a culprit.  Did you try with the offending
>> >>> commit reverted (i.e. fce8dc0)?  I bet that it also fails there.
>> >>
>> >> fce8dc0 is "x86-64: Wire up getcpu syscall", is that really the one you
>> >> want me to revert?
>> >>
>> >>> What's the .config for your UML binary?  I'd like to see if I can
>> >>> reproduce this.
>> >>
>> >> It's attached.
>> >>
>> >
>> > I can't reproduce it.  What distro is running inside the UML instance?
>>
>> Same here.
>> Adrian, is the UML kernel crashing before executing init?
>
> As I wrote:
>  Looking deeper into "a UML instance didn't come up properly",
>  the problem is that it comes up in a strange (readonly) state.
>
> The UML kernel is running happily without crashing, and as I wrote my
> guess about my problems is:
>  Perhaps the two the messages I see in dmesg on the host are from the
>  processes running rcS and rc2 failing early?
>
>> We definitely need more information...
>
> I gave the information that was requested. plus my observations.
>

Whoops, the mail containing that information did not make it into my
head, sorry.
Now I know where to look for...

BTW: Can you please test 3.1-rcX as UML kernel? It contains
vDSO/vsyscall fixes...

-- 
Thanks,
//richard
