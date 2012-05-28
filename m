Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab2E1Bxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 21:53:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:47421 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2E1Bx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 21:53:28 -0400
Message-ID: <4FC2DA8C.7050401@linux.vnet.ibm.com>
Date: Sun, 27 May 2012 18:53:16 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, "Tomas M." <tmezzadra@gmail.com>,
        Ferenc Wagner <wferi@niif.hu>, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Kevin Hilman <khilman@ti.com>, Jean Pihet <j-pihet@ti.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Subject: Suspend/resume regressions on Lenovo S10-3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12052801-6148-0000-0000-00000631C7E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a Lenovo S10-3 Atom netbook.  It's always had some amount of
trouble working with the intel_idle driver, so I usually compile that
out an use the acpi one.  However, just after 3.1, suspend/resume broke.
 'echo mem > /sys/power/state' would hang before suspending.  I bisected
it down to the commits around:

	e978aa7d7d57d04eb5f88a7507c4fb98577def77 / v3.1-1-ge978aa7

by Deepthi.  But, current mainline (v3.4-07644-g07acfc2) hangs with a
different symptom: it suspends, but hangs on resume from suspend.  I
think _that_ delta in the behavior was caused by:

	3439a8da16bcad6b0982ece938c9f8299bb53584

        ACPI / cpuidle: Remove acpi_idle_suspend (to fix suspend
		regression)

It's a bit of a pain to bisect these two different things in parallel.
I was trying to tell git bisect 'good' on working suspend/resume, 'bad'
on the hang during resume, and 'skip' on the hangs _during_ suspend.  83
kernels in, I'm not sure that's working very well. :)

Deepthi, do you have any idea why your patches broke me in the first
place?  Perhaps we should fix that regression first before we go on and
try to figure out what changed to let it suspend again, but break later.

Here's my record of the bisect in case anyone's interested:

v3.4-7644-g07acfc2 - hangs on resume
v3.2-9399-g507a03c - hangs on resume
v3.2-3376-g9879326 - hangs on resume
v3.2-rc4-1312-gdfd56b8 - hangs on resume
v3.2-rc2-580-g8054321  - hangs on resume
v3.2-rc2-576-g4c6e869 - hangs on resume!!!!
v3.1-10555-ge0d6511    - works!
v3.1-10181-g32aaeff    - works fine!!! - calling good
v3.1-7844-g6987427 - works!
v3.1.0-00009-ge751b75 - works!
v3.1-5470-g4713e96 - works!!
v3.1-9413-ge45a618 - works!
v3.1-10601-g83dbb15 - works!
v3.1-rc3-115-g8d36ffa - works!
v3.0-7177-g3acc847 - works
v3.1-7712-gcd834fa - works!
v3.1-126-g586e46e - works!
v3.1-rc9-17-g8d73521 - works!
v3.1-rc1-546-g86f14df -  works!
v3.1-rc9-2-gb02b917 - works!
v3.1-5478-gfb4431b - works!
v3.1-5494-gdd76986 - works!
v3.1-rc9-3-g3047454 - works!
v3.1-7715-g4907602 - works!!
v3.2-rc2-570-ge170d18 - hangs on resume!!!!!!
v3.1-rc3-129-g4dc0152 - works
v3.2-rc1-284-g52e4c2a - 52e4c2a05... - hangs on resume!!!!!!
v3.1-rc9-146-g7928631 - works!
v3.1-7720-g78c87e8 - works!!
v3.1-8575-gc4e2d24 - works!
v3.2-rc1-28-gf30a648 - hangs on suspend
v3.2-rc1-282-g3439a8d - hangs on resume
v3.2-rc1-44-ga7c36fd - hangs on suspend
v3.2-rc1-4-gc0d1831 - hangs on suspend
v3.2-rc1-37-g0007fa2 - hangs on suspend
v3.2-rc1-15-g6688a4d - hangs on suspend
v3.2-rc1-11-g2f451d2 - hangs on suspend
v3.1-rc1-549-g19940b3 - hang during boot!!!!!!!!!!
v3.2-rc1-10-g9e226b4 - hangs on suspend
v3.2-rc1-98-g42a0ddc - hangs on suspend
v3.2-rc1-43-g8f3f1c9 - hangs on suspend
v3.2-rc1-13-gaf6d9fe  - hangs on suspend
v3.2-rc1-4-gc288bf2 - hangs on suspend - skip
v3.2-rc1-41-ga4c9e2e - hangs on suspend - skip
v3.2-rc1-3-gee9f7ef - hangs on suspend - skip
v3.2-rc1-1-g816af3b - hangs on suspend - skip
v3.2-rc1-117-gab8fe93 - hangs on suspend - skip
v3.2-rc1-4-g1c8ee73 - hangs on suspend - skip
v3.2-rc1-282-g3439a8d - 3439a8da1... - hangs on suspend - skip
v3.2-rc1-44-ga7c36fd - a7c36fd8c5... - hangs on suspend - skip
v3.2-rc1-189-g87618e0 - hangs on suspend - skip
v3.2-rc1-3-g3b8ce3a - hangs on suspend - skip
v3.2-rc1-190-gf2ee442 - hangs on suspend - skip
v3.2-rc1-2-g272e42b - hangs on suspend - skip
v3.2-rc1-29-g2690e21 - hangs on suspend - skip
v3.2-rc1-142-gf28ad3b - hangs on suspend - skip
v3.2-rc1-12-g091264f - hangs on suspend - skip
v3.2-rc1-3-g3ec7215 - hangs on suspend - skip
v3.2-rc1-6-g2d5fcc9 - hangs on suspend - skip
## recheck v3.2-rc1-281-g5b34b08 - hangs on suspend - skip
v3.2-rc1-6-g55c0008 - hangs on suspend - skip
v3.2-rc1-162-gfe10e6f - hangs on suspend - skip #  216 revisions left
v3.2-rc1-42-gbbe26ff - hangs on suspend - skip #  216 revisions left
v3.1-1-ge978aa7 - hangs on suspend - skip
v3.2-rc1-182-gc1f4246 - hangs on suspend - skip
v3.2-rc1-8-g12b6d9d - hangs on suspend - skip
v3.2-rc1-3-g1b929995 - hangs on suspend - skip
v3.2-rc1-5-g1dd6c07 - hangs on suspend - skip
v3.2-rc1-27-gd890d73 - hangs on suspend - skip
v3.1-10675-ga6f05b9 - hangs on suspend - skip
v3.2-rc1-40-g10b391b - hangs on suspend - skip
v3.2-rc1-5-gf7f9bdf - hangs on suspend - skip
v3.1-16-gefb9058   - hangs on suspend
v3.2-rc1-182-gc1f4246  - hangs on suspend - calling bad
v3.2-rc1-3-g3b8ce3a    - hangs on suspend - calling bad
v3.1-10623-g50e6963    - hangs on suspend - calling bad
v3.1-00003-g4202735 - hangs on suspend
v3.2-rc1-142-gf28ad3b - hangs on suspend
v3.2-rc1-17-g4beb116 - hangs on suspend
v3.1-10692-g54a0f91 - hangs on suspend
v3.1-10620-g1944ce6 - hangs on suspend
v3.1-4-g46bcfad - hangs on suspend

