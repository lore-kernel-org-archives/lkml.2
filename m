Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2HVEu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 00:50:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:33723 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab2HVEuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 00:50:24 -0400
Date: Wed, 22 Aug 2012 01:50:16 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jani Nikula <jani.nikula@intel.com>,
        Yang Guang <guang.a.yang@intel.com>
Subject: Re: [ 04/16] drm/i915: correctly order the ring init sequence
Message-ID: <20120822045015.GB3132@herton-Z68MA-D2H-B3>
References: <20120820035457.653002510@linuxfoundation.org>
 <20120820035458.292084336@linuxfoundation.org>
 <20120821051318.GB3625@herton-Z68MA-D2H-B3>
 <CAKMK7uFpj+qctqKOk6PJqRn_7XAiDbE7Bv2r2VseGyUHUTD2mA@mail.gmail.com>
 <20120821131115.GA3132@herton-Z68MA-D2H-B3>
 <CAKMK7uFjxQZYXLrs14RydnSKp6_ghwUL-1xGQm5C5dXao60Fhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <CAKMK7uFjxQZYXLrs14RydnSKp6_ghwUL-1xGQm5C5dXao60Fhg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 21, 2012 at 06:55:30PM +0200, Daniel Vetter wrote:
> On Tue, Aug 21, 2012 at 3:11 PM, Herton Ronaldo Krzesinski
> <herton.krzesinski@canonical.com> wrote:
> > On Tue, Aug 21, 2012 at 08:42:35AM +0200, Daniel Vetter wrote:
> >> On Tue, Aug 21, 2012 at 7:13 AM, Herton Ronaldo Krzesinski
> >> <herton.krzesinski@canonical.com> wrote:
> >> > I had the same problem as on 3.2 with this change, i915 stopped working
> >> > unable to initialize render ring, eg. on one of the boots here:
> >> > [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f003 head 00001020 tail 00000000 start 00001000
> >> >
> >> > But unlike I was expecting as with 3.2 case, picking commit
> >> > f01db988ef6f6c70a6cc36ee71e4a98a68901229 ("drm/i915: Add wait_for in
> >> > init_ring_common") here isn't enough, it continues to fail even if I
> >> > try to increase the delay in the wait_for, I'm not sure why yet... may
> >> > be something else is going on, or 3.0 has something else missing.
> >> >
> >> > Also the same proposed patch for 3.4.10 gives the same problem, but
> >> > picking f01db988ef6f6c70a6cc36ee71e4a98a68901229 there made things work
> >> > again like happend on first 3.2.28 proposed update. Only 3.0
> >> > is misteriously failing either way here.
> >>
> >> I guess we're missing something then still in the stable backports for
> >> 3.0. Herton, what machine do you have exaclty (lspci -nn)?
> >
> > It's a G41 based board:
> 
> Hm, I've reviewed git log and bug reports and I have no idea what's
> missing on 3.0. I guess the best course of action is to not apply this
> patch to 3.0 stable - it fixes an ivb issue anyway, and 3.0 is a
> rather old kernel for ivb support anyway (we generally recommend 3.2.x
> for ivb).
> -Daniel

Yeah, 3.0 being old, if it was only for ivb, supported only later, makes
sense. I continued investigating this today, and some things are looking
very strange to me. Here is what I discovered and narrowed down so far:

* There is difference of behaviour depending on which environment I
  build 3.0: Originally I built the 3.0 kernel on Ubuntu Oneiric, gcc is
  4.6.1, binutils 2.21.53.20110810 (I'm just saying the versions, not sure
  if it makes a difference or not, and the distro toolchain usually is
  patched so the versions may not mean much). Then I tried building the
  3.0 kernel on a newer environment/distro version, Ubuntu Precise, gcc is
  4.6.3, binutils 2.22.
- Building the stock 3.0.42 proposed kernel on both Ubuntu distros
  (Oneiric and Precise), and testing them, I get the same render ring
  initialization failure.
- Building 3.0.42 with commit f01db988ef6f6c70a6cc36ee71e4a98a68901229
  picked on top gives a different result though: The kernel built on
  Oneiric continues to fail, while the one built on Precise then works.
This was very weird, and I suspected of the toolchain. But the generated
assembly is the same, I also compared the objdump output of the built
i915 module, and there were no differences in the init_common_ring
function. There were some differences in other places, but no difference
in the section of code patched between the working case to the
non-working case. Really didn't made sense, and probably something else
is going on, related to code size or timing or alignment somewhere, I
don't know, but I was unable yet to detect really what's the cause.

I also noticed something else. I started to patch the init_ring_common
function reading back and printing the render ring buffer pointer
values that were being set, with the attached patch, and building the
kernel on the environment which the bug happens (Oneiric). This is the
relevant output I got, I numbered by hand to comment after:

1)
[   34.872786] i915: ctl 00000000 head 00000000 tail 00000000 start 00000000
[   34.872789] i915: ctl 00000000 head 00000000 tail 00000000 start 00000000
[   34.872792] i915: ctl 00000000 head 00000000 tail 00000000 start 00000000
[   34.872793] i915: head = 00000000
[   34.872795] i915: ctl 00000000 head 00000000 tail 00000000 start 00000000
2)
[   34.872797] i915: head = 00001000
[   34.872798] i915: ctl 00000000 head 00001000 tail 00000000 start 00001000
3)
[   35.880034] i915: timeout
[   35.936111] [drm:init_ring_common] *ERROR* render ring initialization failed ctl 0001f003 head 00007cc4 tail 00000000 start 00001000
[   35.936174] i915: 00000001 00001000 00007cc4
[   35.936229] vga_switcheroo: disabled
[   35.936232] [drm:i915_driver_load] *ERROR* failed to init modeset
[   35.954182] i915 0000:00:02.0: PCI INT A disabled
[   35.954188] i915: probe of 0000:00:02.0 failed with error -5

1) At first run, the render ring buffer is "stopped", everything is
zero. The zeros written to ctl, head and tail changes nothing, everything
stays zero, as expected.

2) These are the values read after I915_WRITE_START runs. For some
reason on this machine here, after start address was written, the head
is set the same as the start (?), and this is the root of the failing
case here. I was reading the documentation, and it says when you
write the start address, both head and tail offsets are reset, and thus
this doesn't make sense and shouldn't have happened. May be that's why
the code before has that comment: "/* G45 ring initialization fails to
reset head to zero */", perhaps that code was there for this case.
Strange that depending on where you build things the problem happens or
not, not sure if is just luck or it has something to do with this.

3) head never gets to zero, and seems to continue to increment by itself,
looking at the head value read in the failure path.

I'm not sure if this shed some light, or confuses things even more...

-- 
[]'s
Herton

--ReaqsoxgOBHFXBhH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ring.patch"

diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915/intel_ringbuffer.c
index 38ae0ec..a5ba981 100644
--- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -145,16 +145,43 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 	struct drm_i915_gem_object *obj = ring->obj;
 	u32 head;
 
+	printk("i915: ctl %08x head %08x tail %08x start %08x\n",
+	       I915_READ_CTL(ring),
+	       I915_READ_HEAD(ring),
+	       I915_READ_TAIL(ring),
+	       I915_READ_START(ring));
+
 	/* Stop the ring if it's running. */
 	I915_WRITE_CTL(ring, 0);
+
+	printk("i915: ctl %08x head %08x tail %08x start %08x\n",
+	       I915_READ_CTL(ring),
+	       I915_READ_HEAD(ring),
+	       I915_READ_TAIL(ring),
+	       I915_READ_START(ring));
+
 	I915_WRITE_HEAD(ring, 0);
+
+	printk("i915: ctl %08x head %08x tail %08x start %08x\n",
+	       I915_READ_CTL(ring),
+	       I915_READ_HEAD(ring),
+	       I915_READ_TAIL(ring),
+	       I915_READ_START(ring));
+
 	ring->write_tail(ring, 0);
 
 	head = I915_READ_HEAD(ring) & HEAD_ADDR;
+	printk("i915: head = %08x\n", head);
+
+	printk("i915: ctl %08x head %08x tail %08x start %08x\n",
+	       I915_READ_CTL(ring),
+	       I915_READ_HEAD(ring),
+	       I915_READ_TAIL(ring),
+	       I915_READ_START(ring));
 
 	/* G45 ring initialization fails to reset head to zero */
 	if (head != 0) {
-		DRM_DEBUG_KMS("%s head not reset to zero "
+		DRM_ERROR("%s head not reset to zero "
 			      "ctl %08x head %08x tail %08x start %08x\n",
 			      ring->name,
 			      I915_READ_CTL(ring),
@@ -180,6 +207,17 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 	 * also enforces ordering), otherwise the hw might lose the new ring
 	 * register values. */
 	I915_WRITE_START(ring, obj->gtt_offset);
+	head = I915_READ_HEAD(ring) & HEAD_ADDR;
+	printk("i915: head = %08x\n", head);
+
+	printk("i915: ctl %08x head %08x tail %08x start %08x\n",
+	       I915_READ_CTL(ring),
+	       I915_READ_HEAD(ring),
+	       I915_READ_TAIL(ring),
+	       I915_READ_START(ring));
+	if (wait_for((I915_READ_HEAD(ring) & HEAD_ADDR) == 0, 1000))
+		printk("i915: timeout\n");
+
 	I915_WRITE_CTL(ring,
 			((ring->size - PAGE_SIZE) & RING_NR_PAGES)
 			| RING_REPORT_64K | RING_VALID);
@@ -195,6 +233,7 @@ static int init_ring_common(struct intel_ring_buffer *ring)
 				I915_READ_HEAD(ring),
 				I915_READ_TAIL(ring),
 				I915_READ_START(ring));
+		printk("i915: %08x %08x %08x\n", I915_READ_CTL(ring) & RING_VALID, obj->gtt_offset, I915_READ_HEAD(ring) & HEAD_ADDR);
 		return -EIO;
 	}
 

--ReaqsoxgOBHFXBhH--
