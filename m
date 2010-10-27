Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754Ab0J0DXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 23:23:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40970 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751863Ab0J0DXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 23:23:33 -0400
Date: Tue, 26 Oct 2010 20:23:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] tools: add x86_energy_perf_policy to program
 MSR_IA32_ENERGY_PERF_BIAS
Message-Id: <20101026202307.c028e26c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1010230035360.29399@localhost.localdomain>
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
	<alpine.LFD.2.00.1009281143070.14962@localhost.localdomain>
	<alpine.LFD.2.00.1010230035360.29399@localhost.localdomain>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Oct 2010 00:40:18 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:

> MSR_IA32_ENERGY_PERF_BIAS first became available on Westmere Xeon.
> It is implemented in all Sandy Bridge processors -- mobile, desktop and server.
> It is expected to become increasingly important in subsequent generations.
> 
> x86_energy_perf_policy is a user-space utility to set this
> hardware energy vs performance policy hint in the processor.
> Most systems would benefit from "x86_energy_perf_policy normal"
> at system startup, as the hardware default is maximum performance
> at the expense of energy efficiency.  See the comments
> in the source code for more information.
> 
> Linux-2.6.36 added "epb" to /proc/cpuinfo to indicate
> if an x86 processor supports MSR_IA32_ENERGY_PERF_BIAS,
> though the kernel does not actually program the MSR.
> 
> In March, Venkatesh Pallipadi proposed a small driver
> that programmed MSR_IA32_ENERGY_PERF_BIAS, based on
> the cpufreq governor in use.  It also offered
> a boot-time cmdline option to override.
> http://lkml.org/lkml/2010/3/4/457
> But hiding the hardware policy behind the
> governor choice was deemed "kinda icky".
> 
> So in June, I proposed a generic user/kernel API to
> consolidate the power/performance policy trade-off.
> "RFC: /sys/power/policy_preference"
> http://lkml.org/lkml/2010/6/16/399
> That is my preference for implementing this capability,
> but I received no support on the list.
> 
> So in September, I sent x86_energy_perf_policy.c to LKML,
> a user-space utility that scribbles directly to the MSR.
> http://lkml.org/lkml/2010/9/28/246
> 
> Here is the same utility re-sent, this time proposed
> to reside in the kernel tools directory.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  tools/power/x86/x86_energy_perf_policy/Makefile    |    7 +
>  .../x86_energy_perf_policy.c                       |  358 ++++++++++++++++++++
>  2 files changed, 365 insertions(+), 0 deletions(-)
>  create mode 100644 tools/power/x86/x86_energy_perf_policy/Makefile
>  create mode 100644 tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c

tools/power/x86, eh?  It seems a better place than under
Documentation/, where such things have thus far landed!

I looked briefly, wondering about the kbuild situation.  It doesn't
appear to be wired up, so one has to manually enter that directory and
type `make'?

I guess that's OK as an interim thing but longer-term I suppose we
should have some more complete build and deployment system.  So
(thinking out loud) a `make' would invoke a `make tools', and that
`make tools' would build the tools which are specific to the target
arch[*], and any generic ones.  And a `make tools_install' would install
those tools in, I guess, /lib/modules/$(uname -r)/bin.

Or something else.  We'd need input from the distro guys to get this
right.

[*]: building tools for the `target arch' would require a far more
extensive cross-build environment than is needed for just kernel
cross-compilation.  This is perhaps Just Too Hard and perhaps a `make
tools_install' should copy the *source* into /lib/modules/$(uname
-r)/src and you then finish the build on the target.  Or something
else.  The mind boggles.

So for now, just parking the source down in ./tools/ and deferring the
problem sounds a fine idea ;)

A number of programs down under Documentation/ should be moved into
tools/ as well.

