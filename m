Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab2JASBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 14:01:52 -0400
Received: from mail.x86-64.org ([217.9.48.20]:47583 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab2JASBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 14:01:42 -0400
Date: Mon, 1 Oct 2012 20:01:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH] Prevent AMD MCE oops on multi-server system
Message-ID: <20121001180131.GU5410@aftab.osrc.amd.com>
References: <1349073725-14093-1-git-send-email-daniel@numascale-asia.com>
 <20121001100650.GB4795@aftab.osrc.amd.com>
 <5069C0EF.1050204@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5069C0EF.1050204@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 12:12:31AM +0800, Daniel J Blueman wrote:
> On 01/10/2012 18:06, Borislav Petkov wrote:
> >On Mon, Oct 01, 2012 at 02:42:05PM +0800, Daniel J Blueman wrote:
> >>When booting on a federated multi-server system, the processor Northbridge
> >>lookup returns NULL; add guards to prevent this causing an oops.
> >Interesting.
> >
> >What does lspci say on those systems?
> >
> >Thanks.
> As NumaConnect remote-server I/O is in a pre-release stage, we only
> expose I/O on the first (root) server, so the lspci on eg my three
> server, single-socket C32 development system is uninteresting [1].

Yeah, I was looking for the NB devices:

> 00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor HyperTransport Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Miscellaneous Control
> 00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h Processor Link Control

[ … ]

> We map MMCONFIG addresses in the global address map to the
> respective server, which is how we access the processor Northbridges
> in the bootloader before Linux loads, so they are accessible and get
> enumerated when we enable remote I/O with the ACPI SSDT we generate,
> however since the AMD APIC IDs (hence NB IDs) are only 8-bit, the
> present amd_get_nb_id will produce duplicate NB IDs at best (but in
> this case, as we disable I/O routing, there is no structure); later,
> we may propose to using eg bits 23:8 for the server ID. That's
> another discussion though.

Ah yes, I remember now. We had this discussion already, AFAIR. So if you
say you disable I/O routing, what actually doesn't work out as expected
is the NB enumeration in amd_nb.c where pci_get_device simply fails?

Because if you had duplicate APIC IDs, you'd atleast get some NB
descriptor, even if not the correct one?

> The minimal patch at least corrects the oops regression which didn't
> happen in earlier kernels.

Right, I beefed it up a bit and added a stable tag, pls take a look and
let me know if it is ok. I'll run it on a couple of machines but I don't
expect any issues so I'll send it upstream soon.

Thanks.

---
>From 91388e9d34b44080bbe127c9721b6df36358654c Mon Sep 17 00:00:00 2001
From: Daniel J Blueman <daniel@numascale-asia.com>
Date: Mon, 1 Oct 2012 14:42:05 +0800
Subject: [PATCH] x86, AMD, MCE: Prevent oops on multi-server system

When booting on a federated multi-server system (NumaScale), the
processor Northbridge lookup returns NULL; add guards to prevent this
causing an oops.

On those systems, the northbridge is accessed through MMIO and the
"normal" northbridge enumeration in amd_nb.c doesn't work since we're
generating the northbridge ID from the initial APIC ID and the last
is not unique on those systems. Long story short, we end up without
northbridge descriptors.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
Cc: stable@vger.kernel.org # 3.6
Link: http://lkml.kernel.org/r/1349073725-14093-1-git-send-email-daniel@numascale-asia.com
[ Boris: beef up commit message ]
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index c4e916d77378..698b6ec12e0f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -576,12 +576,10 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	int err = 0;
 
 	if (shared_bank[bank]) {
-
 		nb = node_to_amd_nb(amd_get_nb_id(cpu));
-		WARN_ON(!nb);
 
 		/* threshold descriptor already initialized on this node? */
-		if (nb->bank4) {
+		if (nb && nb->bank4) {
 			/* yes, use it */
 			b = nb->bank4;
 			err = kobject_add(b->kobj, &dev->kobj, name);
@@ -615,8 +613,10 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		atomic_set(&b->cpus, 1);
 
 		/* nb is already initialized, see above */
-		WARN_ON(nb->bank4);
-		nb->bank4 = b;
+		if (nb) {
+			WARN_ON(nb->bank4);
+			nb->bank4 = b;
+		}
 	}
 
 	err = allocate_threshold_blocks(cpu, bank, 0,
-- 
1.7.11.rc1


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
