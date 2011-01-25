Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181Ab1AYPIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 10:08:43 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51171 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab1AYPIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BprmF0/0IlbXqi+wZ7Jypg96RwwFrzezA404c3SS4EBUfrGolih+4+tikPh18cvDP/
         hx3a2kLqe8xDknDvAOKjVIcvfmacCMhAgjjkwvr9BaaEo/LMNn9udU0l2SRQSfs+2L2F
         gpTdl5DcqrGsfyVQtqJeMV1ZANruPGl1zAatU=
Date: Tue, 25 Jan 2011 16:08:34 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86-ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Dave Jones <davej@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Willy Tarreau <wtarreau@hera.kernel.org>, Willy Tarreau <w@1wt.eu>,
        Dirk Hohndel <hohndel@infradead.org>, Dirk.Hohndel@intel.com,
        IDE-ML <linux-ide@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/2][concept RFC] x86: BIOS-save kernel log to disk
 upon panic
Message-ID: <20110125150834.GD27510@htj.dyndns.org>
References: <20110125134748.GA10051@laptop>
 <20110125140948.GA26762@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110125140948.GA26762@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On Tue, Jan 25, 2011 at 03:09:48PM +0100, Ingo Molnar wrote:
> I think the biggest areas of practical concern would be:
> 
>  - Can this mechanism ever, under any circumstance corrupt any real
>    data, destroy the MBR or do other nasties. Can you think of any
>    additional fail-safe measures where you could _further robustify
>    the BIOS calls_ to make sure it can never go to the wrong
>    sector(s)? I really do not want to think of trusting a BIOS to
>    _write to my disk_.

It's quite unlikely but I wouldn't say it's completely impossible.
It's common for ATA controllers to have dual modes of operation - the
old IDE compatible interface by emulation which is used by BIOS and
older operating systems and newer interface (ahci) to be used by
modern OS.  Some need to be explicitly switched and some just need to
be accessed carefully.  If the controller is accessed by bIOS after
switched to ahci or commands are in progress via ahci, anything can
happen.

There's also HPA which changes the size of the device which we often
unlock.  As it's always at the end, it usually shouldn't cause
problems but there are BIOSen which expect certain things near the end
of the device (BIOS RAID ones).  I'm fairly sure nobody is testing
BIOSen for cases where the size of underlying device changes without
going through POST.

To summarize, it's unlikely but at the same time there are some
_truly_ scary beasts out in the wild.  There's certain level of
danger.

>  - Is there some hidden disk area somewhere on PCs, or somewhere on
>    a real partition on typical Linux distributions, which we could
>    use without having to reinstall the box? This would increase
>    utility and availability enormously. I'm thinking of partition
>    _ends_ which sometimes get rounded in an awkward way and which
>    are potentially skipped by most Linux filesystems. Even a very
>    small, 512 bytes of area would be extremely useful for debugging
>    weird suspend hangs ...

There are holes but writing to them without full knowledge of the
configuration can be quite dangerous.  I don't think it would be
possible to mass deploy it without manual configuration unless we
specifically reserve (and maybe mark) it in the filesystem.

>  - Could we automate the recovery of the dump, and just put it into
>    the regular kernel log on the next (successful) bootup (on a
>    feature-enabled kernel)? That would make the log of the 'previous
>    crash' very conveniently available in dmesg and the syslog. Tools
>    like kerneloops could make use of it immediately.

Yeah, that would be actually quite nice.

> All in one, a very intriguing idea IMO, and the hardest bits
> (lowlevel x86 transition) is all implemented already.

I like the prospect too but am a bit skeptical whether this can be
made reliable enough to be a convenient tool.

Thanks.

-- 
tejun
