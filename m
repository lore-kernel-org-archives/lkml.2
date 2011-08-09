Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1HIVFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:05:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48326 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096Ab1HIVF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:05:29 -0400
Message-ID: <4E419FBA.5020002@zytor.com>
Date: Tue, 09 Aug 2011 15:59:38 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Greg Lueck <lueckintel@yahoo.com>
CC: Andrew Lutomirski <luto@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "kimwooyoung@gmail.com" <kimwooyoung@gmail.com>
Subject: Re: New vsyscall emulation breaks JITs
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com> <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com> <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org> <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com> <20110805212153.GL5782@one.firstfloor.org> <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com> <20110809150424.GO5782@one.firstfloor.org> <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com> <4E416716.1040904@zytor.com> <CAObL_7FzTisOGJLP7wGUKDCO6qJ20-kaMFWdjm0a+dKpNWBe3g@mail.gmail.com> <1312919938.17118.YahooMailNeo@web120010.mail.ne1.yahoo.com>
In-Reply-To: <1312919938.17118.YahooMailNeo@web120010.mail.ne1.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2011 02:58 PM, Greg Lueck wrote:
> I apologize that I’m just jumping into this conversation now.  I was
> swamped yesterday and this morning, and I only just started reading it
> today.
> 
> Pin needs to recognize all possible syscall trap instructions, so we
> will need to change our code to recognize INT 0xCC as a syscall trap. 

What you probably SHOULD be doing is to recognize the vsyscall/vdso as a
special chunk of memory.  The act of entering the vsyscall code is the
point where you need to intercept, if you're going to do that; relying
on the contents of the vsyscall/vdso page to have specific properties is
just plain broken, as you're "chasing the implementation", as well as
violate inherent properties of this particular memory space.

> SYSENTER instruction specially (on 32-bit).  When we see SYSENTER, Pin
> executes the syscall natively and then resumes JIT-compilation at the
> normal resume point in the gate area.  This works regardless of where
> Pin attaches to the application, and it also has the nice advantage that
> Pin tools see the exact sequence of user space instructions that the
> application would execute if it ran natively.

... and it's also complete bunk if you want any modicum of stability.
Keep in mind that the kernel can change the content of the vsyscall/vdso
memory at any time, without notifying userspace.

	-hpa
