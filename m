Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2JSTAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 15:00:09 -0400
Received: from claranet-outbound-smtp06.uk.clara.net ([195.8.89.39]:38547 "EHLO
	claranet-outbound-smtp06.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384Ab2JSTAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 15:00:07 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: linux-kernel@vger.kernel.org
Cc: len.brown@intel.com, linux-pm@vger.kernel.org, lenb@kernel.org
Subject: pm_qos request for 0 cpu_dma_latency is ignored on Linus master
Date: Fri, 19 Oct 2012 18:28:18 +0100
Message-ID: <2732999.VSJZov8CP4@f17simon>
User-Agent: KMail/4.8.4 (Linux/3.4.6-2.fc17.x86_64; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1894394.UJ754FPfpW"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1894394.UJ754FPfpW
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

(please cc me on replies - I'm not directly subscribed to linux-kernel or linux-pm)

I'm trying to track down why a Sandybridge system with a PCIe to PCI riser
has problems after enabling GPU RC6, and I've reduced my problem to the menu
cpuidle governor selecting high C-states from intel_idle, even though I've
given a cpu_dma_latency requirement of 0 usecs.

I have a TV capture card in the riser, and it appears that I get data lost
whenever the package enters a high C state. My userspace opens
/dev/cpu_dma_latency and writes (uint32_t)0 to this fd whenever we have things
on-screen, closing the fd when we put the screen into DPMS off states.

However, even with a userspace provided request of 0 usec, I'm seeing the CPU
cores (and hence the entire package when GPU RC6 is enabled) enter C6 state.

I've confirmed that forcing the governor to limit itself to C0 fixes my
problem with:

# for state in /sys/devices/system/cpu/cpu*/cpuidle/state[1-9]*/disable ; do echo 1 > $state ; done

What do I need to do to get the menu cpuidle governor and the intel_idle
cpuidle driver to respect the /dev/cpu_dma_latency pm_qos request of 0 usec
and keep the Sandybridge CPU package out of low C states? Note that a CPU
core in low C state is fine, as long as the DMA latency stays low.

My goal is to keep the system in high-performance state when we're rendering
digital signage on screen (as any glitching may upset viewers, and compared
to the screen's full power use, we're irrelevant), but to go into lower power
states when the screen is off (when we're only drawing power to keep the
administrator interface available).

My kernel is currently 3.7-rc1+, based on Linus git of Tuesday 16th October
2012. I'm happy to try patches, even if all they get you is better debug
output to work out why the userspace request is ignored.
-- 
Simon Farnsworth
Software Engineer
ONELAN Ltd
http://www.onelan.com

--nextPart1894394.UJ754FPfpW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAABAgAGBQJQgY21AAoJEIKsye9/dtRWB3IH/RzsrDbNPLKFGIUkPGg79otI
WN7GqhgJ1qqYKF8PsasH/Z2Yzi7J9EmePL55nMG8QdNHqXt1MK/qgc4OK847bcNQ
AwksSuJFabZMoJMucmjwILTTH5M8mVk2gyBbiaEJsiPJJRQyL+n6d126pafdx8Og
geXsDUeRxz7Pagm+ONyvz8W1oP9SJyvl7qiWIbGqhbc2HzuQwxVrXsJ6v/lQpTw/
rmOHXqC9w0xfA02rZ/yxhKWUW4hlgS8pdZ0qW5Vzz1F3SxIzXX1dgkTgRpp8HveX
sVLjp0vpBhuTPPUb4TAU8OSi0f0Kxh4T6a+nfGQUdCsgopgF2vlvNkVE4A8vj5k=
=lhxn
-----END PGP SIGNATURE-----

--nextPart1894394.UJ754FPfpW--

