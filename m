Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab0JAA1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:27:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53054 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab0JAA1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:27:14 -0400
Message-ID: <4CA52AA5.5040402@zytor.com>
Date: Thu, 30 Sep 2010 17:26:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, heukelum@fastmail.fm, tglx@linutronix.de,
        akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: gas 2.16 and assembly macros -- entry_64.S build failure
References: <201009152110.o8FLAJeJ015584@imap1.linux-foundation.org> <4C91F07E0200007800016B50@vpn.id2.novell.com> <20100916082816.GA25681@elte.hu> <4C91F3A30200007800016B64@vpn.id2.novell.com> <20100916101355.GA31458@elte.hu> <4C9219BC0200007800016C53@vpn.id2.novell.com>
In-Reply-To: <4C9219BC0200007800016C53@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2010 04:21 AM, Jan Beulich wrote:
>>
>> Yes, to only generate CFI on binutils that allows us to write sane 
>> looking code.
>>
>> I.e. to disable CONFIG_AS_CFI on binutils that are broken for this.
> 
> Again - that won't help, as it's the macro invocation that gas
> fails one, not one of the actual .cfi_* directives.
> 

Looking again at this issue with the binutils version from hell
(sigh)... I'm running quickly out of ideas.

The problem is that cpp inserts spaces around expansions, so:

	pushq_cfi $(USER_DS)

... turns into something like ...

	pushq_cfi $( ( 5 * 8 + 3 ) )

... which these old versions of gas considers multiple arguments to the
macro, even though there is no comma anywhere.  We can defang *some* of
these problems by using cpp macros to kill them off:

#define pushq_cfi pushq

... but that doesn't work with the macros like movq_cfi.  On those, we
could argue that at least people won't put $ on them, but cpp will still
split them apart with spaces; this apparently causes problems at least
as soon as there is an expression more complicated than addition
involved (apparently plus signs are okay, but minus signs aren't!)

I'm completely lost about how to deal with this.   We can't simply
defang the macros -- at least not in a way that is likely to *stay*
working -- and dropping the macros is seriously going to impact the
debuggability of the kernel.  One way, of course, is to simply declare
binutils 2.16 and 2.15.9x (which is apparently included in
RHEL/CentOS 4) to be broken beyond repair unless distros backport a fix,
and in many ways I think that is the preferred option, but I don't know
if that makes sense to others...

	-hpa

