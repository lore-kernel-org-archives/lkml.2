Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab0IJKDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:03:49 -0400
Received: from 87-119-183-14.tll.elisa.ee ([87.119.183.14]:4024 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751353Ab0IJKDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:03:48 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Sep 2010 06:03:48 EDT
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: mingo@elte.hu, gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, travis@sgi.com, akataria@vmware.com
Subject: [RFC 0/3] Improve fallback LPJ calculation
Date: Fri, 10 Sep 2010 12:54:25 +0300
Message-Id: <1284112468-18498-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The motivation for patch 2/3 is that currently our OMAP calibrates
itself using the trial-and-error binary chop fallback that some other
architectures no longer need to perform. This is a lengthy process, 
taking 0.2s in an environment where boot time is of great interest.

The patch has two optimisations. Firstly, it replaces the initial 
repeated-doubling to find the relevant power of 2 with a tight loop 
that just does as much as it can in a jiffy. Secondly, it doesn't 
binary chop over an entire power of 2 range, it choses a much smaller
range based on how much it squeezed in, and failed to squeeze in, 
during the first stage. Both are significant optimisations, and 
bring our calibration down from 23 jiffies to 6, and, in the process,
arrive at a more accurate lpj value.

The 'bands' and 'sub-logarithmic' growth may look over-engineered,
but they cost a small level of in inaccuracy of the initial guess
(for all architectures) in order to avoid the very large inaccuracies 
that appeared during testing (on x86_64 architectures, and presumably 
others with less metronomic operation). Note that due to the existence
of the TSC and other timers, the x86_64 doesn't use this fallback 
routine, but I wanted to code defensively, able to cope with all kinds
of processor behaviours.

1/3 is simply cosmetic to prepare for 2/3. 
3/3 is simply to assist testing and not intended for integration.

I would appreciate it if people with exotic or unusual architectures
could help test this.

Cheers,
Phil
