Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2APHy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 02:54:28 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43581 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab2APHyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 02:54:11 -0500
Date: Mon, 16 Jan 2012 08:53:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael D Labriola <mlabriol@gdeb.com>, Matthew Garrett <mjg@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Kushal Koolwal <kushalkoolwal@gmail.com>,
        support@versalogic.com, michael.d.labriola@gmail.com
Subject: Re: Reboot hangs on VersaLogic Ocelot
Message-ID: <20120116075348.GF15641@elte.hu>
References: <OFE7865F25.43E4BFD2-ON85257984.0057CD12-85257984.0058D31D@gdeb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFE7865F25.43E4BFD2-ON85257984.0057CD12-85257984.0058D31D@gdeb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Matthew Garrett)

* Michael D Labriola <mlabriol@gdeb.com> wrote:

> I've been troubleshooting a VersaLogic Ocelot SBC that's been 
> hanging on reboot ever since I upgraded its BIOS.  The 
> conclusion I've come to is that commit e19e074 (x86: Fix 
> reboot problem on VersaLogic Menlow boards) needs to be 
> reverted.
>
> My system was rebooting fine (kernel v3.2) prior to upgrading 
> the BIOS, but it turns out that the DMI string being looked 
> for in the VersaLogic reboot quirk wasn't added until I 
> upgraded the BIOS.
> 
> Here's a summary of the behavior I encountered on my system 
> (VL-EPMs-21a rev 1.00 w/ BIOS 6.5.102)
> 
> - v2.6.37 reboot=bios is needed
> 
> - v2.6.38-rc1: behavior changed, reboot=acpi is needed, reboot=kbd and
>   reboot=bios result in system hang.
> 
> - v2.6.38: VersaLogic patch (e19e074 x86: Fix reboot problem on
>   VersaLogic Menlow boards) was applied prior to v2.6.38-rc7.  This
>   patch sets a quirk for VersaLogic Menlow boards that forces the use
>   of reboot=bios, which doesn't work anymore.  As far as I can tell,
>   there's no way to override this faulty quirk, as it seems to take
>   precedence over the reboot= argument.

That's another bug i'd argue - the user specifying something on 
the boot command line should *always* override the kernel's 
built-in defaults.

> - v3.2: It seems that commit 660e34c (x86: Reorder reboot method
>   preferences) changed the default reboot method to acpi prior to
>   v3.0-rc1, which means the default behavior is appropriate for the
>   Ocelot.  After reverting commit e19e074, my system reboots perfectly
>   w/out passing any reboot= arguments.  I confirmed that this is a
>   true statement for all 3 versions of the Ocelot's BIOS.

And this works for the older BIOS version as well, the one which 
motivated commit e19e074?

Please send a patch that removes the quirk (not named a revert - 
as technically the old quirk did solve problems), with the 
changelog containing your (excellent) bug analysis and the test 
coverage above, plus a signoff?

Matthew, do you concur? Looks like your reordering changes 
actively improved the default behavior and we can start removing 
quirks.

Thanks,

	Ingo
