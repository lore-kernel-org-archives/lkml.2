Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab0JTGnr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 02:43:47 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:38636 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab0JTGnq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:5:1>);
	Wed, 20 Oct 2010 02:43:46 -0400
Message-Id: <4CBEABAE020000780001E227@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 20 Oct 2010 07:43:26 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Alexander van Heukelum" <heukelum@fastmail.fm>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: fix CFI macro invocations to deal with
	 shortcomings in gas
References: <4CBDBEBA020000780001E05A@vpn.id2.novell.com>
 <1287522205.14378.1400906413@webmail.messagingengine.com>
In-Reply-To: <1287522205.14378.1400906413@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 19.10.10 at 23:03, "Alexander van Heukelum" <heukelum@fastmail.fm> wrote:
>> -       pushl_cfi (TI_sysenter_return-THREAD_SIZE+8+4*4)(%esp)
>> +       pushl_cfi TI_sysenter_return-THREAD_SIZE_asm+8+4*4(%esp)
> 
> This expands to:
>     pushl_cfi (60)-(8192)+8+4*4(%esp)
> 
> I'm sorry to say that Ubuntu 6.06's gas (2.16.91 20060118) still chokes
> with "too many positional arguments" on this line.

It escapes me where it would split the obviously single argument, and
I know I checked all official versions from 2.15 onwards. Could you
try whether that specific gas would be okay with

     pushl_cfi ((60)-(8192)+8+4*4)(%esp)

I had intentionally removed the surrounding parentheses since
those are considered by newer gas when determining arguments,
and thus I could expose eventual problems with older gas even
on newer versions.

Further, could you experiment (or ideally debug) where is splits
the argument. Something like

.macro m arg1 arg2=0
	.long	\arg1, \arg2
.endm

.data
_start:
	m	(60)-(8192)+8+4*4

might be handy - assembling with -alm=<filename> should allow
you to inspect where the argument got split.

Thanks, Jan

