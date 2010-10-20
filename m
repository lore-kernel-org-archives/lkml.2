Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0JTSLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:11:07 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34019 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753913Ab0JTSLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:11:05 -0400
Message-Id: <1287598263.13748.1401083639@webmail.messagingengine.com>
X-Sasl-Enc: Fbpic3mAoooU6dvYi3R1dai6pip7kEtQzmo75EMbLPmW 1287598263
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Jan Beulich" <JBeulich@novell.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
In-Reply-To: <4CBEABAE020000780001E227@vpn.id2.novell.com>
References: <4CBDBEBA020000780001E05A@vpn.id2.novell.com><1287522205.14378.1400906413@webmail.messagingengine.com>
 <4CBEABAE020000780001E227@vpn.id2.novell.com>
Subject: Re: [PATCH] x86: fix CFI macro invocations to deal with  shortcomings
 in gas
Date: Wed, 20 Oct 2010 20:11:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jan and all,

On Wed, 20 Oct 2010 07:43 +0100, "Jan Beulich" <JBeulich@novell.com> wrote:
> >>> On 19.10.10 at 23:03, "Alexander van Heukelum" <heukelum@fastmail.fm> wrote:
> >> -       pushl_cfi (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
> >> +       pushl_cfi TI_sysenter_return-THREAD_SIZE_asm+8+4*4(%esp)
> > 
> > This expands to:
> >     pushl_cfi (60)-(8192)+8+4*4(%esp)
> > 
> > I'm sorry to say that Ubuntu 6.06's gas (2.16.91 20060118) still chokes
> > with "too many positional arguments" on this line.
> 
> It escapes me where it would split the obviously single argument, and
> I know I checked all official versions from 2.15 onwards. Could you
> try whether that specific gas would be okay with
> 
>      pushl_cfi ((60)-(8192)+8+4*4)(%esp)

Yes, this works! Adding the parentheses to the patch makes things go
on Ubuntu 6.06 (i386). I hope we can get rid of the old gas, but feel free
to add an Acked-by: Alexander van Heukelum <heukelum@fastmail.fm>.

> I had intentionally removed the surrounding parentheses since
> those are considered by newer gas when determining arguments,
> and thus I could expose eventual problems with older gas even
> on newer versions.
> 
> Further, could you experiment (or ideally debug) where is splits
> the argument. Something like
> 
> .macro m arg1 arg2=0
> 	.long	\arg1, \arg2
> .endm
> 
> .data
> _start:
> 	m	(60)-(8192)+8+4*4

Contents of section .data:
 0000 3c000000 18e0ffff

So it splits at the minus sign, even though there is no space.

Greetings,
    Alexander

> might be handy - assembling with -alm=<filename> should allow
> you to inspect where the argument got split.
> 
> Thanks, Jan
> 
