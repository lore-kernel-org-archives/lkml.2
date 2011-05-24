Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab1EXVsd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:48:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44383 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab1EXVsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ma3Xv6kYne5s/2vizmQqQeb/oKfEGO1E6LoYbuX4Ts7nciDXowtNBFt4A8TedI99oj
         pl+aX7Xobju/EWknyvk8WtFzwQQ56VcojjBOiN+nABSdSQc5Esrpx+mUwGBUQwZohoyf
         XbaZhpsj7Y1S/0oRoqG2gqhX3ExtzqO1opVGU=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=BrrwL=gzn7H6O1rAGJpe=VPAQRQ@mail.gmail.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
	<20110524034023.GB25230@elte.hu>
	<987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
	<20110524173326.GA7635@gere.osrc.amd.com>
	<BANLkTinSOFAioAe2v5c6PRB9EKjJJNMg9w@mail.gmail.com>
	<1306272274.2497.73.camel@laptop>
	<BANLkTi=BrrwL=gzn7H6O1rAGJpe=VPAQRQ@mail.gmail.com>
Date: Tue, 24 May 2011 14:48:30 -0700
Message-ID: <BANLkTi=Mz7SoXz5zk-p-+FYBKC6aSWtgtg@mail.gmail.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Borislav Petkov <bp@amd64.org>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 2:30 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, May 24, 2011 at 2:24 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>>
>> Right, so you can't do things like that from NMI context, but what perf
>> can do is raise a self-IPI and continue from IRQ context (question for
>> the HW folks, can there be cycles between the NMI iret and IRQ assert
>> from whatever context was before the NMI hit?)
>
> Of course there can be - the code where the NMI hit may have
> interrupts disabled.

But the case when I'd want to do the "stop this task" thing is when I
think that I can recover - for memory errors detected while in kernel
code I expect this will only ever be a few special cases:
1) copy to/from user
2) copy page (for copy-on-write fault)
3) ...
and in these cases we don't have interrupts disabled.  In fact I have
difficulty imagining a scenario where the kernel trips over a memory
error in interrupt disabled code that would ever be recoverable.

So my NMI handler can look at the saved pt_regs to see whether
it blasted its way into some interrupt disabled code and call that
fatal - if it came in while interrupts were enabled, then it could use
Peter's self-IPI thingy.

-Tony
