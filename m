Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1HJBtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 21:49:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58780 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab1HJBtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 21:49:49 -0400
References: <20110805200945.GA14014@tassilo.jf.intel.com> <4E3C5154.2050307@zytor.com> <CAObL_7E3yOHtx9N3qd2UXVn+h6tACoNjekRhiMcHrzb=Mu4q8A@mail.gmail.com> <4E3C571C.1070903@zytor.com> <20110805205222.GK5782@one.firstfloor.org> <CAObL_7G2TqBVXvfuh2GPNteYBNoc8_s398KS+jPOPQYAhPHz0Q@mail.gmail.com> <20110805212153.GL5782@one.firstfloor.org> <CAObL_7Exnu8rHNY67o_HutizpLrGMx0heYU8wKXeEutXZywvdA@mail.gmail.com> <20110809150424.GO5782@one.firstfloor.org> <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com> <4E416716.1040904@zytor.com> <CAObL_7FzTisOGJLP7wGUKDCO6qJ20-kaMFWdjm0a+dKpNWBe3g@mail.gmail.com> <1312919938.17118.YahooMailNeo@web120010.mail.ne1.yahoo.com> <CAObL_7G09yBtfFpdvmRMNn59T-jTsj_MFK+xBer+qq3BUjcKUg@mail.gmail.com> <CA+55aFyV65BNjdsmS9oTaRwWzyJZS3BDEDJBx5Poy-vGp5iN_Q@mail.gmail.com> <1312934493.45753.YahooMailNeo@web120015.mail.ne1.yahoo.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <1312934493.45753.YahooMailNeo@web120015.mail.ne1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: New vsyscall emulation breaks JITs
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 09 Aug 2011 20:49:16 -0500
To: Greg Lueck <lueckintel@yahoo.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Lutomirski <luto@mit.edu>
CC: Andi Kleen <andi@firstfloor.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kimwooyoung@gmail.com" <kimwooyoung@gmail.com>
Message-ID: <c3bb5412-8600-40e2-aa7f-a844457c24ba@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Lueck <lueckintel@yahoo.com> wrote:

>Yes, this sounds like a cleaner solution.  What happens, though, if the
>system call is interrupted by a signal or by ptrace(ATTACH)?  Does RIP
>point at the target of the RET instruction?  Is it moved back to the
>entry of the vsyscall page?  Does it point immediately after the
>SYSCALL instruction?  GDB might also care about these details.
>
>> That's a fun corner case.  Is the problem that you might receive a
>> signal while single-stepping?
>
>
>Actually, the situation is more difficult.  The application may have
>received a signal while inside the gate, sometime before the SYSENTER
>trap.  The signal context frame on the application's stack now has RIP
>pointing someplace inside the gate.  At this point, Pin attaches to the
>native process, and it has no reasonable way to know about the saved
>context with this RIP value.  Later, the application (running under
>Pin) will return from its handler and resume execution in the middle of
>the gate code.  What can Pin do here?  It' s too late to execute
>natively at the start of the gate.  If Pin executes natively at the
>signal return point, Pin will lose control of the application and it
>will execute natively from that point forward.
>
>-- Greg
>
>
>
>
>________________________________
>From: Linus Torvalds <torvalds@linux-foundation.org>
>To: Andrew Lutomirski <luto@mit.edu>
>Cc: Greg Lueck <lueckintel@yahoo.com>; H. Peter Anvin <hpa@zytor.com>;
>Andi Kleen <andi@firstfloor.org>; "x86@kernel.org" <x86@kernel.org>;
>"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>;
>"kimwooyoung@gmail.com" <kimwooyoung@gmail.com>
>Sent: Tuesday, August 9, 2011 6:36 PM
>Subject: Re: New vsyscall emulation breaks JITs
>
>On Tue, Aug 9, 2011 at 2:04 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>>
>> Here's a different proposal, then:
>>
>> What if the kernel had the sequence:
>>
>> mov $__NR_whatever,%eax
>> syscall
>> ret
>>
>> in the vsyscall page but marked the vsyscall page NX.
>
>This sounds like a sound idea. And then the difference between "fast
>and native" and "slow and trapping" ends up literally being just the
>NX bit.
>
>                        Linus

The logical answer is that rip will point to the entry to the vsyscall page.
-- 
Sent from my mobile phone. Please excuse my brevity and lack of formatting.
