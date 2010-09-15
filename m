Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab0IOOHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:07:49 -0400
Received: from de01.mail.all-tld.net ([195.140.232.8]:65213 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0IOOHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:07:48 -0400
X-Greylist: delayed 1451 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2010 10:07:48 EDT
Date: Wed, 15 Sep 2010 15:43:26 +0200
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH RFC] x86: hpet: Avoid the readback penalty
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Nix <nix@esperi.org.uk>,
        Artur Skawina <art.08.09@gmail.com>,
        Damien Wyart <damien.wyart@free.fr>,
        John Drescher <drescherjm@gmail.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
	(from tglx@linutronix.de on Wed Sep 15 15:11:57 2010)
X-Mailer: Balsa 2.3.14
Message-Id: <1284558206l.9382l.2l@i-dmzi_al.realan.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
References: <alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-15 15:11:57, Thomas Gleixner wrote:
> -	 * We need to read back the CMP register on certain HPET
> -	 * implementations (ATI chipsets) which seem to delay the
> -	 * transfer of the compare register into the internal compare
> -	 * logic. With small deltas this might actually be too late as
> -	 * the counter could already be higher than the compare value
> -	 * at that point and we would wait for the next hpet interrupt
> -	 * forever. We found out that reading the CMP register back
> -	 * forces the transfer so we can rely on the comparison with
> -	 * the counter register below. If the read back from the
> -	 * compare register does not match the value we programmed
> -	 * then we might have a real hardware problem. We can not do
> -	 * much about it here, but at least alert the user/admin with
> -	 * a prominent warning.
> -	 *
> -	 * An erratum on some chipsets (ICH9,..), results in
> -	 * comparator read immediately following a write returning old
> -	 * value. Workaround for this is to read this value second
> -	 * time, when first read returns old value.
> -	 *
> -	 * In fact the write to the comparator register is delayed up
> -	 * to two HPET cycles so the workaround we tried to restrict
> -	 * the readback to those known to be borked ATI chipsets
> -	 * failed miserably. So we give up on optimizations forever
> -	 * and penalize all HPET incarnations unconditionally.
> +	 * HPETs are a complete disaster. The compare register is
> +	 * based on a equal comparison and does provide a less than or

s/does provide/does not provide/

> +	 * equal functionality (which would require to take the
> +	 * wraparound into account) and it does not provide a simple
> +	 * count down event mode. Further the write to the comparator
> +	 * register is delayed internaly up to two HPET clock cycles

s/internaly/internally/

> +	 * in certain chipsets (ATI, ICH9,10). We worked around that
> +	 * by reading back the compare register, but that required
> +	 * another workaround for ICH9,10 chips where the first
> +	 * readout after write can return the old stale value. We
> +	 * already have a minimum delta of 5us enforced, but a NMI or
> +	 * SMI hitting between the counter readout and the comparator
> +	 * write can move us behind that point easily. Now instead of
> +	 * reading the compare register back several times, we make
> +	 * the ETIME decision based on the following: Return ETIME if
> +	 * the counter value after the write is less than 8 HPET
> +	 * cycles away from the event or if the counter is already
> +	 * ahead of the event.

Cheers
Anders


