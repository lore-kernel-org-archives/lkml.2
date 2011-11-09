Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab1KIT6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 14:58:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab1KIT6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 14:58:12 -0500
Date: Wed, 9 Nov 2011 21:59:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com, penberg@kernel.org
Subject: [PATCHv2 RFC] virtio-spec: flexible configuration layout
Message-ID: <20111109195901.GA28155@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
 <20111101114542.GA13434@redhat.com>
 <1320150813.3847.24.camel@lappy>
 <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
 <20111108214021.GA4538@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111108214021.GA4538@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's an updated spec patch. Changes from v1:
- add an example configuration
- scale tables so they fit within page
- clean up some remaining items mentioning feature bit 31

Description from v1:
Here's a spec change documenting what my C patch does
(almost - I tweaked the layout a bit, but the idea is the same).
Some more cleanups are needed but I thought I'd send it
for early flames/comments.

The idea is simple: we split functionally unrelated
register groups to independent structures, and let
the device place is anywhere using a capability
in PCI configuration space.

It can then go into MMIO space which is cheaper than PIO.

A legacy portion of the configuration is mirrored
in the first BAR, to keep legacy drivers working.
Any new fields can be added in existing structures
at the end, so they won't affect legacy.
Alternatively we can add new structures with new
structure IDs, pointed to from PCI configuration space.

As we don't yet have devices or drivers with 64 bit features,
I decided we don't need high feature bits in legacy space.
This also frees up feature bit 31 as we don't need it
to enable high feature bits anymore.
I don't think any released software actually uses it
(the kvm tool HEAD apparently does,
 but I think it's not too late to fix it).

As this solves the dynamic placement of MSIX vectors
and high feature bits,
I thought it's easier to just reserve space for that
programming than give it a separate structure. This
can be changed by a patch on top.

Note that data path is split from configuration.

PDF will follow.

Please comment.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

---

diff --git a/virtio-spec.lyx b/virtio-spec.lyx
index 6426f8f..2ce2553 100644
--- a/virtio-spec.lyx
+++ b/virtio-spec.lyx
@@ -3,6 +3,9 @@
 \begin_document
 \begin_header
 \textclass report
+\begin_preamble
+\usepackage{graphicx}
+\end_preamble
 \use_default_options false
 \maintain_unincluded_children false
 \language english
@@ -56,6 +59,7 @@
 \html_math_output 0
 \html_css_as_file 0
 \html_be_strict false
+\author 1986246365 "Michael S. Tsirkin" 
 \end_header
 
 \begin_body
@@ -570,7 +574,34 @@ Device Configuration
 \end_layout
 
 \begin_layout Standard
-To configure the device, we use the first I/O region of the PCI device.
+To configure the device, we 
+\change_inserted 1986246365 1320783354
+use I/O and/or memory regions of the PCI device.
+ These contain the virtio header registers, the notification register, the
+ ISR status register and device specific registers, as specified by Virtio
+ Structure PCI Capabilities
+\begin_inset Foot
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320787659
+For backwards compatibility, devices should present part of these configuration
+ registers in a legacy configuration structure in the first I/O region of
+ the PCI device
+\change_unchanged
+
+\end_layout
+
+\end_inset
+
+.
+\end_layout
+
+\begin_layout Standard
+
+\change_deleted 1986246365 1320766512
+use the first I/O region of the PCI device.
  This contains a 
 \emph on
 virtio header
@@ -578,105 +609,3115 @@ virtio header
  followed by a 
 \emph on
 device-specific region.
+\change_unchanged
+
+\end_layout
+
+\begin_layout Standard
+There may be different widths of accesses to the I/O region; the 
+\begin_inset Quotes eld
+\end_inset
+
+natural
+\begin_inset Quotes erd
+\end_inset
+
+ access method for each field in the virtio header must be used (i.e.
+ 32-bit accesses for 32-bit fields, etc), but the device-specific region
+ can be accessed using any width accesses, and should obtain the same results.
+\end_layout
+
+\begin_layout Standard
+Note that this is possible because while the virtio header
+\change_inserted 1986246365 1320767249
+, notification and ISR status are
+\change_deleted 1986246365 1320767251
+ is
+\change_unchanged
+ PCI (i.e.
+ little) endian, the device-specific
+\change_deleted 1986246365 1320767335
+ region is
+\change_inserted 1986246365 1320767337
+registers are
+\change_unchanged
+ encoded in the native endian of the guest (where such distinction is applicable
+).
+\change_inserted 1986246365 1320767660
+
+\end_layout
+
+\begin_layout Subsection
+Device Initialization Sequence
+\begin_inset CommandInset label
+LatexCommand label
+name "sub:Device-Initialization-Sequence"
+
+\end_inset
+
+
+\end_layout
+
+\begin_layout Standard
+We start with an overview of device initialization, then expand on the details
+ of the device and how each step is preformed.
+\end_layout
+
+\begin_layout Enumerate
+Reset the device.
+ This is not required on initial start up.
+\end_layout
+
+\begin_layout Enumerate
+The ACKNOWLEDGE status bit is set: we have noticed the device.
+\end_layout
+
+\begin_layout Enumerate
+The DRIVER status bit is set: we know how to drive the device.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 1986246365 1320838089
+PCI capability list scan, detecting virtio configuration layout using Virtio
+ Structure PCI capabilities.
+ 
+\begin_inset Foot
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320838121
+Historically drivers skipped this step, using legacy configuration space
+ unconditionally.
+\change_unchanged
+
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_layout Enumerate
+Device-specific setup, including reading the Device Feature Bits, discovery
+ of virtqueues for the device, optional MSI-X setup, and reading and possibly
+ writing the virtio configuration space.
+\end_layout
+
+\begin_layout Enumerate
+The subset of Device Feature Bits understood by the driver is written to
+ the device.
+\end_layout
+
+\begin_layout Enumerate
+The DRIVER_OK status bit is set.
+\end_layout
+
+\begin_layout Enumerate
+The device can now be used (ie.
+ buffers added to the virtqueues)
+\begin_inset Foot
+status open
+
+\begin_layout Plain Layout
+Historically, drivers have used the device before steps 5 and 6.
+ This is only allowed if the driver does not use any features which would
+ alter this early use of the device.
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\begin_layout Standard
+If any of these steps go irrecoverably wrong, the guest should set the FAILED
+ status bit to indicate that it has given up on the device (it can reset
+ the device later to restart if desired).
+\end_layout
+
+\begin_layout Standard
+We now cover the fields required for general setup in detail.
+\change_inserted 1986246365 1320766663
+
+\end_layout
+
+\begin_layout Subsection
+
+\change_inserted 1986246365 1320781584
+Virtio Structure PCI Capability
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320781061
+Virtio configuration layout includes virtio configuration header, notification
+ and ISR status and device configuration structures.
+ Each structure is mapped by a Base Address register (BAR) belonging to
+ the function, located beginning at 10h in Configuration Space.
+ 
+\emph on
+Structure ID 
+\emph default
+indentifies the structure
+\emph on
+, Size
+\emph default
+ indicates the structure size, in bytes, a 
+\emph on
+BAR Indicator register (BIR)
+\emph default
+ indicates which BAR, and 
+\emph on
+Offset
+\emph default
+ indicates where the structure begins relative to the base address associated
+ with the BAR.
+ The BAR is permitted to be either 32-bit or 64-bit, it can map Memory Space
+ or I/O Space.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320838522
+These registers are specified using vendor-specific PCI capability located
+ on capability list in PCI configuration space of the device.
+ This virtio structure capability uses little-endian format; all bits are
+ read-only:
+\end_layout
+
+\begin_layout Standard
+\begin_inset ERT
+status open
+
+\begin_layout Plain Layout
+
+
+\backslash
+resizebox{
+\backslash
+textwidth}{!}{%
+\end_layout
+
+\end_inset
+
+
+\change_inserted 1986246365 1320839073
+
+\begin_inset Tabular
+<lyxtabular version="3" rows="4" columns="34">
+<features tabularvalignment="bottom">
+<column alignment="center" valignment="top" width="0pt">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0pt">
+<row>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771774
+
+\size tiny
+Bit
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771777
+
+\size tiny
+31
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771779
+
+\size tiny
+30
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771781
+
+\size tiny
+29
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771783
+
+\size tiny
+28
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771786
+
+\size tiny
+27
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771810
+
+\size tiny
+26
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771813
+
+\size tiny
+25
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771815
+
+\size tiny
+24
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771817
+
+\size tiny
+23
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771819
+
+\size tiny
+22
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771821
+
+\size tiny
+21
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771823
+
+\size tiny
+20
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771825
+
+\size tiny
+19
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771829
+
+\size tiny
+18
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771831
+
+\size tiny
+17
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771833
+
+\size tiny
+16
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771835
+
+\size tiny
+15
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771840
+
+\size tiny
+14
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771841
+
+\size tiny
+13
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771843
+
+\size tiny
+12
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771845
+
+\size tiny
+11
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771847
+
+\size tiny
+10
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771850
+
+\size tiny
+9
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771852
+
+\size tiny
+8
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771854
+
+\size tiny
+7
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771856
+
+\size tiny
+6
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771858
+
+\size tiny
+5
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771859
+
+\size tiny
+4
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771861
+
+\size tiny
+3
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771862
+
+\size tiny
+2
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771864
+
+\size tiny
+1
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771888
+
+\size tiny
+0
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320771997
+
+\size tiny
+Offset
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320781029
+
+\size larger
+Structure ID
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320850302
+
+\size larger
+CapLength = 12
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320850298
+
+\size larger
+NextCapPtr
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320850289
+
+\size larger
+CapID = 9
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772004
+0
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772549
+
+\size larger
+Size
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320850408
+
+\size larger
+BIR
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772007
+4
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772540
+
+\size larger
+Offset
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multicolumn="2" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772011
+8
+\end_layout
+
+\end_inset
+</cell>
+</row>
+</lyxtabular>
+
+\end_inset
+
+
+\change_unchanged
+
+\begin_inset ERT
+status open
+
+\begin_layout Plain Layout
+
+}
+\end_layout
+
+\end_inset
+
+
+\change_inserted 1986246365 1320839073
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320838992
+Purpose:
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320780912
+
+\emph on
+Capability ID
+\emph default
+, 
+\emph on
+Next Capability Pointer
+\emph default
+, 
+\emph on
+Capability Length
+\emph default
+ - these fields are specified by PCI local bus specification, Rev 3.0
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320785073
+
+\emph on
+Structure ID
+\emph default
+ - identifies the structure mapped.
+ If an ID representing a specific structure is absent, the structure is
+ located in the legacy virtio configuration in the first PCI BAR.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320782689
+
+\emph on
+Size
+\emph default
+ - size of the structure mapped.
+ This size might include padding, or fields unused by the driver.
+ Drivers are also recommended to only map part of configuration structure
+ large enough for device operation.
+ For example, a future device might present a large structure size of several
+ MBytes.
+ As current devices never utilize structures larger than 4KBytes in size,
+ driver can limit the mapped structure size to e.g.
+ 4KBytes to allow forward compatibility with such devices without loss of
+ functionality and without wasting resources.
+\change_unchanged
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320839833
+
+\emph on
+BIR - BAR Indicator Register
+\emph default
+ - Indicates which one of the BAR registers, located beginning at 10h in
+ Configuration Space, is used to map the structure into Memory or I/O Space.
+ Legal values are 0 - 5.
+ BAR offset is calculated as 
+\emph on
+BAR
+\emph default
+ = 10h + 4 * 
+\emph on
+BIR.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320781002
+
+\emph on
+Offset
+\emph default
+ - Used as an offset from the address contained by one of the function’s
+ Base Address registers to point to the base of the structure.
+ Depending on the structure, the lower bits are masked off (set to zero)
+ by software to form an aligned offset.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320785098
+A single device has multiple virtio capabilities on the PCI capability linked-li
+st.
+ To locate a specific register, driver scans the PCI capability list looking
+ for capabilities using the vendor specific 
+\emph on
+Capability ID
+\emph default
+, that is 
+\emph on
+Capability ID
+\emph default
+ value 
+\emph on
+9
+\emph default
+, according to the PCI spec.
+ For each capability, it verifies that the 
+\emph on
+Capability Length
+\emph default
+ field matches the expected value (12) - if it doesn't, this indicates a
+ layout change, which causes driver to ignore the specific PCI capability
+ and proceed to the next PCI capability in the list.
+ Next,
+\emph on
+ Structure ID
+\emph default
+ single-byte field is read at offset 3.
+ Unrecognized 
+\emph on
+Structure ID
+\emph default
+ values are ignored.
+ Low bits in the 
+\emph on
+Offset
+\emph default
+ register are masked to match alignment requirements, if any.
+ Device drivers are recommended to sanity check 
+\emph on
+BIR
+\emph default
+, 
+\emph on
+Offset
+\emph default
+, and 
+\emph on
+Size
+\emph default
+ fields, ignoring the capability or failing gracefully on error.
+ Drivers are also recommended to only map part of configuration structure
+ large enough for device operation.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320786035
+For backwards compatibility, devices should also present legacy configuration
+ space in the first I/O region of the PCI device, mirroring virtio configuration
+ structures in this space.
+ Drivers should fall back on this legacy structure if a specific Virtio
+ Structure capability is missing in the PCI capability list.
+ However, devices are not required to map the whole configuration structure
+ in legacy space - only the initial segment expected by legacy drivers needs
+ to be mapped.
+ The minimal size of such legacy segment size, for each structure, is listed
+ below.
+ Drivers are discouraged from using legacy space if a specific Structure
+ ID is present; this is to allow deprecating the legacy space in the future.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320850770
+Below is the list of supported Virtio structures, including Structure ID,
+ offset alignment, and where it can be located in the legacy configuration
+ space.
+ Note that legacy space layout changes as the MSI-X capability is enabled
+ and disabled
+\begin_inset Foot
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320856794
+ie.
+ once you enable MSI-X on the device, some legacy fields move.
+ If you turn it off again, they move back! this does not affect the new
+ configuration 
+\end_layout
+
+\end_inset
+
+.
+ Alignment, offset and all sizes are in bytes.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320786868
+\begin_inset Tabular
+<lyxtabular version="3" rows="6" columns="6">
+<features tabularvalignment="middle">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<row>
+<cell multirow="3" alignment="left" valignment="middle" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Structure
+\change_inserted 1986246365 1320855560
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multirow="3" alignment="left" valignment="middle" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+ID
+\change_inserted 1986246365 1320855560
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Align-
+\end_layout
+
+\end_inset
+</cell>
+<cell multirow="3" alignment="left" valignment="middle" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855560
+MinSize
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320785821
+Offset in
+\change_deleted 1986246365 1320785817
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320850780
+MinSize in
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell multirow="4" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell multirow="4" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855625
+ment
+\end_layout
+
+\end_inset
+</cell>
+<cell multirow="4" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855593
+legacy space
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855610
+ legacy space
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320785855
+Virtio Header
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320785860
+0x1
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786157
+4
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786225
+28 bytes
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786145
+0
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855180
+24 or 20
+\begin_inset Foot
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855511
+\begin_inset CommandInset label
+LatexCommand label
+name "fn:24-or-20"
+
+\end_inset
+
+24 bytes if MSI-X is enabled, 20 bytes if it is disabled
+\change_unchanged
+
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786188
+Queue Notify
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786191
+0x2
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786267
+2 bytes
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786228
+2 bytes
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786505
+16 bytes
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786303
+2
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786878
+ISR Status
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786260
+0x3
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786270
+1 byte
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786273
+1 byte
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786534
+19 bytes
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786306
+1
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786847
+Device Header
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786474
+0x4
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786477
+1 byte
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855405
+?
+\begin_inset Foot
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855417
+\begin_inset CommandInset label
+LatexCommand label
+name "fn:Device-specific"
+
+\end_inset
+
+Device specific
+\change_unchanged
+
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855534
+24 or 20
+\begin_inset Formula $^{\text{\ref{fn:24-or-20}}}$
+\end_inset
+
+
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320855432
+?
+\begin_inset Formula $^{\text{\ref{fn:Device-specific}}}$
+\end_inset
+
+
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+</lyxtabular>
+
+\end_inset
+
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320786973
+Drivers should assume that each structure size can be extended in the future.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320859762
+Queue Notify and ISR status are single-field registers.
+ Device Header has device specific structure.
+ Virtio Header structure is documented below.
+\end_layout
+
+\begin_layout Subsubsection
+
+\change_inserted 1986246365 1320867253
+Example Virtio Structure Layout
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320865758
+Let's assume that a virtio block device presents two Virtio Structure capabiliti
+es in PCI capability list:
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320863392
+Structure ID 0x1; BIR 1; Offset 0x1000; Size 0x100
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320863399
+Structure ID 0x4; BIR 1; Offset 0x1100; Size 0x200
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320863479
+Let's further assume that MSI-X is disabled.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320863498
+In this case, the driver should use:
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320863543
+Virtio Header at offset 0x1000 in BAR 1
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320863568
+Device Header at offset 0x1100 in BAR1
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320868074
+Queue Notify at offset 0x10 in BAR0 (legacy configuration space is used
+ since Structure ID is not present)
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320868077
+ISR status at offset 0x13 in BAR0 (legacy configuration space is used since
+ Structure ID is not present)
+\change_unchanged
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320867162
+For use by legacy drivers, the first 20 bytes in BAR0 mirror bytes 0x1000
+ to 0x1013 in BAR1, and the following 32 bytes in BAR0 should mirror bytes
+ 0x1100 to 111F in BAR1.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320867231
+Enabling MSI-X only affects the legacy drivers: with MSI-X enabled, the
+ first 24 bytes in BAR0 mirror bytes 0x1000 to 0x1017 in BAR1, and the following
+ 32 bytes in BAR0 should mirror bytes 0x1100 to 111F in BAR1.
+\change_unchanged
+
+\end_layout
+
+\begin_layout Subsection
+
+\change_inserted 1986246365 1320855988
+Virtio Header
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320858571
+The virtio header looks as follows:
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320858597
+\begin_inset Tabular
+<lyxtabular version="3" rows="13" columns="3">
+<features tabularvalignment="middle">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<row>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858603
+Bits
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858614
+R/W
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858619
+Purpose
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858841
+32
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858858
+R
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858870
+Device Features bits 0:31
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858873
+32
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858876
+R+W
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858885
+Guest Features bits 0:31
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858889
+32
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858891
+R+W
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858907
+Queue Address
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859001
+16
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859006
+R
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858953
+Queue Size
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859012
+16
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859008
+R+W
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858957
+Queue Select
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859015
+16
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858964
+Reserved
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859029
+8
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859032
+R+W
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858972
+Device Status
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859052
+8
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320858989
+Reserved
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859063
+16
+\change_unchanged
+
 \end_layout
 
-\begin_layout Standard
-There may be different widths of accesses to the I/O region; the 
-\begin_inset Quotes eld
 \end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
 
-natural
-\begin_inset Quotes erd
-\end_inset
+\begin_layout Plain Layout
 
- access method for each field in the virtio header must be used (i.e.
- 32-bit accesses for 32-bit fields, etc), but the device-specific region
- can be accessed using any width accesses, and should obtain the same results.
-\end_layout
+\change_inserted 1986246365 1320859065
+R+W
+\change_unchanged
 
-\begin_layout Standard
-Note that this is possible because while the virtio header is PCI (i.e.
- little) endian, the device-specific region is encoded in the native endian
- of the guest (where such distinction is applicable).
 \end_layout
 
-\begin_layout Subsection
-Device Initialization Sequence
-\begin_inset CommandInset label
-LatexCommand label
-name "sub:Device-Initialization-Sequence"
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859081
+MSI-X Configuration Vector
+\change_unchanged
+
+\end_layout
 
 \end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
 
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859083
+16
+\change_unchanged
 
 \end_layout
 
-\begin_layout Standard
-We start with an overview of device initialization, then expand on the details
- of the device and how each step is preformed.
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859088
+R+W
+\change_unchanged
+
 \end_layout
 
-\begin_layout Enumerate
-Reset the device.
- This is not required on initial start up.
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859095
+MSI-X Queue Vector
+\change_unchanged
+
 \end_layout
 
-\begin_layout Enumerate
-The ACKNOWLEDGE status bit is set: we have noticed the device.
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859102
+32
+\change_unchanged
+
 \end_layout
 
-\begin_layout Enumerate
-The DRIVER status bit is set: we know how to drive the device.
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859106
+R
+\change_unchanged
+
 \end_layout
 
-\begin_layout Enumerate
-Device-specific setup, including reading the Device Feature Bits, discovery
- of virtqueues for the device, optional MSI-X setup, and reading and possibly
- writing the virtio configuration space.
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859116
+Device Features bits 32:63
+\change_unchanged
+
 \end_layout
 
-\begin_layout Enumerate
-The subset of Device Feature Bits understood by the driver is written to
- the device.
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859122
+32
+\change_unchanged
+
 \end_layout
 
-\begin_layout Enumerate
-The DRIVER_OK status bit is set.
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320859119
+R+W
+\change_unchanged
+
 \end_layout
 
-\begin_layout Enumerate
-The device can now be used (ie.
- buffers added to the virtqueues)
-\begin_inset Foot
-status open
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
 
 \begin_layout Plain Layout
-Historically, drivers have used the device before steps 5 and 6.
- This is only allowed if the driver does not use any features which would
- alter this early use of the device.
+
+\change_inserted 1986246365 1320859130
+Guest Features bits 32:63
+\change_unchanged
+
 \end_layout
 
 \end_inset
+</cell>
+</row>
+</lyxtabular>
+
+\end_inset
 
 
 \end_layout
 
-\begin_layout Standard
-If any of these steps go irrecoverably wrong, the guest should set the FAILED
- status bit to indicate that it has given up on the device (it can reset
- the device later to restart if desired).
+\begin_layout Subsubsection
+
+\change_inserted 1986246365 1320856004
+Legacy 
+\change_unchanged
+Virtio Header
 \end_layout
 
 \begin_layout Standard
-We now cover the fields required for general setup in detail.
-\end_layout
 
-\begin_layout Subsection
-Virtio Header
+\change_inserted 1986246365 1320867482
+For backwards compatibility, devices should mirror the initial part of virtio
+ header and device header structures, Queue Notify and ISR Status registers
+ in legacy configuration space in the first I/O region of the PCI device.
+ Drivers should fall back on this legacy structure if a specific Virtio
+ Structure capability is missing in the PCI capability list.
+ Drivers are discouraged from using legacy space if a specific Structure
+ ID is present; this is to allow deprecating the legacy space in the future.
 \end_layout
 
 \begin_layout Standard
-The virtio header looks as follows:
+
+\change_inserted 1986246365 1320859848
+For reference, the
+\change_deleted 1986246365 1320856044
+The
+\change_unchanged
+ 
+\change_inserted 1986246365 1320859848
+legacy 
+\change_unchanged
+virtio header looks as follows
+\change_inserted 1986246365 1320859848
+; one observes that most register offsets match the new virtio header, to
+ make compatibility easier
+\change_unchanged
+:
 \end_layout
 
 \begin_layout Standard
@@ -1067,11 +4108,15 @@ Status
 If MSI-X is enabled for the device, two additional fields immediately follow
  this header:
 \begin_inset Foot
-status collapsed
+status open
 
 \begin_layout Plain Layout
 ie.
- once you enable MSI-X on the device, the other fields move.
+ once you enable MSI-X on the device, the other fields 
+\change_inserted 1986246365 1320867540
+in legacy configuration 
+\change_unchanged
+move.
  If you turn it off again, they move back!
 \end_layout
 
@@ -1219,11 +4264,15 @@ Vector
 \end_layout
 
 \begin_layout Standard
+
+\change_deleted 1986246365 1320867563
 Finally, if feature bits (VIRTIO_F_FEATURES_HI) this is immediately followed
  by two additional fields:
 \end_layout
 
 \begin_layout Standard
+
+\change_deleted 1986246365 1320867563
 \begin_inset Tabular
 <lyxtabular version="3" rows="4" columns="3">
 <features tabularvalignment="middle">
@@ -1359,11 +4408,16 @@ Features bits 32:63
 \end_inset
 
 
+\change_unchanged
+
 \end_layout
 
 \begin_layout Standard
-Immediately following these general headers, there may be device-specific
- headers:
+Immediately following these general headers, there may be 
+\change_inserted 1986246365 1320856347
+legacy 
+\change_unchanged
+device-specific headers:
 \end_layout
 
 \begin_layout Standard
@@ -1459,6 +4513,17 @@ Device Specific...
 \end_inset
 
 
+\change_inserted 1986246365 1320856108
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320856109
+Legacy device-specific headers are supported for backwards compatibility.
+ As such, they are not required to map the whole device configuration structure
+ - only the initial segment expected by legacy drivers needs to be mapped.
+ The size of such legacy segment size is device specific.
 \end_layout
 
 \begin_layout Subsubsection
@@ -1531,8 +4596,10 @@ name "sub:Feature-Bits"
 The least significant 31 bits of the first configuration field indicates
  the features that the device supports (the high bit is reserved, and will
  be used to indicate the presence of future feature bits elsewhere).
- If more than 31 feature bits are supported, the device indicates so by
- setting feature bit 31 (see 
+ 
+\change_deleted 1986246365 1320784929
+If more than 31 feature bits are supported, the device indicates so by setting
+ feature bit 31 (see 
 \begin_inset CommandInset ref
 LatexCommand ref
 reference "cha:Reserved-Feature-Bits"
@@ -1540,7 +4607,9 @@ reference "cha:Reserved-Feature-Bits"
 \end_inset
 
 ).
- The bits are allocated as follows:
+ 
+\change_unchanged
+The bits are allocated as follows:
 \end_layout
 
 \begin_layout Description
@@ -1615,10 +4684,14 @@ This allows for forwards and backwards compatibility: if the device is enhanced
 \end_layout
 
 \begin_layout Standard
+
+\change_deleted 1986246365 1320784940
 Access to feature bits 32 to 63 is enabled by Guest by setting feature bit
  31.
  If this bit is unset, Device must assume that all feature bits > 31 are
  unset.
+\change_unchanged
+
 \end_layout
 
 \begin_layout Subsubsection
@@ -1629,10 +4702,14 @@ Configuration/Queue Vectors
 When MSI-X capability is present and enabled in the device (through standard
  PCI configuration space) 4 bytes at byte offset 20 are used to map configuratio
 n change and queue interrupts to MSI-X vectors.
- In this case, the ISR Status field is unused, and device specific configuration
- starts at byte offset 24 in virtio header structure.
+ In this case, the ISR Status field is unused
+\change_deleted 1986246365 1320784981
+, and device specific configuration starts at byte offset 24 in virtio header
+ structure.
  When MSI-X capability is not enabled, device specific configuration starts
- at byte offset 20 in virtio header.
+ at byte offset 20 in virtio header
+\change_unchanged
+.
 \end_layout
 
 \begin_layout Standard
@@ -3829,7 +6906,13 @@ Appendix B: Reserved Feature Bits
 \end_layout
 
 \begin_layout Standard
-Currently there are five device-independent feature bits defined:
+Currently there are 
+\change_deleted 1986246365 1320867366
+five
+\change_inserted 1986246365 1320867367
+four
+\change_unchanged
+ device-independent feature bits defined:
 \end_layout
 
 \begin_layout Description
@@ -3926,9 +7009,13 @@ An experimental virtio PCI driver contained in Linux version 2.6.25 had this
 \end_layout
 
 \begin_layout Description
+
+\change_deleted 1986246365 1320867370
 VIRTIO_F_FEATURES_HIGH(31) This feature indicates that the device supports
  feature bits 32:63.
  If unset, feature bits 32:63 are unset.
+\change_unchanged
+
 \end_layout
 
 \begin_layout Chapter*
@@ -4186,6 +7273,24 @@ struct virtio_net_config {
 
 \end_layout
 
+\begin_layout Description
+
+\change_inserted 1986246365 1320867743
+Device
+\begin_inset space ~
+\end_inset
+
+legacy
+\begin_inset space ~
+\end_inset
+
+configuration
+\begin_inset space ~
+\end_inset
+
+size for this device is 8 bytes.
+\end_layout
+
 \begin_layout Section*
 Device Initialization
 \end_layout
@@ -5226,6 +8331,24 @@ struct virtio_blk_config {
 
 \end_layout
 
+\begin_layout Description
+
+\change_inserted 1986246365 1320867779
+Device
+\begin_inset space ~
+\end_inset
+
+legacy
+\begin_inset space ~
+\end_inset
+
+configuration
+\begin_inset space ~
+\end_inset
+
+size for this device is 32 bytes.
+\end_layout
+
 \begin_layout Section*
 Device Initialization
 \end_layout
@@ -5780,6 +8903,24 @@ struct virtio_console_config {
 
 \end_layout
 
+\begin_layout Description
+
+\change_inserted 1986246365 1320867806
+Device
+\begin_inset space ~
+\end_inset
+
+legacy
+\begin_inset space ~
+\end_inset
+
+configuration
+\begin_inset space ~
+\end_inset
+
+size for this device is 8 bytes.
+\end_layout
+
 \begin_layout Section*
 Device Initialization
 \end_layout
@@ -5994,6 +9135,28 @@ configuration
 \end_inset
 
 layout None currently defined.
+\change_inserted 1986246365 1320867840
+
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 1986246365 1320867845
+Device
+\begin_inset space ~
+\end_inset
+
+legacy
+\begin_inset space ~
+\end_inset
+
+configuration
+\begin_inset space ~
+\end_inset
+
+size for this device is 0 bytes.
+\change_unchanged
+
 \end_layout
 
 \begin_layout Section*
@@ -6127,6 +9290,24 @@ struct virtio_balloon_config {
 
 \end_layout
 
+\begin_layout Description
+
+\change_inserted 1986246365 1320867865
+Device
+\begin_inset space ~
+\end_inset
+
+legacy
+\begin_inset space ~
+\end_inset
+
+configuration
+\begin_inset space ~
+\end_inset
+
+size for this device is 4 bytes.
+\end_layout
+
 \begin_layout Section*
 Device Initialization
 \end_layout
