Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0GLRb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:31:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48725 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752087Ab0GLRb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:31:58 -0400
Message-ID: <4C3B514E.4000501@zytor.com>
Date: Mon, 12 Jul 2010 10:30:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Setup early console as early as possible
References: <4C3A3B27.7020009@oracle.com> <4C3AD94C.7070807@cs.helsinki.fi> <4C3B38F7.1050400@zytor.com> <4C3B40F3.6070009@kernel.org>
In-Reply-To: <4C3B40F3.6070009@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2010 09:21 AM, Yinghai Lu wrote:
> 
> Can you consider to ask Pekka to anaylze "console=uart8250,io, 0x3f8,115200n8" instead?
> 
> it looks like we can remove "earlyprintk=ttyS0,115200", or "earlyprintk=serial" etc.
> 
> earlycon=uart8250 or console=uart8250 should be better than earlyprintk.
> because it is shared between different archs already.
> 

Did you manage to miss my comment about that?

console= is crap, because it makes the user keep track of items they
should not have to deal with directly (unless they want to override the
defaults), i.e. the specific I/O ports used by the serial ports.

It's insanely user-unfriendly, and as far as I can see the movement has
been *toward* earlyprintk= rather than away from it.  It makes sense:
it's a higher-order interface that is closer to the user.

So, no, I will not ask Pekka to change from a good user interface to a
bad one.

>>
>> Incidentally, Yinghai: it would be possible to push even an MMIO
>> reference earlier by reserving a fixmap slot for the early console.  I'm
>> not sure if it's worth it, though.
> 
> in setup_arch() for x86, now we have
> 
>         /* VMI may relocate the fixmap; do this before touching ioremap area */
>         vmi_init();
> 
>         /* OFW also may relocate the fixmap */
>         olpc_ofw_detect();
> 
>         early_trap_init();
>         early_cpu_init();
>         early_ioremap_init()
> 
> so may need to move these 
> 	vmi_init()
> 	olpc_ofw_detect()
> 	early_ioremap_init()
> 
> to i386_start_kernel(), x86_start_kernel()
> 
> may be not worth it at this time, could do that later if needed.

Don't think so at this time, since mmio 8250 serial ports are basically
never used in the x86 world, but it could be interesting for non-8250
consoles, e.g. USB, in the future.

	-hpa
