Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab1EaBYJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 21:24:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45181 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab1EaBYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 21:24:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ejjx8CC753gt82vjp9BUMstFT4Uo4SQYMTt91zVeu3zlr8A87d4PPYp2kt1Iu/BrRk
         CGRu39JfAfKir9/cgwtfigTJ7i6c6SGOyIyT64K7w4UFV+Rstyxm9uMLJnPc3oX/rbcQ
         4ZvNLv+J1pdEThdV5/gspIKgLHTGKANgdq4AU=
MIME-Version: 1.0
In-Reply-To: <20110530234654.GB14366@smp.if.uj.edu.pl>
References: <20110530161014.GS25813@smp.if.uj.edu.pl> <BANLkTi=7k4XbK6JVDp3oOJRAK_7Ox=aWMw@mail.gmail.com>
 <20110530234654.GB14366@smp.if.uj.edu.pl>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 30 May 2011 21:23:46 -0400
X-Google-Sender-Auth: 27hSaNQCw8cHPC0eBEAHK8d_s50
Message-ID: <BANLkTikO5U_h8mvjoOUU+W9kpZrfaLzPdQ@mail.gmail.com>
Subject: Re: Kernel OOPS in function_graph_tracer due to the 44259b1. More
 oopses in tracing...
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <johnstul@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 30, 2011 at 7:46 PM, Witold Baryluk
<baryluk@smp.if.uj.edu.pl> wrote:
> On 05-30 16:14, Andrew Lutomirski wrote:
>> On Mon, May 30, 2011 at 12:10 PM, Witold Baryluk
>> <baryluk@smp.if.uj.edu.pl> wrote:
>> > Hi,
>> >
>> > I found yesterday a problem when booting system on Pentium-M, 32-bit.
>> >
>> > I got approximetly this
>> >
>> > [    2.459170] Testing tracer function_graph:
>> > [    2.466979] BUG: unable to handle kernel paging request at e421cc10
>>
>> >
>> > Reverting commit 44259b1abfaa8bb819d25d41d71e8e33e25dd36a on top of current
>> > kernel make bug disapear.
>> >
>> > Disabling CONFIG_FUNCTION_GRAPH_TRACER also make bug dispear.
>> >
>>
>> Of course, the most trivial of my patches was the one with the most
>> significant bug.  Can you try this fix:
>>
>> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=89e1be50c68eb5e58b873dce87bbac627ee18d1f
>>
>> --Andy
>
> Well, to add more.
>
> It fixed most of crashes and definietl one with function graph tracer.
>
> However in 1/10 of boots I still got some kind of crash, oops or panic.
>


>
> ....
> [    0.035682] CPU: Intel Pentium III (Katmai) stepping 03
> [    0.038048] ftrace: allocating 6263 entries in 13 pages
> [    0.050386] BUG: unable to handle kernel paging request at 8a51553a
> [    0.051031] IP: [<c10587cd>] tick_handle_periodic+0x1d/0x90
> [    0.051705] *pdpt = 0000000000000000 *pde = f000ff53f000ff53
> ...
> CRASH

This is oops1.txt.  The faulting code is:

000003a0 <tick_handle_periodic>:
 3a0:   55                      push   %ebp
 3a1:   89 e5                   mov    %esp,%ebp
 3a3:   57                      push   %edi
 3a4:   56                      push   %esi
 3a5:   53                      push   %ebx
 3a6:   83 ec 0c                sub    $0xc,%esp
 3a9:   e8 fc ff ff ff          call   3aa <tick_handle_periodic+0xa>
 3ae:   89 c7                   mov    %eax,%edi
 3b0:   e8 fc ff ff ff          call   3b1 <tick_handle_periodic+0x11>
 3b5:   89 45 f0                mov    %eax,-0x10(%ebp)
 3b8:   e8 63 ff ff ff          call   320 <tick_periodic>
 3bd:   83 7f 28 03             cmpl   $0x3,0x28(%edi)

^^^ fault was in the dereference of edi + 0x28.

 3c1:   74 0d                   je     3d0 <tick_handle_periodic+0x30>
 3c3:   83 c4 0c                add    $0xc,%esp
 3c6:   5b                      pop    %ebx
 3c7:   5e                      pop    %esi
 3c8:   5f                      pop    %edi
 3c9:   5d                      pop    %ebp
 3ca:   c3                      ret

The stack trace is garbage, though.

The offending C code is probably this:

        if (dev->mode != CLOCK_EVT_MODE_ONESHOT)
                return;

I would guess that this isn't related to the vdso changes, and I'm
mostly out of ideas.

--Andy
