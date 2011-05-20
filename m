Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063Ab1ETOnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:43:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933322Ab1ETOnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:43:03 -0400
Date: Fri, 20 May 2011 10:37:46 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        =?UTF-8?B?SsO2cmctVm9sa2Vy?= Peetz <jvpeetz@web.de>,
        Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] AMD ARAT fixes
Message-ID: <20110520103746.70caaf3c@katamari>
In-Reply-To: <20110518155017.GA14324@gere.osrc.amd.com>
References: <1305636919-31165-1-git-send-email-bp@amd64.org>
	<20110518155017.GA14324@gere.osrc.amd.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 May 2011 17:50:17 +0200
Borislav Petkov <bp@amd64.org> wrote:

> Hi Greg,
> 
> Ingo just confirmed that the following two fixes went upstream. I
> haven't tagged them for stable so I'd appreciate if you could take them
> for the next cycle. AFAICT, the relevant trees should be .38-stable,
> 32-longterm and 33-longterm.
> 
> There should be no problem cherry-picking them but if there is, please
> let me know and I'll give you rebased versions.
> 
> Here the commit ids again, for reference:
> 
> http://git.kernel.org/tip/14fb57dccb6e1defe9f89a66f548fcb24c374c1d
> http://git.kernel.org/tip/328935e6348c6a7cb34798a68c326f4b8372e68a
> 

This still leaves family 10h model 6 stepping 2 (and possibly others)
broken in -stable as well as 2.6.39.

Looking at -stable, this whole mess was caused by:

  commit b87cf80af3ba4b4c008b4face3c68d604e1715c6
  x86, AMD: Set ARAT feature on AMD processors

That caused stalls on family 0fh and family 10h processors, and then
the (partial) fix for that in 2.6.38.6:

  commit e20a2d205c05cef6b5783df339a7d54adeb50962
  x86, AMD: Fix APIC timer erratum 400 affecting K8 Rev.A-E processors

caused instant crashes on boot on older family 0fh processors.

Now it looks like family 0fh is finally fixed in 2.6.38.7.

But I can't find any reason for the original commit that went in 2.6.38.4
to be there in the first place. It doesn't fix any bug whatsoever and
appears to be just a performance enhancement. So how did it get there?

I came up with this (untested) hack for now to fix the remaining bug,
should something like this go in -stable to fix family 10h until a
better way is found?

--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -724,6 +724,15 @@ bool cpu_has_amd_erratum(const int *erra
 		return false;
 
 	/*
+	 * Temporary workaround for ARAT bug on Sempron.
+	 * The BIOS clears the bit in OSVW, so the check
+	 * fails, then ARAT gets set and when the processor
+	 * uses C3 it hangs. Always return true for that CPU.
+	 */
+	if (cpu->x86 == 0x10 && cpu->x86_model == 6 && cpu->x86_mask == 2)
+		return true;
+
+	/*
 	 * Must match family-model-stepping range first so that the
 	 * range checks will override OSVW checking.
 	 */
