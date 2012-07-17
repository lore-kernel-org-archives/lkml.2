Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab2GQWaM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:30:12 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:39607 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab2GQWaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:30:09 -0400
Date: Tue, 17 Jul 2012 17:42:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH -next] random: Remove remaining relicts of
 rand_initialize_irq()
Message-ID: <20120717214219.GF6049@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Howells <dhowells@redhat.com>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>, linux-ia64@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-next@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>
References: <1342524793-2522-1-git-send-email-sedat.dilek@gmail.com>
 <20120717171251.GD6049@thunk.org>
 <CACRpkdZe48FrDJx1p8ojfqwVBE95hSJipE8rViAi=E28uumYOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZe48FrDJx1p8ojfqwVBE95hSJipE8rViAi=E28uumYOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 08:57:19PM +0200, Linus Walleij wrote:
> So the IRQ will be auto-sampled now or something?
> 
> Sorry for not quite following, which commit do I look at to
> understand this now...

Yes, there was a huge discussion on LKML about two weeks ago.  The
key commit that will be going in during the next merge window is:

http://git.kernel.org/?p=linux/kernel/git/tytso/random.git;a=commitdiff;h=775f4b297b780601e61787b766f306ed3e1d23eb

There are a whole lot of other changes, of course, but that's the key
change which IRQF_SAMPLE_RANDOM a no-op.  People have tested this
under extreme conditions (high speed networking tests with no
interrupt mitigations, etc.) and the patch as tweaked had no
measurable overhead, so we can simply sample every single commit with
a low-overhead fast path which uses per-cpu buffers, and then mix into
the /dev/random entropy pool less frequently (which is still fast, but
requires a few more memory accesses to shared memory that may incur
delays due to cache line bounces).

					- Ted
