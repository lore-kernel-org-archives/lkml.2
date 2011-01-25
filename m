Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab1AYRj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:39:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59317 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab1AYRjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:39:55 -0500
Message-ID: <4D3F0A15.2070703@zytor.com>
Date: Tue, 25 Jan 2011 09:36:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        X86-ML <x86@kernel.org>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk upon
 panic
References: <20110125134748.GA10051@laptop>	<20110125140948.GA26762@elte.hu>	<20110125153649.GA11386@laptop> <AANLkTikHe8Bq1f-nv8hiAeY7rs7t5MWTvEUSYT81py4S@mail.gmail.com>
In-Reply-To: <AANLkTikHe8Bq1f-nv8hiAeY7rs7t5MWTvEUSYT81py4S@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2011 09:32 AM, Tony Luck wrote:
> 
> Using swap space as a dump area has a long and established tradition
> going back to the early roots of Unix - so I don't think that it is all that
> hacky. I think that modern systems even write some magic at the start
> of the swap partition that you could use to verify that you were writing to
> the correct spot ... and it should be easy to retrieve your dumped data
> before the swap gets re-enabled by the new kernel after the reboot.
> [Perhaps the new kernel could do this automatically if it finds some
> signature that your code leaves in the swap area so it could stuff the data
> into my /dev/pstore filesystem?]
> 
> One more "is this bit of the BIOS code safe" concern that I have is that
> you'll be using the "write" path of the INT 0x13 code ... which isn't the
> path that is tested by booting ... it *ought* to be OK - but untested paths
> in BIOS seem to be broken paths all too often.
> 

It's not just that, it's that you're going through it *after the kernel
has run*.  The kernel has wrecked the state of the system -- the disk
hardware, the PCI hierarchy, the interrupt system -- as far as the BIOS
is concerned.  It is no longer safe to trust the BIOS to use your
hardware, especially not for writing.

So what is the solution?  We have to carry our own disk driver for the
emergency.  In other words, we're very quickly starting to make
something that looks a whole lot like kexec/kdump.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

