Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1CJOwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 09:52:44 -0500
Received: from smtp.nokia.com ([147.243.128.24]:25638 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab1CJOwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 09:52:42 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: akpm@linux-foundation.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, sboyd@codeaurora.org
Subject: [PATCHv3 0/4] Improve fallback LPJ calculation
Date: Thu, 10 Mar 2011 16:48:03 +0200
Message-Id: <1299768487-13200-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Apologies for picking on you, Andrew, and sending this out of the blue,
but I didn't have much luck with my previous attempt, and I quite like
this patchset, so thought it was worth trying again.
(http://lkml.org/lkml/2010/9/28/121)

The guts of this patchset are in patch 2/4. The motivation for that patch
is that currently our OMAP calibrates itself using the trial-and-error 
binary chop fallback that some other architectures no longer need to 
perform. This is a lengthy process, taking 0.2s in an environment where 
boot time is of great interest.

Patch 2/4 has two optimisations. Firstly, it replaces the initial repeated-
doubling to find the relevant power of 2 with a tight loop that just does 
as much as it can in a jiffy. Secondly, it doesn't binary chop over an 
entire power of 2 range, it choses a much smaller range based on how much 
it squeezed in, and failed to squeeze in, during the first stage. Both 
are significant optimisations, and bring our calibration down from 23 
jiffies to 5, and, in the process, often arrive at a more accurate lpj 
value.

The 'bands' and 'sub-logarithmic' growth may look over-engineered, but 
they only cost a small level of inaccuracy in the initial guess (for all 
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


Thanks for your time,
Phil
