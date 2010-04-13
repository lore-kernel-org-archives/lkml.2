Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427Ab0DMIrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 04:47:01 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:49773 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab0DMIq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:46:59 -0400
Date: Tue, 13 Apr 2010 10:46:50 +0200
From: Anders Larsen <al@alarsen.net>
Reply-To: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH 2/2] AT91 slow-clock resume: don't restore the PLL
 settings when the PLL was off
To: Andrew Victor <avictor.za@gmail.com>
Cc: Julien Langer <julien.langer@gmail.com>,
       linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <w2ocd73a99e1004130114g1e46ed2blbcfeef1c9cec0001@mail.gmail.com>
X-Mailer: Balsa 2.3.14
Message-Id: <1271148410l.25331l.4l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <w2ocd73a99e1004130114g1e46ed2blbcfeef1c9cec0001@mail.gmail.com>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 2010-04-13 10:14:53, Andrew Victor wrote:
> > +       tst     r3, #(AT91_PMC_MUL &  0xff0000)
> > +       bne     1f
> > +       tst     r3, #(AT91_PMC_MUL & ~0xff0000)
> > +       beq     2f
> > +1:
> >        wait_pllblock
> > +2:
> 
> AT91_PMC_MUL is 11 bits (so 0x7ff0000)

it's not possible to use that constant directly; there are too many bits
set (the ARM instruction set has room for an 8-bit constant and a shift
value)...

> Is the mask (0xff0000) correct in the above code?
> It looks like wait_pllblock will be skipped if the MUL field is set to
> 0x100, 0x200, 0x300, etc.

...so I made the test a two-step process; the first 'tst' checks if
the bits masked by (AT91_PMC_MUL & 0xff0000) = 0x00ff0000 are all zero,
the second 'tst' checks if the bits masked by
(AT91_PMC_MUL & ~0xff0000) = 0x07000000 are zero, so all 11 bits are
indeed tested.

There might well be an easier way to do this, but I didn't manage to
find it - the code isn't on a hot path anyway (it's executed _once_ upon
resume after suspend).

Cheers
Anders


