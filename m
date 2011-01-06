Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab1AFAfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:35:39 -0500
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:37529
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754820Ab1AFAfe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:35:34 -0500
Subject: Re: Using s3virge card in Sun Blade 2000
From: Alex Buell <alex.buell@munted.org.uk>
Reply-To: alex.buell@munted.org.uk
To: David Miller <davem@davemloft.net>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1294262022.24378.2.camel@lithium>
References: <1294086801.17576.14.camel@lithium>
	 <20110103.123939.02282416.davem@davemloft.net>
	 <1294090573.17576.16.camel@lithium>
	 <20110105.110705.104043006.davem@davemloft.net>
	 <1294262022.24378.2.camel@lithium>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Thu, 06 Jan 2011 00:33:49 +0000
Message-ID: <1294274029.24378.11.camel@lithium>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-Gradwell-MongoId: 4d250e54.158a0-236e-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 21:13 +0000, Alex Buell wrote:

> > Then replace all NULL vga_*() initial arguments in the driver
> > with par->vga_iobase. 
> 
> No wonder it was crashing, there was nothing to access with region 1! I
> will do as you suggest, and see if it works. Thank you!

After doing as you suggested:

	printk(KERN_INFO "s3fb: vga io base = 0x%p\n", par->vga_iobase);

        /* Unlock regs */
        cr38 = vga_rcrt(par->vga_iobase, 0x38);
        cr39 = vga_rcrt(par->vga_iobase, 0x39);
        vga_wseq(par->vga_iobase, 0x08, 0x06);
        vga_wcrt(par->vga_iobase, 0x38, 0x48);
        vga_wcrt(par->vga_iobase, 0x39, 0xA5);

        printk(KERN_INFO "s3fb ok...\n");

The above code seems to work, and crashes after this point:

   	/* Identify chip type */
        par->chip = id->driver_data & CHIP_MASK;
        par->rev = vga_rcrt(par->vga_iobase, 0x2f);
        if (par->chip & CHIP_UNDECIDED_FLAG)
                par->chip = s3_identification(par->chip);

The logs shows:

Jan  5 23:16:29 sodium kernel: s3fb: vga io base = 0x000007ffef000000
Jan  5 23:16:29 sodium kernel: s3fb ok...
Jan  5 23:16:29 sodium kernel: ERROR(0): Cheetah error trap taken
afsr[0030100000000000] afar[00000000000003d0] TL1(0)
Jan  5 23:16:29 sodium kernel: ERROR(0): TPC[10583b54] TNPC[10583b58]
O7[10583a3c] TSTATE[9911001606]
Jan  5 23:16:29 sodium kernel: ERROR(0): TPC<s3_pci_probe+0x410/0x93c
[s3fb]>
Jan  5 23:16:29 sodium kernel: ERROR(0): M_SYND(0),  E_SYND(0), Multiple
Errors, Privileged
Jan  5 23:16:29 sodium kernel: ERROR(0): Highest priority error
(0000100000000000) "Unmapped error from system bus"
Jan  5 23:16:29 sodium kernel: ERROR(0): D-cache idx[0]
tag[0000000000000000] utag[0000000000000000] stag[0000000000000000]
Jan  5 23:16:29 sodium kernel: ERROR(0): D-cache data0[0000000000000000]
data1[0000000000000000] data2[0000000000000000] data3[0000000000000000]
Jan  5 23:16:29 sodium kernel: ERROR(0): I-cache idx[0]
tag[0000000000000000] utag[0000000000000000] stag[0000000000000000]
u[0000000000000000] l[0000000000000000]
Jan  5 23:16:29 sodium kernel: ERROR(0): I-cache INSN0[0000000000000000]
INSN1[0000000000000000] INSN2[0000000000000000] INSN3[0000000000000000]
Jan  5 23:16:29 sodium kernel: ERROR(0): I-cache INSN4[0000000000000000]
INSN5[0000000000000000] INSN6[0000000000000000] INSN7[0000000000000000]
Jan  5 23:16:29 sodium kernel: ERROR(0): E-cache idx[3c0]
tag[0000000002249249]
Jan  5 23:16:29 sodium kernel: ERROR(0): E-cache data0[787072745f756e72]
data1[656769737465725f] data2[7472616e73706f72] data3[7400787072745f72]
Jan  5 23:16:29 sodium kernel: Kernel panic - not syncing: Irrecoverable
deferred error trap.

I'm still thinking that it probably isn't the right io_base if it's
crashing trying to identify the s3 chipset. 
-- 
Tactical Nuclear Kittens
