Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404Ab2IGPyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:54:52 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:65105 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab2IGPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:54:51 -0400
X-IronPort-AV: E=Sophos;i="4.80,387,1344211200"; 
   d="scan'208";a="14414455"
Message-ID: <1347033288.30018.130.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH/RFC] Fix xsave bug on older Xen hypervisors
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefan Bader <stefan.bader@canonical.com>
CC: Jan Beulich <JBeulich@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Justin M. Forbes" <jmforbes@linuxtx.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Matt Wilson <msw@amazon.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Date: Fri, 7 Sep 2012 16:54:48 +0100
In-Reply-To: <504A172B.5020005@canonical.com>
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com>
	 <504A05B00200007800099C7B@nat28.tlf.novell.com>
	 <5049F4E9.9050306@canonical.com>
	 <504A1A950200007800099D4C@nat28.tlf.novell.com>
	 <20120907142251.GA20096@linuxtx.org>
	 <504A32800200007800099E40@nat28.tlf.novell.com>
	 <504A172B.5020005@canonical.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-07 at 16:47 +0100, Stefan Bader wrote:
> On 07.09.2012 17:44, Jan Beulich wrote:
> >>>> On 07.09.12 at 16:22, "Justin M. Forbes" <jmforbes@linuxtx.org> wrote:
> >> On Fri, Sep 07, 2012 at 03:02:29PM +0100, Jan Beulich wrote:
> >>>>>> On 07.09.12 at 15:21, Stefan Bader <stefan.bader@canonical.com> wrote:
> >>>> On 07.09.2012 14:33, Jan Beulich wrote:
> >>>>>>>> On 07.09.12 at 13:40, Stefan Bader <stefan.bader@canonical.com> wrote:
> >>>>>> When writing unsupported flags into CR4 (for some time the
> >>>>>> xen_write_cr4 function would refuse to do anything at all)
> >>>>>> older Xen hypervisors (and patch can potentially be improved
> >>>>>> by finding out what older means in version numbers) would
> >>>>>> crash the guest.
> >>>>>>
> >>>>>> Since Amazon EC2 would at least in the past be affected by that,
> >>>>>> Fedora and Ubuntu were carrying a hack that would filter out
> >>>>>> X86_CR4_OSXSAVE before writing to CR4. This would affect any
> >>>>>> PV guest, even those running on a newer HV.
> >>>>>>
> >>>>>> And this recently caused trouble because some user-space was
> >>>>>> only partially checking (or maybe only looking at the cpuid
> >>>>>> bits) and then trying to use xsave even though the OS support
> >>>>>> was not set.
> >>>>>>
> >>>>>> So I came up with a patch that would
> >>>>>> - limit the work-around to certain Xen versions
> >>>>>> - prevent the write to CR4 by unsetting xsave and osxsave in
> >>>>>>   the cpuid bits
> >>>>>>
> >>>>>> Doing things that way may actually allow this to be acceptable
> >>>>>> upstream, so I am sending it around, now.
> >>>>>> It probably could be improved when knowing the exact version
> >>>>>> to test for but otherwise should allow to work around the guest
> >>>>>> crash while not preventing xsave on Xen 4.x and newer hosts.
> >>>>>
> >>>>> Before considering a hack like this, I'd really like to see evidence
> >>>>> of the described behavior with an upstream kernel (i.e. not one
> >>>>> with that known broken hack patched in, which has never been
> >>>>> upstream afaict).
> >>>>
> >>>> This is the reason I wrote that Fedora and Ubuntu were carrying it. It 
> >> never 
> >>>> has
> >>>> been send upstream (the other version) because it would filter the CR4 
> >> write 
> >>>> for
> >>>> any PV guest regardless of host version.
> >>>
> >>> But iirc that bad patch is a Linux side one (i.e. you're trying to fix
> >>> something upstream that isn't upstream)?
> >>>
> >> Right, so the patch that this improves upon, and that Fedora and Ubuntu are
> >> currently carrying is not upstream because:
> >>
> >> a) It's crap, it cripples upstream xen users, but doesn't impact RHEL xen
> >> users because xsave was never supported there.
> >>
> >> b) The hypervisor was patched to make it unnecessary quite some time ago,
> >> and we hoped EC2 would eventually pick up that correct patch and we could
> >> drop the crap kernel patch.
> >>
> >> Unfortunately this has not happened. We are at a point where EC2 really is
> >> a quirk that has to be worked around. Distros do not want to maintain
> >> a separate EC2 build of the kernel, so the easiest way is to cripple
> >> current upstream xen users.  This quirk is unfortunately the best possible
> >> solution.  Having it upstream also makes it possible for any user to build
> >> an upstream kernel that will run on EC2 without having to dig a random
> >> patch out of a vendor kernel.
> > 
> > All of this still doesn't provide evidence that a plain upstream
> > kernel is actually having any problems in the first place. Further,
> > if you say EC2 has a crippled hypervisor patch - is that patch
> > available for looking at somewhere?
> 
> It was not a hypervisor patch. It was one for the guest. This was the hack:
> 
> From 57bb316c938a9ad65a8093f0584fd22eda88521f Mon Sep 17 00:00:00 2001
> From: John Johansen <john.johansen@canonical.com>
> Date: Tue, 27 Jul 2010 06:06:07 -0700
> Subject: [PATCH] UBUNTU: SAUCE: fix pv-ops for legacy Xen
> 
> Import fix_xen_guest_on_old_EC2.patch from fedora 14
> 
> Legacy hypervisors (RHEL 5.0 and RHEL 5.1) do not handle guest writes to
> cr4 gracefully. If a guest attempts to write a bit of cr4 that is
> unsupported, then the HV is so offended it crashes the domain.

For completeness, was the hypervisor fix this one:

        changeset:   19288:9ed53e602119
        user:        Keir Fraser <keir.fraser@citrix.com>
        date:        Mon Mar 09 08:54:19 2009 +0000
        files:       [...]
        description:
        x86: Mask X86_FEATURE_XSAVE in cpuid leaf 1, ecx, as we don't allow
        guests to use it (by setting cr4.OSXSAVE).
        
        This prevents crashes in pvops kernels, as new versions of Linux
        try to use this feature.
        
        Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
        Signed-off-by: Keir Fraser <keir.fraser@citrix.com>

??


