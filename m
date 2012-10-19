Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867Ab2JSReu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 13:34:50 -0400
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:46828 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044Ab2JSRes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 13:34:48 -0400
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Oct 2012 13:34:48 EDT
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: linux-kernel@vger.kernel.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, lenb@kernel.org
Subject: Re: pm_qos request for 0 cpu_dma_latency is ignored on Linus master
Date: Fri, 19 Oct 2012 18:34:39 +0100
Message-ID: <20490918.t8n8AcBcDM@f17simon>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <2732999.VSJZov8CP4@f17simon>
References: <2732999.VSJZov8CP4@f17simon>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1687589.zAj9qJtm0m"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1687589.zAj9qJtm0m
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Sorry for the noise. I've just found it's my code at fault - we changed
to a 10,000 usec PM request for most platforms a while ago.

Simon

On Friday 19 October 2012 18:28:18 Simon Farnsworth wrote:
> (please cc me on replies - I'm not directly subscribed to linux-kernel or linux-pm)
> 
> I'm trying to track down why a Sandybridge system with a PCIe to PCI riser
> has problems after enabling GPU RC6, and I've reduced my problem to the menu
> cpuidle governor selecting high C-states from intel_idle, even though I've
> given a cpu_dma_latency requirement of 0 usecs.
> 
> I have a TV capture card in the riser, and it appears that I get data lost
> whenever the package enters a high C state. My userspace opens
> /dev/cpu_dma_latency and writes (uint32_t)0 to this fd whenever we have things
> on-screen, closing the fd when we put the screen into DPMS off states.
> 
> However, even with a userspace provided request of 0 usec, I'm seeing the CPU
> cores (and hence the entire package when GPU RC6 is enabled) enter C6 state.
> 
> I've confirmed that forcing the governor to limit itself to C0 fixes my
> problem with:
> 
> # for state in /sys/devices/system/cpu/cpu*/cpuidle/state[1-9]*/disable ; do echo 1 > $state ; done
> 
> What do I need to do to get the menu cpuidle governor and the intel_idle
> cpuidle driver to respect the /dev/cpu_dma_latency pm_qos request of 0 usec
> and keep the Sandybridge CPU package out of low C states? Note that a CPU
> core in low C state is fine, as long as the DMA latency stays low.
> 
> My goal is to keep the system in high-performance state when we're rendering
> digital signage on screen (as any glitching may upset viewers, and compared
> to the screen's full power use, we're irrelevant), but to go into lower power
> states when the screen is off (when we're only drawing power to keep the
> administrator interface available).
> 
> My kernel is currently 3.7-rc1+, based on Linus git of Tuesday 16th October
> 2012. I'm happy to try patches, even if all they get you is better debug
> output to work out why the userspace request is ignored.
> 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart1687589.zAj9qJtm0m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAABAgAGBQJQgY8vAAoJEIKsye9/dtRW3gYH/2UgIJAWUPbOAjQ7fGJMsFja
k0BiXi+LRMtShD6Z0i6h1EZdryV3TMeGmF7FKfYX7vd4al6+C+p/GT3n9E9y+Oh1
0RjQO6azV01dcS50LKuaC76ouf0ZBn8cPtAzcWzRA5kVm0vqXB+ZFgPcwC6oFEun
3T0yzWedcD2dtreqvOGFdAvVgKSljPS8gzrrFRCI+ceKv4gsSepdauA0057ojlSG
vWwcGIh/sWpJxCwii4U8QbKK3IUfclDMOf+cx/w7XfZYvAJNWf24iKcfDOE2sOTp
N5Z3MsVgc9XZNuhaQmxnBfEqg4V/P4zN1x+/qBjk5T5jjatFMfZXGARi3YGMlU0=
=PRA9
-----END PGP SIGNATURE-----

--nextPart1687589.zAj9qJtm0m--

