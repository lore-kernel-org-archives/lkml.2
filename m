Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab1EXVC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:02:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab1EXVC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:02:56 -0400
Date: Tue, 24 May 2011 23:02:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        davej@redhat.com, kees.cook@canonical.com, davem@davemloft.net,
        eranian@google.com, torvalds@linux-foundation.org, adobriyan@gmail.com,
        penberg@kernel.org, hpa@zytor.com,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110524210233.GI27634@elte.hu>
References: <1306269105.21443.20.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306269105.21443.20.camel@dan>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dan Rosenberg <drosenberg@vsecurity.com> wrote:

> This introduces CONFIG_RANDOMIZE_BASE, which randomizes the address at
> which the kernel is decompressed at boot as a security feature that
> deters exploit attempts relying on knowledge of the location of kernel
> internals.  The default values of the kptr_restrict and dmesg_restrict
> sysctls are set to (1) when this is enabled, since hiding kernel
> pointers is necessary to preserve the secrecy of the randomized base
> address.

That was quick! :-)

> This feature also uses a fixed mapping to move the IDT (if not already
> done as a fix for the F00F bug), to avoid exposing the location of
> kernel internals relative to the original IDT.  This has the additional
> security benefit of marking the new virtual address of the IDT
> read-only.

Btw., as i suggested before the IDT should be made percpu, that way we could 
split out and evaluate the IDT change independently of any security 
considerations, as a potential scalability improvement. Makes the decision 
easier because right now moving the IDT to a 4K TLB increases the kernel's TLB 
footprint a tiny bit.

> Entropy is generated using the RDRAND instruction if it is supported. If not, 
> then RDTSC is used, if supported. If neither RDRAND nor RDTSC are supported, 
> then no randomness is introduced. Support for the CPUID instruction is 
> required to check for the availability of these two instructions.

Btw., i'd suggest to fall back not to zero but to something system specific 
like RAM size or a BIOS signature such as the contents of 0xf0000 or so. This, 
while clearly not random, will at least *somewhat* randomize the kernel against 
remote attackers who do not know the RAM size or the system type.

Thanks,

	Ingo
