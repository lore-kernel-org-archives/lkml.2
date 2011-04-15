Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1DOOEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 10:04:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59265 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab1DOOEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 10:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=C5oFVT+pg+jKQfoGdx7EySsXNW75TO9hKc479Y8agAt7u8D2KL2gCE5t6EzzEptJkD
         FXRbcKFk6UjMrvkdSTDlip8hdWoMO30V9XtiysCfkeg88oRzP+8Xm5MUgPNuitBxUyLj
         fdkuoxQBft45itMIfUo8GWJ5jp7eHFauo6GQg=
Date: Fri, 15 Apr 2011 16:04:45 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        alexandre.f.demers@gmail.com
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415140445.GA4883@alberich.amd.com>
References: <4DA5F62F.3030504@kernel.org>
 <20110413193459.GL19819@8bytes.org>
 <4DA60C30.4060606@kernel.org>
 <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
 <4DA6145D.9070703@kernel.org>
 <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
 <4DA655E7.3000904@zytor.com>
 <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com>
 <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
 <20110415131152.GJ18463@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415131152.GJ18463@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 03:11:52PM +0200, Joerg Roedel wrote:
> On Wed, Apr 13, 2011 at 07:33:40PM -0700, Linus Torvalds wrote:
> >  we definitely want to also understand the reason for things not
> > working, even if we do revert..
> 
> Okay, here it is.
> 
> After experimenting with different configurations for the north-bridge
> it turned out that a GART related MCE fires at the time the machine
> reboots. BIOSes configure the machine to sync-flood in that case which
> causes a reboot.
> 
> After decoding the MCE it turned out to be a GART TBL Wlk Error. Such
> errors can happen if devices (speculativly) access GART ranges mapped
> invalid. The AMD BKDG for Fam10h CPUs recommends to disable these errors
> at all. But unfortunatly some BIOSes (including the one on my laptop)
> forget to do this.
> 
> Below is a patch which disables these errors if the BIOS didn't do it.
> It fixes the problem on my site.
> 
> Alexandre, can you try this patch on your machine too, please?
> 
> Regards,
> 
> 	Joerg
> 
> From aaacff8db50b6ed4345e337ecbe53e505699c7e5 Mon Sep 17 00:00:00 2001
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Fri, 15 Apr 2011 14:47:40 +0200
> Subject: [PATCH] x86/amd: Disable GartTlbWlkErr when BIOS forgets it
> 
> This patch disables GartTlbWlk errors on AMD Fam10h CPUs if
> the BIOS forgets to do is (or is just too old). Letting
> these errors enabled can cause a sync-flood on the CPU
> causing a reboot.
> 
> This patch is the fix for
> 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=33012
> 
> on my machine.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>


Joerg,

What about tagging this patch for stable/longterm releases?

Potentially there are other cases where certain combinations of
hardware(GPUs)/drivers/whatsoever might trigger a GartTlbWlkErr. If
the BIOS doesn't follow the BKDG recommendation to mask these errors,
the system will hang/reboot. Thus I think having this quirk in .32 and
.38 (at least) is useful.


Andreas
