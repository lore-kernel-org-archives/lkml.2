Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500Ab2FNKgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:36:09 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38633 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab2FNKgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:36:07 -0400
Date: Thu, 14 Jun 2012 12:36:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, sjhill@mips.com, ralf@linux-mips.org,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: bugs in page colouring code
Message-ID: <20120614103627.GA25940@aftab.osrc.amd.com>
References: <20120613152936.363396d5@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613152936.363396d5@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 03:29:36PM -0400, Rik van Riel wrote:
> The page colouring code on x86-64, align_addr in sys_x86_64.c is
> slightly more amusing.

This was done with the reviewers' fun level in mind from the very start.

:-)

> For one, there are separate kernel boot arguments to control whether
> 32 and 64 bit processes need to have their addresses aligned for
> page colouring.
> 
> Do we really need that?

Yes.

Mind you, this is only enabled on AMD F15h - all other x86 simply can't
tweak it without code change.

> Would it be a problem if I discarded that code, in order to get to one
> common cache colouring implementation?

Sorry, but, we'd like to keep it in.

> Secondly, MAP_FIXED never checks for page colouring alignment. I
> assume the cache aliasing on AMD Bulldozer is merely a performance
> issue, and we can simply ignore page colouring for MAP_FIXED?

Right, AFAICR, MAP_FIXED is not generally used for shared libs (correct
me if I'm wrong here, my memory is very fuzzy about it) and since we see
the perf issue with shared libs, this was fine.

> That will be easy to get right in an architecture-independent
> implementation.
> 
> 
> A third issue is this:
> 
>         if (!(current->flags & PF_RANDOMIZE))
>                 return addr;
> 
> Do we really want to skip page colouring merely because the 
> application does not have PF_RANDOMIZE set?  What is this
> conditional supposed to do?

Linus said that without this we are probably breaking old userspace
which can't stomach ASLR so we had to respect such userspace which
clears that flag.

> When an app calls mmap with address 0, what breaks by giving it a
> properly page coloured address, instead of the first suitable address
> we find?

Look at dfb09f9b7ab03fd367740e541a5caf830ed56726.

We need bits slice [12:14] in the virtual address to be the same
across all processes mapping the same physical memory otherwise, the
cross-invalidations happen.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
