Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0I1Kw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 06:52:29 -0400
Received: from 87-119-183-111.tll.elisa.ee ([87.119.183.111]:2772 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750952Ab0I1Kw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 06:52:28 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Sep 2010 06:52:28 EDT
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: mingo@elte.hu, gregkh@suse.de, linux@arm.linux.org.uk, tony@atomide.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        travis@sgi.com, akataria@vmware.com
Subject: [PATCHv2 0/4] Improve fallback LPJ calculation
Date: Tue, 28 Sep 2010 13:44:56 +0300
Message-Id: <1285670700-11099-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The guts of this patchset are in patch 2/4. The motivation for that patch
is that currently our OMAP calibrates itself using the trial-and-error 
binary chop fallback that some other architectures no longer need to 
perform. This is a lengthy process, taking 0.2s in an environment where 
boot time is of great interest. Presumably this is an equivalent win on 
all ARM architectures.

Patch 2/4 has two optimisations. Firstly, it replaces the initial repeated-
doubling to find the relevant power of 2 with a tight loop that just does 
as much as it can in a jiffy. Secondly, it doesn't binary chop over an 
entire power of 2 range, it choses a much smaller range based on how much 
it squeezed in, and failed to squeeze in, during the first stage. Both 
are significant optimisations, and bring our calibration down from 23 
jiffies to 5, and, in the process, often arrive at a more accurate lpj 
value.

The 'bands' and 'sub-logarithmic' growth may look over-engineered, but 
they cost a small level of in inaccuracy of the initial guess (for all 
architectures) in order to avoid the very large inaccuracies that appeared
during testing (on x86_64 architectures, and presumably others with less 
metronomic operation). Note that due to the existence of the TSC and 
other timers, the x86_64 will not typically use this fallback routine, 
but I wanted to code defensively, able to cope with all kinds of processor 
behaviours and kernel command line options.

Patch 3/4 is an additional trap for the nightmare scenario where the
initial estimate is very inaccurate, possibly due to things like SMIs.
It simply retries with a larger bound.

1/4 is simply cosmetic to prepare for 2/4. 
4/4 is simply to assist testing and not intended for integration.


Changes since initial RFC:
 - More informational commit messages
 - Inserted patch 3/4 after discovering that x86_64 had a failure case.

-- 
Cheers,
Phil

