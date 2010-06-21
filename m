Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab0FUE0f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 00:26:35 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0FUE0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 00:26:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oPQnyzoa8djM9tvTSBtXp1R+uhy7YzEG/7wOj5/pWf+BVg5h3pFLJrT7IPGJS87nGD
         2am9Ge7594KOqwZkrvKHYvJMUu78kK9GA883K3t2aHBKkgSHmyNhTvDGlL6N26Xq2zA5
         bR8R8wjRuP1FeZTz8uBOL8sCIQXAFXgtitto8=
MIME-Version: 1.0
In-Reply-To: <20100621120256.8d2a2fca.kamezawa.hiroyu@jp.fujitsu.com>
References: <AANLkTikeDoxm6OzWldU5PAr06wvW89asIIPNrpVKoc8I@mail.gmail.com>
	<AANLkTikPAdDuUb37-GPDzFugBYEWNpoSLabcl2Fyt5VY@mail.gmail.com>
	<AANLkTilP5yyJjMqZPhvgv2d22Lrt8ZKB0AoITSEsukgt@mail.gmail.com>
	<20100621120256.8d2a2fca.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 21 Jun 2010 00:26:20 -0400
Message-ID: <AANLkTikObbFXKmD8cjWFVz8i0XgIBduyXloWK2JEWTeq@mail.gmail.com>
Subject: Re: Kernel does strange things when compilations push memory usage 
	above physical memory and the compilations are being done in a tmpfs, despite 
	having ample swap
From: Richard Yao <shiningarcanine@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm that this issue also affects kernel 2.6.33.5.

I compiled kernel 2.6.33.5 and reran the compilation that caused me to
discover this issue last night on it. The result was segfaults galore:

[ 3970.275839] chrome[15071]: segfault at c ip 0000000000ee24db sp
00007fff2561ddc0 error 4 in chrome[400000+28be000]
[ 4013.872411] chrome[15786]: segfault at 140 ip 00000000012a815d sp
00007fff2561dd70 error 4 in chrome[400000+28be000]
[ 4035.297568] chrome[2119]: segfault at 0 ip (null) sp
00007fff5b5fc368 error 14 in chrome[400000+28be000]
[ 4036.015278] ebuild.sh[10262]: segfault at 8 ip 000000000043b5c3 sp
00007fff28647fa0 error 4 in bash[400000+d1000]
[ 4039.875613] ebuild.sh[6632]: segfault at 8 ip 000000000042f70c sp
00007fffcc129480 error 4 in bash[400000+d1000]
[ 4039.968393] emerge[23722]: segfault at a9 ip 00007fe98a1425c0 sp
00007ffffeb1a668 error 4 in libpython2.6.so.1.0[7fe98a0ad000+159000]
[ 4040.905149] ebuild.sh[5792]: segfault at 28 ip 0000000000435cc0 sp
00007fffae12b0b8 error 4 in bash[400000+d1000]

Soon after programs started crashing, X froze, rendering my system
unresponsive, with the exception of a my mouse cursor, which I could
still move around. X crashed a few minutes later and my system
returned to a usable state. While that happened, I was able to ssh
into the system to look at kernel log. The excerpt above is its tail
and there is no mention of X.

Yours truly,
Richard Yao

On Sun, Jun 20, 2010 at 11:02 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Sun, 20 Jun 2010 22:23:50 -0400
> Richard Yao <shiningarcanine@gmail.com> wrote:
>
>> My system is still responsive if it has not locked-up, even after the
>> oom-killer appears to have killed stuff.
>>
>> Does the kernel need to be compiled with any special options to have
>> it report to dmesg that the oom-killer activated? I cited the
>> oom-killer as being activated because several things would
>> inexplicit-ably crash when the system is under memory pressure, but
>> looking in my dmesg log at a crash that occurred earlier today when I
>> forgot to unmount my tmpfs, I do not see any references to the oom
>> killer, just the process that crashed:
>>
>
> Are your oom-killer happens  on workload on tmpfs ?
> (I thought /var/tmp isn' tmpfs..)
>
> plz check this.
> =
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d6da1a5abc2bf3a06a5bda08e0f6833409234666
> =
>
> Does oom-killer happens also on 2.6.33 ?
>
> Thanks,
> =Kame
>
>> [ 5873.816211] chrome[18404]: segfault at 8 ip 0000000001063b9b sp
>> 00007fffb0a7f540 error 4 in chrome[400000+28be000]
>>
>> Could it be that a bug is causing the kernel to map the same region of
>> physical memory to multiple programs?
>>
>> On Sun, Jun 20, 2010 at 10:03 PM, Andrew Hendry <andrew.hendry@gmail.com> wrote:
>> > After the oom killer has killed things, is your system still really
>> > sluggish if it doesn't lockup?
>> >
>> > I have what might be a similar issue, after a lot of compiling on a ramdisk.
>> > http://marc.info/?l=linux-kernel&m=127569877714937&w=2
>> >
>> > Oom killer keeps killing processes until almost nothing is left.
>> > Free memory is very high, and system is still very sluggish.
>> >
>> > On Mon, Jun 21, 2010 at 10:21 AM, Richard Yao <shiningarcanine@gmail.com> wrote:
>> >> Dear Everyone,
>> >>
>> >> My desktop has 4GB of RAM and it is running an unpatched Linux 2.6.34
>> >> kernel. I recently migrated it from Windows 7 to Gentoo Linux and I am
>> >> encountering a highly peculiar problem when I build/rebuild system
>> >> packages in a manner that stresses memory.
>> >>
>> >> When system memory usage exceeds 4GB because I have several
>> >> compilations running simultaneously, all of which have had -j5 passed
>> >> to make, with the build scripts sharing an 8GB tmpfs directory, the
>> >> system typically responds by activating the kernel oom-killer, which
>> >> will usually kill some of the processes involved in the compilations,
>> >> among other things. This is with an 8GB swap partition and barely any
>> >> of it is touched when this happens according to KDE's system monitor.
>> >> Rarer, but alternative responses that the system has made to such
>> >> circumstances involve the system package manager failing
>> >> mid-compilation with "Segmentation fault" printed to the console or
>> >> open office failing with an obscure error message. Usually just
>> >> compiling open office alone is enough to have things fail, although I
>> >> usually see it fail with an obscure 5 digit error message that has no
>> >> meaning which I can derive from doing searches with Google. Unmounting
>> >> my tmpfs directory and doing things as I normally would do them makes
>> >> these issues disappear.
>> >>
>> >> I have run memtest and it has not detected any hardware issues. I
>> >> tried asking for help on the Gentoo Linux forums, but I received no
>> >> responses and this looks like a kernel issue, so I thought it would be
>> >> a good idea to ask for assistance on the kernel mailing list. Here is
>> >> a link to a copy of my kernel's .config file:
>> >>
>> >> http://paste.pocoo.org/show/227799/
>> >>
>> >> As I was typing this, I had openoffice 3.2.1 and something else
>> >> compiling in the background and the system completely froze. This is
>> >> the first I have seen my system do this and it was about 10 minutes
>> >> after the oom-killer had already taken out kwin and several tabs in
>> >> chromium. I had SSH running in the background, but even that has been
>> >> rendered inaccessible by the freeze. I cannot get a response from the
>> >> system via arping and nmap is telling me that the system is down.
>> >>
>> >> Earlier today, I tried to reproduce this issue under simpler
>> >> cirumstances by doing dd bs=4096 count=2097152 if=/dev/zero
>> >> of=/var/tmp/portage/zero.bak. As a consequence of all of the swapping
>> >> that occurred, the system's X server become unresponsive, so I walked
>> >> away and came back a few minutes later to find that the KDE System
>> >> Monitor had crashed, but everything else seemed fine.
>> >>
>> >> Any help with this issue would be appreciated. I am willing to
>> >> recompile my system in whatever manner necessary to diagnose the cause
>> >> of this issue. Please CC me any responses made either directly or
>> >> indirectly in response to this message.
>> >>
>> >> Yours truly,
>> >> Richard Yao
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> Please read the FAQ at  http://www.tux.org/lkml/
>> >>
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
>
