Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab1GXJgf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 05:36:35 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57815 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab1GXJg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 05:36:27 -0400
Date: Sun, 24 Jul 2011 11:36:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Lutomirski <luto@mit.edu>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "davej@redhat.com" <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Langsdorf, Mark" <mark.langsdorf@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH v4 3/7] acpi-cpufreq: Add support for disabling dynamic
 overclocking
Message-ID: <20110724093614.GA9391@aftab>
References: <1311007062-2050-1-git-send-email-mjg@redhat.com>
 <1311007062-2050-4-git-send-email-mjg@redhat.com>
 <4E2B8E36.6030308@mit.edu>
 <20110724033313.GB25722@srcf.ucam.org>
 <CAObL_7Gis4YaSB+suFXxLmSchmJaEc6Jqv6aY6VvWynuEkRb5A@mail.gmail.com>
 <20110724034937.GA25873@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110724034937.GA25873@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 23, 2011 at 11:49:37PM -0400, Matthew Garrett wrote:
> > This way may give the benefit of making it work per core instead of
> > per package.  The manual is rather unclear on this point.
> 
> Being able to enter turbo mode typically requires coordination between 
> the cores in order to ensure that the package remains within limits. The 
> AMD implementation certainly disables their equivalent entirely if any 
> core in the package has it disabled. I haven't verified that Intel 
> behaviour is identical, but it wouldn't surprise me. I can try to check 
> that.

We actually can do both on family 12h - per core and per package
disable. Family 10h, revE does only per-package disable. We opted for
having a single interface for sw and always do per-package disable
simply because we have no usecases for per-core disable and I agree with
Matthew - we'll implement it only when it's needed.

> > I actually have a use case for this.  I have a system that keeps a
> > bunch of cores under moderate load.  I have one thread in particular
> > that needs to be fast, and I'd like to disable boosting on the other
> > cores to keep more thermal and power headroom available for the one
> > thread that cares.
> 
> Are the other threads sufficiently opportunistic to use extra CPU power 
> if it's available to them? You'll generally only get turbo if the other 
> cores are in C6, so even if turbo is disabled on a specific core it'll 
> probably prevent another core from entering turbo if anything's 
> executing on it. You'd arguably want it to be able to get into turbo so 
> it can hit C6 more quickly and let the other thread use the extra 
> headroom.

Right, so we were looking for per-core disable use cases too while
discussing this internally. Andy, limiting the other cores to a higher
P-state (lower freq) and letting the one core boost with a higher
headroom might actually give you more bang than turning off boost on the
n-1 cores. This definitely needs some experimenting and measurements
before you can say for sure. And it all depends on the specific workload
and boosting algorithm.

There's this cpufreq-aperf tool in cpufrequtils which shows
you the boosted freq and C-state residency of the cores, or
<tools/power/x86/turbostat/> in the kernel sources - you might wanna do
some measurements with those to actually have some hard data for your
workload ...

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
