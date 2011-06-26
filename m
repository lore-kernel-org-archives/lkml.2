Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1FZQ2R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 12:28:17 -0400
Received: from ist.d-labs.de ([213.239.218.44]:53991 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab1FZQ1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 12:27:39 -0400
Date: Sun, 26 Jun 2011 18:27:25 +0200
From: Florian Mickler <florian@mickler.org>
To: Olaf Freyer <aaron667@gmx.net>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>, dri-devel@lists.freedesktop.org
Subject: Re: Erroneous package power limit notification since kernel 2.6.39
Message-ID: <20110626182725.3f2eac8d@schatten.dmk.lab>
In-Reply-To: <loom.20110525T172412-101@post.gmane.org>
References: <4DD9092A.4080507@gmx.net>
	<loom.20110525T172412-101@post.gmane.org>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 May 2011 15:40:24 +0000 (UTC)
Olaf Freyer <aaron667@gmx.net> wrote:

> Hi,
> 
> I tried to git-bisect to find the root cause of this issue, but feel somewhat
> lost after spending two evening without any usefull results.
> 
> I started with v2.6.38 as last known good and v2.6.39-rc1 as first known bad
> version. My presumption was that bisection would now just happen between those
> two versions - but somehow I ended up building 2.6.38.rc3,+ 2.6.38.rc7+,
> 2.6.38.rc2+ and 2.6.38.rc1+ during this process. Versions that are beyond the
> starting range I intended to use. Or maybe I just haven't understood the whole
> process yet.

This is to be expected. It is because you are asked to test something
which was based on a version before 2.6.38 but which got merged
into Linus' tree after 2.6.38 and so it really ended up in Linus tree
between 2.6.38 and 2.6.39 but has still the before-2.6.38-tag. 

I hope you did trust git-bisect and tested those versions?

> 
> Both of my bisection attempts ended near the same set of drm/i915 changes that
> resulted in non-bootable kernels. Considering I'm using a Intel(R) Core(TM)
> i7-2720QM with some Intel Sandybridge Chipset graphics those might sound
> somewhat plausible to someone knowing the internals, but don't help me at all.

There are 2 untested commits left. But they don't seem to be relevant.
Guessing on those gives me:

The first bad commit could be any of:
b0b544cd37c060e261afb2cf486296983fcb56da
f67a559daaa0e2ba616bfe9438f202bc57bc8c72
18b2190ca5bd3f19717421b1591c79c9b0372428
6f06ce184c765fd8d50669a8d12fdd566c920859
0fc932b8ec36116bb759105ce910b0475e63112a
311bd68e024f9006db66cbadc3bd9f62fd663f4b
040484af3a4efa65786b6e107fbe74747679e17c
ccab5c82759e2ace74b2e84f82d1e0eedd932571
aa9b500ddf1a6318e7cf8b1754696edddae86db9
d9b6cb568bc6eca8db88357bf8bbb92d42a91b1e
92f2584a083986c05fc811bbdf380c3fa7c12296
9a4114ffa7b6f5f4635e3745a8dc051d15d4596a
633f2ea26665d37bb3c8ae30799aa14988622653
63d7bbe9ded4146e3f78e5742b119fa1fdb52665
417ae1476de3ae9689a374d70565f41b3474641e
ea0760cfc00b9e534423fdaf630d1c8ce7a5ede0
b24e71798871089da1a4ab049db2800afc1aac0c
fe4402931e43e81a4129eba41d05cf8907603af5
65993d64a31844ad444694efb2d159eb9c883e49
c0c06bd244179f754d68684fd87674585a153e40
01fe9dbde19a1a27b8ee63e2d964562962e1eb78
a37f2f87edc1b6e5932becf6e51535d36b690f2a
bdd92c9ad287e03a2ec52f5a89c470cd5caae1c2



I'd guess ccab5c82759e2ace74b2e84f82d1e0eedd932571 could be the
cause. Can you check if the appended revert of that commit makes
things disappear? 


> 
> I'm not yet 100% sure, but I think the package power limit notification events I
> see in /var/log/messages might coincide with the moment of my xorg startup. (But
> those are just wall clock time estimations.) I will try some bootups without X
> later this evening and report back if those package power limit notification
> events also trigger without X running.
> 
> The "result" of my last git bisection attempt was:
> 
> git bisect start
> # good: [521cb40b0c44418a4fd36dc633f575813d59a43d] Linux 2.6.38
> git bisect good 521cb40b0c44418a4fd36dc633f575813d59a43d
> # bad: [0ce790e7d736cedc563e1fb4e998babf5a4dbc3d] Linux 2.6.39-rc1
> git bisect bad 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d
> # bad: [179198373cf374f0ef793f1023c1cdd83b53674d] Merge branch 'nfs-for-2.6.39'
> of git://git.linux-nfs.org/projects/trondmy/nfs-2.6
> git bisect bad 179198373cf374f0ef793f1023c1cdd83b53674d
> # good: [6445ced8670f37cfc2c5e24a9de9b413dbfc788d] Merge branch 'staging-next'
> of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
> git bisect good 6445ced8670f37cfc2c5e24a9de9b413dbfc788d
> # good: [d72751ede1b9bf993d7bd3377305c8e9e36a3cc4] Merge branch 'for-davem' of
> ssh://master.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6
> git bisect good d72751ede1b9bf993d7bd3377305c8e9e36a3cc4
> # good: [16d8775700f1815076f879719ce14b33f50a3171] Merge branch 'for-linus' of
> master.kernel.org:/home/rmk/linux-2.6-arm
> git bisect good 16d8775700f1815076f879719ce14b33f50a3171
> # bad: [fd34b0dee4d237ce9332cc62b03adebfe4fa9f9d] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/lethal/fbdev-2.6
> git bisect bad fd34b0dee4d237ce9332cc62b03adebfe4fa9f9d
> # good: [bd35fe5a7930bf83ed56422ea4e4b6471ee6f739] drm/nouveau: fix
> __nouveau_fence_wait performance
> git bisect good bd35fe5a7930bf83ed56422ea4e4b6471ee6f739
> # bad: [942b0e95c34f1ba432d08e1c0288ed032d32c3b2] drm/radeon/kms: fix typo in
> atom overscan setup
> git bisect bad 942b0e95c34f1ba432d08e1c0288ed032d32c3b2
> # bad: [308977ac03117706c342099a40919b3da2667cce] drm/i915: Use DEBUG_KMS for
> the self-refresh watermarks
> git bisect bad 308977ac03117706c342099a40919b3da2667cce
> # skip: [417ae1476de3ae9689a374d70565f41b3474641e] drm/i915: Include TLB miss
> latency in g4x watermark computations
> git bisect skip 417ae1476de3ae9689a374d70565f41b3474641e
> # skip: [b0b544cd37c060e261afb2cf486296983fcb56da] drm/i915: Use PM QoS to
> prevent C-State starvation of gen3 GPU
> git bisect skip b0b544cd37c060e261afb2cf486296983fcb56da
> # skip: [fe4402931e43e81a4129eba41d05cf8907603af5] Merge branch
> 'drm-intel-fixes' into drm-intel-next
> git bisect skip fe4402931e43e81a4129eba41d05cf8907603af5
> # bad: [987a709e1589cf10e250e04ce9df910b735d4f60] drm/i915: remove now
> unnecessary delays in eDP panel power sequencing
> git bisect bad 987a709e1589cf10e250e04ce9df910b735d4f60
> # skip: [18b2190ca5bd3f19717421b1591c79c9b0372428] drm/i915: allow 945 to
> control self refresh (CxSR) automatically
> git bisect skip 18b2190ca5bd3f19717421b1591c79c9b0372428
> # skip: [6f06ce184c765fd8d50669a8d12fdd566c920859] drm/i915: set phase sync
> pointer override enable before setting phase sync pointer
> git bisect skip 6f06ce184c765fd8d50669a8d12fdd566c920859
> # skip: [b24e71798871089da1a4ab049db2800afc1aac0c] drm/i915: add pipe/plane
> enable/disable functions
> git bisect skip b24e71798871089da1a4ab049db2800afc1aac0c
> # skip: [f67a559daaa0e2ba616bfe9438f202bc57bc8c72] drm/i915: skip FDI & PCH
> enabling for DP_A
> git bisect skip f67a559daaa0e2ba616bfe9438f202bc57bc8c72
> # skip: [ea0760cfc00b9e534423fdaf630d1c8ce7a5ede0] drm/i915: add panel lock
> assertion function
> git bisect skip ea0760cfc00b9e534423fdaf630d1c8ce7a5ede0
> # skip: [ccab5c82759e2ace74b2e84f82d1e0eedd932571] drm/i915: tune Sandy Bridge
> DRPS constants
> git bisect skip ccab5c82759e2ace74b2e84f82d1e0eedd932571
> # skip: [a37f2f87edc1b6e5932becf6e51535d36b690f2a] drm/i915: Remove unused code:
> i915_enable_interrupt()
> git bisect skip a37f2f87edc1b6e5932becf6e51535d36b690f2a
> # skip: [aa9b500ddf1a6318e7cf8b1754696edddae86db9] drm/i915: Honour LVDS sync
> polarity from EDID
> git bisect skip aa9b500ddf1a6318e7cf8b1754696edddae86db9
> # skip: [c0c06bd244179f754d68684fd87674585a153e40] drm/i915/ringbuffer: Kill an
> annoyingly frequent debug message
> git bisect skip c0c06bd244179f754d68684fd87674585a153e40
> # skip: [311bd68e024f9006db66cbadc3bd9f62fd663f4b] drm/i915: Trivial sparse fixes
> git bisect skip 311bd68e024f9006db66cbadc3bd9f62fd663f4b
> # skip: [63d7bbe9ded4146e3f78e5742b119fa1fdb52665] drm/i915: add PLL
> enable/disable functions
> git bisect skip 63d7bbe9ded4146e3f78e5742b119fa1fdb52665
> # skip: [0fc932b8ec36116bb759105ce910b0475e63112a] drm/i915: factor out FDI
> disable and add FDI assertions
> git bisect skip 0fc932b8ec36116bb759105ce910b0475e63112a
> # bad: [bdd92c9ad287e03a2ec52f5a89c470cd5caae1c2] Merge branch 'drm-intel-fixes'
> into drm-intel-next
> git bisect bad bdd92c9ad287e03a2ec52f5a89c470cd5caae1c2
> # skip: [040484af3a4efa65786b6e107fbe74747679e17c] drm/i915: add transcoder
> enable/disable functions
> git bisect skip 040484af3a4efa65786b6e107fbe74747679e17c
> # skip: [633f2ea26665d37bb3c8ae30799aa14988622653] drm/i915: Disable SSC for
> outputs other than LVDS or DP
> git bisect skip 633f2ea26665d37bb3c8ae30799aa14988622653
> # skip: [d9b6cb568bc6eca8db88357bf8bbb92d42a91b1e] drm/i915: assert panel is
> unlocked before writing transcoder timing regs
> git bisect skip d9b6cb568bc6eca8db88357bf8bbb92d42a91b1e
> # skip: [9a4114ffa7b6f5f4635e3745a8dc051d15d4596a] drm/i915/bios: Change default
> clock source on PineView to use SSC
> git bisect skip 9a4114ffa7b6f5f4635e3745a8dc051d15d4596a
> # skip: [92f2584a083986c05fc811bbdf380c3fa7c12296] drm/i915: add PCH DPLL
> enable/disable functions
> git bisect skip 92f2584a083986c05fc811bbdf380c3fa7c12296
> # skip: [65993d64a31844ad444694efb2d159eb9c883e49] drm/i915: don't enable plane,
> pipe and PLL prematurely
> git bisect skip 65993d64a31844ad444694efb2d159eb9c883e49
> # skip: [01fe9dbde19a1a27b8ee63e2d964562962e1eb78] drm/i915: Use ACPI OpRegion
> to determine lid status
> git bisect skip 01fe9dbde19a1a27b8ee63e2d964562962e1eb78
> 
> Regards
>   Olaf Freyer
> 

------>8---------->8--------------->8-------------->8------------

    Revert "drm/i915: tune Sandy Bridge DRPS constants"
    
    This reverts parts of  commit ccab5c82759e2ace74b2e84f82d1e0eedd932571.
    
    It does not touch debugfs.c
    
    Conflicts:
    
    	drivers/gpu/drm/i915/i915_debugfs.c

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 5d5def7..a245742 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3378,28 +3378,15 @@
 #define GEN6_RP_DOWN_TIMEOUT			0xA010
 #define GEN6_RP_INTERRUPT_LIMITS		0xA014
 #define GEN6_RPSTAT1				0xA01C
-#define   GEN6_CAGF_SHIFT			8
-#define   GEN6_CAGF_MASK			(0x7f << GEN6_CAGF_SHIFT)
 #define GEN6_RP_CONTROL				0xA024
 #define   GEN6_RP_MEDIA_TURBO			(1<<11)
 #define   GEN6_RP_USE_NORMAL_FREQ		(1<<9)
 #define   GEN6_RP_MEDIA_IS_GFX			(1<<8)
 #define   GEN6_RP_ENABLE			(1<<7)
-#define   GEN6_RP_UP_IDLE_MIN			(0x1<<3)
-#define   GEN6_RP_UP_BUSY_AVG			(0x2<<3)
-#define   GEN6_RP_UP_BUSY_CONT			(0x4<<3)
-#define   GEN6_RP_DOWN_IDLE_CONT		(0x1<<0)
+#define   GEN6_RP_UP_BUSY_MAX			(0x2<<3)
+#define   GEN6_RP_DOWN_BUSY_MIN			(0x2<<0)
 #define GEN6_RP_UP_THRESHOLD			0xA02C
 #define GEN6_RP_DOWN_THRESHOLD			0xA030
-#define GEN6_RP_CUR_UP_EI			0xA050
-#define   GEN6_CURICONT_MASK			0xffffff
-#define GEN6_RP_CUR_UP				0xA054
-#define   GEN6_CURBSYTAVG_MASK			0xffffff
-#define GEN6_RP_PREV_UP				0xA058
-#define GEN6_RP_CUR_DOWN_EI			0xA05C
-#define   GEN6_CURIAVG_MASK			0xffffff
-#define GEN6_RP_CUR_DOWN			0xA060
-#define GEN6_RP_PREV_DOWN			0xA064
 #define GEN6_RP_UP_EI				0xA068
 #define GEN6_RP_DOWN_EI				0xA06C
 #define GEN6_RP_IDLE_HYSTERSIS			0xA070
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index aa43e7b..be9890e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7101,18 +7101,18 @@ void gen6_enable_rps(struct drm_i915_private *dev_priv)
 	I915_WRITE(GEN6_RP_INTERRUPT_LIMITS,
 		   18 << 24 |
 		   6 << 16);
-	I915_WRITE(GEN6_RP_UP_THRESHOLD, 10000);
-	I915_WRITE(GEN6_RP_DOWN_THRESHOLD, 1000000);
+	I915_WRITE(GEN6_RP_UP_THRESHOLD, 90000);
+	I915_WRITE(GEN6_RP_DOWN_THRESHOLD, 100000);
 	I915_WRITE(GEN6_RP_UP_EI, 100000);
-	I915_WRITE(GEN6_RP_DOWN_EI, 5000000);
+	I915_WRITE(GEN6_RP_DOWN_EI, 300000);
 	I915_WRITE(GEN6_RP_IDLE_HYSTERSIS, 10);
 	I915_WRITE(GEN6_RP_CONTROL,
 		   GEN6_RP_MEDIA_TURBO |
 		   GEN6_RP_USE_NORMAL_FREQ |
 		   GEN6_RP_MEDIA_IS_GFX |
 		   GEN6_RP_ENABLE |
-		   GEN6_RP_UP_BUSY_AVG |
-		   GEN6_RP_DOWN_IDLE_CONT);
+		   GEN6_RP_UP_BUSY_MAX |
+		   GEN6_RP_DOWN_BUSY_MIN);
 
 	if (wait_for((I915_READ(GEN6_PCODE_MAILBOX) & GEN6_PCODE_READY) == 0,
 		     500))
