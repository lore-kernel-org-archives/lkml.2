Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab1HIPWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:22:34 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42135 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1HIPWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:22:32 -0400
MIME-Version: 1.0
In-Reply-To: <20110809150424.GO5782@one.firstfloor.org>
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com>
 <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com>
 <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org>
 <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com>
 <20110805212153.GL5782@one.firstfloor.org> <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com>
 <20110809150424.GO5782@one.firstfloor.org>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 9 Aug 2011 11:22:12 -0400
X-Google-Sender-Auth: ebxKCeCrFzS5zOc-YUOPP7morXE
Message-ID: <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 11:04 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> Why do we care about pin again?
>
> Binary compatibility is not about someone especially caring.

I'm all for binary compatibility with programs that already worked...

>
>>
>> $ ./pin -t obj-intel64/opcodemix.so -- /bin/ls
>> E:3.0 is not a supported linux release
>
> It works with
>
> echo "2.6.39" > /osrelease
> mount --bind /osrelease /proc/sys/kernel/osrelease
>

...but that's more than a little bit sad.  (For example, my patches
"broke" anything that relied on vsyscall 3, aka enosys().  But that
was already broken for years, so clearly no one cared.)

In any case, my patch fixes DynamoRIO but not pin.  Pin dies with:

[ 4988.945491] test_vsyscall[4587] emulated vsyscall from bogus
address -- fix your code nr: 0 ip:7fdc3a5ce78f cs:33 sp:7fffc2339a88
ax:ffffffffff600000 si:0 di:400d0a
[ 4988.945497] test_vsyscall[4587] vsyscall fault (exploit attempt?)
nr: 0 ip:7fdc3a5ce78f cs:33 sp:7fffc2339a88 ax:ffffffffff600000 si:0
di:400d0a

and I don't know what's going on.  I suspect that the tracer assumes
that int 0x40 continues execution at the next instruction.

x86 maintainers: I can think of a few choices:

1. Stick a ret instruction in the vsyscall page.  Downside: now
there's an unrestricted ret instruction in the vsyscall page.

2. Don't apply my patch and let pin and DynamoRIO break.  Downside:
DynamoRIO actually works in 3.0.

3. Apply my patch and assume that the number of users that would
benefit from a more complete fix is close to zero, since pin won't
even try to run on 3.0 or 3.1 without gross hacks.  (Pin is prerelease
software and apparently actively maintained by people who make it very
hard for non-users to contact, but I'm trying.)

4. Put native syscall instructions in the vsyscall page, mark it NX,
and trap and emulate vsyscalls on the instruction fetch fault.  I can
do this with no overhead in the success path of the page fault code,
but it will slow down vsyscall emulation quite a bit and it's
intrusive.  This seems like overkill to fix a single known binary that
doesn't really work anyway.

--Andy
