Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab1HGAgw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 20:36:52 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35391 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab1HGAgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 20:36:51 -0400
Date: Sun, 7 Aug 2011 01:36:42 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, tglx@linutronix.de, davej@redhat.com,
        yinghan@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Reduce clock calibration time during slave cpu
 startup
Message-ID: <20110807003642.GA4442@srcf.ucam.org>
References: <20110727135730.GA17717@sgi.com>
 <20110727140523.GA24206@redhat.com>
 <20110727141527.GA8453@sgi.com>
 <20110727155200.GA25381@redhat.com>
 <20110801184542.GA3939@sgi.com>
 <20110805104635.GB13055@elte.hu>
 <20110805131638.GA27779@sgi.com>
 <20110805213836.GB21114@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805213836.GB21114@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 11:38:36PM +0200, Ingo Molnar wrote:

> Well, it still uses heuristics: it assumes frequency is the same when 
> the cpuid data tells us that two CPUs are on the same socket, right?

If we only assume that when we have a constant TSC then it's a pretty 
safe assumption - the delay loop will be calibrated against the TSC, and 
the TSC will be constant across the package regardless of what frequency 
the cores are actually running at.

> Cannot we directly see the frequency(ies) of the CPU, and decide 
> based on that whether the calibration result can be cached?

Kind of? We can look at the aperf/mperf ratio and compare that against 
the TSC to work out the frequency. But that only gives you meaningful 
results with a constant TSC, so since you're still depending on that you 
might as well skip the extra check.

The only time this should give problems is if someone produces a 
multi-core x86 with per-core (rather than per-package) TSC and runs the 
TSC at different frequencies per-core. Since that'd probably cost more 
than not doing it, I think we're probably safe.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
