Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1E0Ri5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:38:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42659 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab1E0Ri4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:38:56 -0400
Date: Fri, 27 May 2011 19:38:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527173835.GF4356@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
 <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan>
 <4DDFDBD2.2000904@zytor.com>
 <BANLkTin=VV_1rny+5EgwJXj1SQ45c2KKsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin=VV_1rny+5EgwJXj1SQ45c2KKsw@mail.gmail.com>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> That's the _only_ difference, and it's trivial and irrelevant. Come 
> up with something more real, please.

The advantages of dynamic per boot kernel randomization, over static 
per system randomization, as i see them, in order of descending 
importance:

 - A root exploit will still not give away the location of the
   kernel (assuming module loading has been disabled after bootup),
   so a rootkit cannot be installed 'silently' on the system, into
   RAM only, evading most offline-storage-checking tools.

   With static linking this is not possible: reading the kernel image
   as root trivially exposes the kernel's location.

 - We can expose RIPs to unprivileged tools. Certain users could
   still kernel-profile a busy server box while neither being root,
   nor having access to the real location of the kernel.

   With static linking this is not possible.

 - Crash & reboot & retry brute force exploits get harder: if one
   attempt at an exploit causes a crash and a reboot, the kernel
   addresses are different after the reboot so the attempt has to be
   retried without the advantage of any prior history.

   With static linking this kind of exploit is somewhat easier: every
   crash gives a permanent proof that the guessed RIP offet was
   wrong, so history can be used on subsequent retries.

 - It gives a way to go one step further in secure server lockdown:
   where even root with full access to all storage has no way to
   break into the kernel. Reboots, module loading and kexec can be
   controlled, ioperm() and iopl() can be restricted. If those are
   taken away then even if a root exploit allows the attacker to
   overwrite the kernel image, a reboot has to be waited for and if
   reboots do sanity checks [based on immutable storage] of the
   system then the exploit can be found.

   With static linking this is not possible: reading the kernel image
   as root trivially exposes the kernel's location.

It's in order of importance: you probably stopped caring at item 2 or 
3 but there's definitely people who'd like to go all the way to 4. So 
if we can do dynamic randomization sanely then why not offer it as an 
option?

Thanks,

	Ingo
