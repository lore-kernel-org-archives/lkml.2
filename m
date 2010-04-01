Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab0DADcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 23:32:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57050 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0DADby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 23:31:54 -0400
To: Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, len.brown@intel.com,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-acpi@vger.kernel.org, Iranna D Ankad <iranna.ankad@in.ibm.com>,
       Gary Hade <garyhade@us.ibm.com>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: [PATCH 0/14] Start coping gsis < 16 that are not isa irqs.
References: <1269221770-9667-1-git-send-email-yinghai@kernel.org>
	<1269221770-9667-3-git-send-email-yinghai@kernel.org>
	<alpine.LFD.2.00.1003221131470.3147@localhost.localdomain>
	<m1iq8f1c1f.fsf@fess.ebiederm.org> <4BB0EA22.7000004@zytor.com>
	<m1r5n2wwah.fsf_-_@fess.ebiederm.org>
	<alpine.LFD.2.00.1003312154180.13993@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 31 Mar 2010 20:31:39 -0700
In-Reply-To: <alpine.LFD.2.00.1003312154180.13993@localhost.localdomain> (Len Brown's message of "Wed\, 31 Mar 2010 22\:02\:33 -0400 \(EDT\)")
Message-ID: <m17horu9us.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: lenb@kernel.org, protasnb@gmail.com, garyhade@us.ibm.com, iranna.ankad@in.ibm.com, linux-acpi@vger.kernel.org, fenghua.yu@intel.com, tony.luck@intel.com, len.brown@intel.com, suresh.b.siddha@intel.com, trenn@suse.de, linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, akpm@linux-foundation.org, mingo@elte.hu, yinghai@kernel.org, tglx@linutronix.de, hpa@zytor.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

>> It appears there are a few systems in the wild that use acpi
>> interrupt source overrides to report a gsi > 16 is an isa irq.
>> 
>> This breaks all kinds of assumptions I figure any BIOS doing that
>> probably should be shot as that is very much not a conservative position.
>
> You might run into trouble here on the ES7000 -- though I don't know
> if anybody is booting a modern kernel on one of those these days.
>
> IIR, ES7000 treated the bottom 16 as a special case.
> When there was an irq shortage, I think they used overrides
> to map higher PCI irqs into the empty spots below 16,
> but I think to make room for them they may have mapped
> some of the ISA irqs to high numbers.  Fuzzy memory
> on this at the moment...

A couple of things.

The ES7000 change is trivially safe because despite differences in how
the numbers are computed I have made that transform that the es7000
does always apply.

I also talked to Natalie about this.  I can't be certain about this
but from your description, from Natalies memories and from looking
at the code.  I believe the problem on the ES7000 is exactly what
I am fixing in the code.  Natalie has threatened to test this on
an ES7000.

The case of interest is this:
Weird but valid platforms where
GSI 0-15 are not ISA irqs.

Some high numbered GSIs are ISA irqs and use interrupt source
overrides to describe them.

That is the case on the IBM platform that regressed a bit ago
and Iranna D Ankad bisected a failure on. On that IBM platform
GSI 0-15 (because the are not ISA irqs) are unusable today.

Everything points to this problem I an fixing being the problem with
early ES7000 machines, including the memory of their boot firmware
developers complaint that they were in spec.

Eric

