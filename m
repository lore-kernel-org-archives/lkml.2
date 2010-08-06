Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761381Ab0HFRss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 13:48:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33966 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813Ab0HFRso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 13:48:44 -0400
Message-ID: <4C5C4A23.6070006@zytor.com>
Date: Fri, 06 Aug 2010 10:45:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, stable@kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Avi Kivity <avi@redhat.com>,
        Brian Gerst <brgerst@gmail.com>, Glauber Costa <glommer@redhat.com>,
        Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Jeff Dike <jdike@addtoit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Palfrader <peter@palfrader.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Zachary Amsden <zamsden@redhat.com>
Subject: Re: [GIT PULL] x86/asm for 2.6.36
References: <201008052037.o75KbxSS022005@hera.kernel.org> <AANLkTimZF5U-AmD6200gnTuNzX5nUqVqEo_NmiH3rz5n@mail.gmail.com>
In-Reply-To: <AANLkTimZF5U-AmD6200gnTuNzX5nUqVqEo_NmiH3rz5n@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2010 10:17 AM, Linus Torvalds wrote:
> On Thu, Aug 5, 2010 at 1:37 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>>
>>  git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-asm-for-linus
>>
>> H. Peter Anvin (7):
>>      x86, asm: Clean up and simplify set_64bit()
> 
> Hmm. This seems to cause compiler warnings for me on x86-64:
> 
>   drivers/pci/intr_remapping.c: In function ‘modify_irte’:
>   drivers/pci/intr_remapping.c:314: warning: passing argument 1 of
> ‘set_64bit’ from incompatible pointer type
>   /home/torvalds/v2.6/linux/arch/x86/include/asm/cmpxchg_64.h:6: note:
> expected ‘volatile u64 *’ but argument is of type ‘long unsigned int
> *’
> 
> and I'm not clear on the reason for that function prototype change.
> 
>                           Linus

On 64 bits the intent was to be consistent with the tightened-up 32-bit
code.  Perhaps that was a mistake, but it seems a lot more consistent to
me to have "u64" be the type

On the 32-bit side, it's not so much a function prototype change as the
previous version of the code actually explicitly cast it to an array of
unsigned ints... it has the advantage that it can accept any type, but
the disadvantage that is can accept *ANY* type.  The problem of course
is the above, since gcc will issue warnings for u64 (unsigned long long)
version the otherwise-identical "unsigned long".

It's worth noting that in this particular case the code itself looks
like this:

	set_64bit((unsigned long *)&irte->low, irte_modified->low);
	set_64bit((unsigned long *)&irte->high, irte_modified->high);

... where the existing cast is there because irte->low and irte->high
are types __u64.  In other words, with the "more logical" u64 prototype
the casts should just get removed.

On the other hand I should have seen this sooner, obviously.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

