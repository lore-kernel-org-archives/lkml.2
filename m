Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab0FAVje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:39:34 -0400
Received: from n5-vm0.bullet.mail.gq1.yahoo.com ([67.195.8.62]:36423 "HELO
	n5-vm0.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932225Ab0FAVjb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:39:31 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 710098.38695.bm@omp118.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=pZNzPTWFyWPBaCzZ4xElQl8MWNXkwbmahi+B/Z9TC1cAoYN+O0oNJvxYf/yX7K0QLzUMWbEYMOTvZfGnCKKG6YbjiU8HvhBmz4jmzaE+fPZvA7YetvKZC2UoxImQTpa7y2uJ2nrdd/oQi6y3iAZTEaW2CW0794YgGtfqLmsR/OE=;
Message-ID: <599286.8177.qm@web180301.mail.gq1.yahoo.com>
X-YMail-OSG: JFz7gR4VM1l8uKeybQxKJ.Lmm8b_YW6ZTW3E1XBUCdFR1ij
 B9T0N_G_9tqcZNyvEUzYeYzwgwZpa00sWIDIHoi00D1ReATe2NOyv7EDO0EW
 KtoISQyU8.NQogi2QXBQT0ZQw4_ENgnQbSG_9FOGOlHIdVL58Nmwz2fe0AH8
 6pHxe8GM63vaNjtpCxrfhvEiGdpsxS9xI7zgqjEFLLAZtq_LPVt0NqwIk4tx
 9S6W.b_DmDLJamg5l9IV93ZDtxa.RjkvEaK9yGFAGb5W2oOG18K9KpC37aEk
 Y8FHeT5obaHvNjVq2ubXuBY7fTSqrvpfstZfIZaw9rVZIN9I35VTQtXm97jM
 JS4V6xj5fENX5J7QKfm6nXRrf
X-Mailer: YahooMailClassic/11.0.8 YahooMailWebService/0.8.103.269680
Date: Tue, 1 Jun 2010 14:39:29 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
To: Matthew Garrett <mjg59@srcf.ucam.org>,
       James Bottomley <James.Bottomley@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       =?iso-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <1275426085.21962.967.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Tue, 6/1/10, James Bottomley <James.Bottomley@suse.de> wrote:

> > As long as you can set a wakeup timer, an S state is just a C state with 
> > side effects.

I've seen similar statements on this endless
thread before; they're not quite true...


> > The significant one is that entering an
> > S state stops the process scheduler and
> > any in-kernel timers.

There's a structural difference too, related
to peripheral device activity and power states.

Specifically, peripherals can be active in C
states (erforming I/O, maybe with DMA etc) and
 will in general not be in lowest power states
(PCI etc).  Whereas entry to ACPI S-states
involves calling the AML code to put those
peripherals into lowest power modes ... ones
they can't in general enter at run time.  (An
additional task of that bytecode is to activate
any wakeup logic, which again is not generally
functional in except in S-states).


The point being perhaps more that ACPI doesn't
map well to the more power-efficient architectures
(often built on ARM) ... hardware vendors provide
all kinds of PM hooks, and Linux can choose between
them so it's more power-miserly than if it tried
to emulate an ACPI based platform.

I've seen some Linux systems which put DRAM into
self-refresh during certain idle modes, for example,
not just during suspend-to-RAM, if it's known that
no DMA is active.  (Why not save that power if it's
safe?)  Likewise, disable some oscillators and PLLs
if they're not needed (the clock API allows that to
be done regardless of "C-states" etc).

The notion of "suspend" gets introduced on such
systems primarily to match the ACPI-ish models  that
exist ... rather than because they necessarily make
good matches for the hardware.  Which has left a
puzzle:  how and why to use such "suspend" models?

Maybe that's underlying some of the pushback for
the notion of automagic entry to "suspend" states.

- Dave


