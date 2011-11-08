Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab1KHVjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:39:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab1KHVjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:39:31 -0500
Date: Tue, 8 Nov 2011 23:40:23 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Amit Shah <amit.shah@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Krishna Kumar <krkumar2@in.ibm.com>, Pawel Moll <pawel.moll@arm.com>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        avi@redhat.com
Subject: [PATCH RFC] virtio-spec: flexible configuration layout
Message-ID: <20111108214021.GA4538@redhat.com>
References: <87wrbkvh3v.fsf@rustcorp.com.au>
 <20111101114542.GA13434@redhat.com>
 <1320150813.3847.24.camel@lappy>
 <20111101124223.GA14060@redhat.com>
 <8739e7uy87.fsf@rustcorp.com.au>
 <20111102233110.GA20289@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111102233110.GA20289@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

As this solves the dynamic placement of MSIX vectors
and high feature bits,
I thought it's easier to just reserve space for that
programming than give it a separate structure. This
can be changed by a patch on top.

Note that data path is split from configuration.

PDF will follow.
----

diff --git a/virtio-spec.lyx b/virtio-spec.lyx
index 6426f8f..5aec38c 100644
--- a/virtio-spec.lyx
+++ b/virtio-spec.lyx
@@ -56,6 +56,7 @@
 \html_math_output 0
 \html_css_as_file 0
 \html_be_strict false
+\author 1986246365 "Michael S. Tsirkin" 
 \end_header
 
 \begin_body
@@ -570,7 +571,34 @@ Device Configuration
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
@@ -578,6 +606,8 @@ virtio header
  followed by a 
 \emph on
 device-specific region.
+\change_unchanged
+
 \end_layout
 
 \begin_layout Standard
@@ -595,9 +625,23 @@ natural
 \end_layout
 
 \begin_layout Standard
-Note that this is possible because while the virtio header is PCI (i.e.
- little) endian, the device-specific region is encoded in the native endian
- of the guest (where such distinction is applicable).
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
 \end_layout
 
 \begin_layout Subsection
@@ -635,51 +679,2954 @@ Device-specific setup, including reading the Device Feature Bits, discovery
  writing the virtio configuration space.
 \end_layout
 
-\begin_layout Enumerate
-The subset of Device Feature Bits understood by the driver is written to
- the device.
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
+\change_inserted 1986246365 1320781133
+These registers are specified using vendor-specific PCI capability located
+ on capability list in PCI configuration space of the device.
+ This virtio structure capability uses little-endian format; all bits are
+ read-only:
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320772579
+\begin_inset Tabular
+<lyxtabular version="3" rows="4" columns="34">
+<features tabularvalignment="middle">
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
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320781029
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
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772123
+Capability Length = 12
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
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772095
+Next Capability Pointer
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
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772055
+Capability ID = 9
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
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
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
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772549
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
+<cell multicolumn="1" alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320779698
+BAR Indicator Register
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
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
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
+<cell multicolumn="1" alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320772540
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
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320779667
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
+\change_inserted 1986246365 1320781965
+
+\emph on
+BAR Indicator Register
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
+\change_inserted 1986246365 1320786428
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
+\change_inserted 1986246365 1320786428
+ie.
+ once you enable MSI-X on the device, the other fields move.
+ If you turn it off again, they move back!
+\end_layout
+
+\end_inset
+
+.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 1986246365 1320786868
+\begin_inset Tabular
+<lyxtabular version="3" rows="5" columns="6">
+<features tabularvalignment="middle">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<column alignment="center" valignment="top" width="0">
+<row>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Structure
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+ID
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Alignment
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786921
+Minimal Size
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320785821
+Offset in legacy space
+\change_deleted 1986246365 1320785817
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
+\change_inserted 1986246365 1320786926
+Minimal Size in legacy space
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
+4 bytes
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
+\change_inserted 1986246365 1320786236
+24 bytes if MSI-X is enabled, 20 if disabled
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
+2 bytes
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
+1 byte
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
+\change_inserted 1986246365 1320786487
+Device specific
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786513
+24 bytes if MSI-X is enabled, 20 if disabled
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
+\change_inserted 1986246365 1320786492
+Device specific
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
+\change_inserted 1986246365 1320787003
+Queue Notify and ISR status are single-field registers.
+ Device Header has device specific structure.
+ Virtio Header structure is documented below.
+\change_unchanged
+
+\end_layout
+
+\begin_layout Subsection
+Virtio Header
+\end_layout
+
+\begin_layout Standard
+The virtio header looks as follows:
+\end_layout
+
+\begin_layout Standard
+\begin_inset Tabular
+<lyxtabular version="3" rows="4" columns="9">
+<features tabularvalignment="middle">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Bits
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+32
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+32
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+32
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+16
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+16
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+16
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+8
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+8
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Read/Write
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R+W
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R+W
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R+W
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R+W
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R+W
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Purpose
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Device
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Guest
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Queue
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Queue
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Queue
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786386
+
+\size footnotesize
+Reserved
+\change_deleted 1986246365 1320786378
+Queue
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Device
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786393
+
+\size footnotesize
+Reserved
+\change_deleted 1986246365 1320786390
+ISR
+\change_unchanged
+
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
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
+\size footnotesize
+Features bits 0:31
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Features bits 0:31
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Address
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Size
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Select
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_deleted 1986246365 1320786378
+
+\size footnotesize
+Notify
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Status
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\change_deleted 1986246365 1320786388
+
+\size footnotesize
+Status
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
+\change_deleted 1986246365 1320786398
+If MSI-X is enabled for the device, two additional fields immediately follow
+ this header:
+\begin_inset Foot
+status open
+
+\begin_layout Plain Layout
+ie.
+ once you enable MSI-X on the device, the other fields move.
+ If you turn it off again, they move back!
+\end_layout
+
+\end_inset
+
+
+\change_unchanged
+
+\end_layout
+
+\begin_layout Standard
+\begin_inset Tabular
+<lyxtabular version="3" rows="4" columns="3">
+<features tabularvalignment="middle">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Bits
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+16
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+16
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Read/Write
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R+W
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R+W
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Purpose
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Configuration
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Queue
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+(MSI-X)
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Vector
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Vector
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
+\change_deleted 1986246365 1320786816
+Finally, if feature bits (VIRTIO_F_FEATURES_HI)
+\change_unchanged
+ this is immediately followed by two additional fields:
+\end_layout
+
+\begin_layout Standard
+\begin_inset Tabular
+<lyxtabular version="3" rows="4" columns="3">
+<features tabularvalignment="middle">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Bits
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+32
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+32
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Read/Write
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+R+W
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Purpose
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Device
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Guest
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
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
+\size footnotesize
+Features bits 32:63
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Features bits 32:63
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
+\change_deleted 1986246365 1320786783
+Immediately following these general headers, there may be device-specific
+ headers:
+\end_layout
+
+\begin_layout Standard
+
+\change_deleted 1986246365 1320786783
+\begin_inset Tabular
+<lyxtabular version="3" rows="4" columns="2">
+<features tabularvalignment="middle">
+<column alignment="left" valignment="top" width="0">
+<column alignment="left" valignment="top" width="0">
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Bits
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Device Specific
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Read/Write
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Device Specific
+\end_layout
+
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+Purpose
+\end_layout
+
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
+\size footnotesize
+Device Specific...
 \end_layout
 
-\begin_layout Enumerate
-The DRIVER_OK status bit is set.
+\end_inset
+</cell>
+</row>
+<row>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
+
+\begin_layout Plain Layout
+
 \end_layout
 
-\begin_layout Enumerate
-The device can now be used (ie.
- buffers added to the virtqueues)
-\begin_inset Foot
-status open
+\end_inset
+</cell>
+<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
+\begin_inset Text
 
 \begin_layout Plain Layout
-Historically, drivers have used the device before steps 5 and 6.
- This is only allowed if the driver does not use any features which would
- alter this early use of the device.
+
 \end_layout
 
 \end_inset
+</cell>
+</row>
+</lyxtabular>
 
+\end_inset
 
-\end_layout
 
-\begin_layout Standard
-If any of these steps go irrecoverably wrong, the guest should set the FAILED
- status bit to indicate that it has given up on the device (it can reset
- the device later to restart if desired).
-\end_layout
+\change_inserted 1986246365 1320784618
 
-\begin_layout Standard
-We now cover the fields required for general setup in detail.
 \end_layout
 
 \begin_layout Subsection
-Virtio Header
+
+\change_inserted 1986246365 1320786351
+Legacy Virtio Header
 \end_layout
 
 \begin_layout Standard
-The virtio header looks as follows:
+
+\change_inserted 1986246365 1320786351
+For reference, the legacy virtio header looks as follows; one observes that
+ most register offsets match the new virtio header, to make compatibility
+ easier:
 \end_layout
 
 \begin_layout Standard
+
+\change_inserted 1986246365 1320786351
 \begin_inset Tabular
 <lyxtabular version="3" rows="4" columns="9">
 <features tabularvalignment="middle">
@@ -697,6 +3644,8 @@ The virtio header looks as follows:
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Bits
 \end_layout
 
@@ -706,6 +3655,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 32
 \end_layout
 
@@ -715,6 +3666,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 32
 \end_layout
 
@@ -724,6 +3677,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 32
 \end_layout
 
@@ -733,6 +3688,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 16
 \end_layout
 
@@ -742,6 +3699,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 16
 \end_layout
 
@@ -751,6 +3710,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 16
 \end_layout
 
@@ -760,6 +3721,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 8
 \end_layout
 
@@ -769,6 +3732,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 8
 \end_layout
 
@@ -780,6 +3745,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Read/Write
 \end_layout
 
@@ -789,6 +3756,8 @@ Read/Write
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R
 \end_layout
 
@@ -798,6 +3767,8 @@ R
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R+W
 \end_layout
 
@@ -807,6 +3778,8 @@ R+W
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R+W
 \end_layout
 
@@ -816,6 +3789,8 @@ R+W
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R
 \end_layout
 
@@ -825,6 +3800,8 @@ R
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R+W
 \end_layout
 
@@ -834,6 +3811,8 @@ R+W
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R+W
 \end_layout
 
@@ -843,6 +3822,8 @@ R+W
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R+W
 \end_layout
 
@@ -852,6 +3833,8 @@ R+W
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R
 \end_layout
 
@@ -863,6 +3846,8 @@ R
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Purpose
 \end_layout
 
@@ -873,6 +3858,8 @@ Purpose
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Device
 \end_layout
@@ -884,6 +3871,8 @@ Device
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Guest
 \end_layout
@@ -895,6 +3884,8 @@ Guest
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Queue
 \end_layout
@@ -906,6 +3897,8 @@ Queue
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Queue
 \end_layout
@@ -917,6 +3910,8 @@ Queue
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Queue
 \end_layout
@@ -928,6 +3923,8 @@ Queue
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Queue
 \end_layout
@@ -939,6 +3936,8 @@ Queue
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Device
 \end_layout
@@ -950,6 +3949,8 @@ Device
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 ISR
 \end_layout
@@ -963,6 +3964,8 @@ ISR
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \end_layout
 
 \end_inset
@@ -972,6 +3975,8 @@ ISR
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Features bits 0:31
 \end_layout
@@ -983,6 +3988,8 @@ Features bits 0:31
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Features bits 0:31
 \end_layout
@@ -994,6 +4001,8 @@ Features bits 0:31
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Address
 \end_layout
@@ -1005,6 +4014,8 @@ Address
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Size
 \end_layout
@@ -1016,6 +4027,8 @@ Size
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Select
 \end_layout
@@ -1027,6 +4040,8 @@ Select
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Notify
 \end_layout
@@ -1038,6 +4053,8 @@ Notify
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Status
 \end_layout
@@ -1049,6 +4066,8 @@ Status
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Status
 \end_layout
@@ -1064,12 +4083,16 @@ Status
 \end_layout
 
 \begin_layout Standard
+
+\change_inserted 1986246365 1320786351
 If MSI-X is enabled for the device, two additional fields immediately follow
  this header:
 \begin_inset Foot
 status collapsed
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 ie.
  once you enable MSI-X on the device, the other fields move.
  If you turn it off again, they move back!
@@ -1081,6 +4104,8 @@ ie.
 \end_layout
 
 \begin_layout Standard
+
+\change_inserted 1986246365 1320786351
 \begin_inset Tabular
 <lyxtabular version="3" rows="4" columns="3">
 <features tabularvalignment="middle">
@@ -1092,6 +4117,8 @@ ie.
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Bits
 \end_layout
 
@@ -1101,6 +4128,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 16
 \end_layout
 
@@ -1110,6 +4139,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 16
 \end_layout
 
@@ -1121,6 +4152,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Read/Write
 \end_layout
 
@@ -1130,6 +4163,8 @@ Read/Write
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R+W
 \end_layout
 
@@ -1139,6 +4174,8 @@ R+W
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 R+W
 \end_layout
 
@@ -1150,6 +4187,8 @@ R+W
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Purpose
 \end_layout
 
@@ -1160,6 +4199,8 @@ Purpose
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Configuration
 \end_layout
@@ -1171,6 +4212,8 @@ Configuration
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Queue
 \end_layout
@@ -1183,6 +4226,8 @@ Queue
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 (MSI-X)
 \end_layout
 
@@ -1193,16 +4238,7 @@ Queue
 
 \begin_layout Plain Layout
 
-\size footnotesize
-Vector
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
+\change_inserted 1986246365 1320786351
 
 \size footnotesize
 Vector
@@ -1210,145 +4246,15 @@ Vector
 
 \end_inset
 </cell>
-</row>
-</lyxtabular>
-
-\end_inset
-
-
-\end_layout
-
-\begin_layout Standard
-Finally, if feature bits (VIRTIO_F_FEATURES_HI) this is immediately followed
- by two additional fields:
-\end_layout
-
-\begin_layout Standard
-\begin_inset Tabular
-<lyxtabular version="3" rows="4" columns="3">
-<features tabularvalignment="middle">
-<column alignment="left" valignment="top" width="0">
-<column alignment="left" valignment="top" width="0">
-<column alignment="left" valignment="top" width="0">
-<row>
-<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-Bits
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-32
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-32
-\end_layout
-
-\end_inset
-</cell>
-</row>
-<row>
-<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-Read/Write
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-R
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-R+W
-\end_layout
-
-\end_inset
-</cell>
-</row>
-<row>
-<cell alignment="center" valignment="top" topline="true" leftline="true" rightline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-Purpose
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-
-\size footnotesize
-Device
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" topline="true" leftline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-
-\size footnotesize
-Guest
-\end_layout
-
-\end_inset
-</cell>
-</row>
-<row>
 <cell alignment="center" valignment="top" bottomline="true" leftline="true" rightline="true" usebox="none">
 \begin_inset Text
 
 \begin_layout Plain Layout
 
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
-
-\size footnotesize
-Features bits 32:63
-\end_layout
-
-\end_inset
-</cell>
-<cell alignment="center" valignment="top" bottomline="true" leftline="true" usebox="none">
-\begin_inset Text
-
-\begin_layout Plain Layout
+\change_inserted 1986246365 1320786351
 
 \size footnotesize
-Features bits 32:63
+Vector
 \end_layout
 
 \end_inset
@@ -1362,11 +4268,15 @@ Features bits 32:63
 \end_layout
 
 \begin_layout Standard
-Immediately following these general headers, there may be device-specific
+
+\change_inserted 1986246365 1320786351
+Immediately following these general headers, there may be legacy device-specific
  headers:
 \end_layout
 
 \begin_layout Standard
+
+\change_inserted 1986246365 1320786351
 \begin_inset Tabular
 <lyxtabular version="3" rows="4" columns="2">
 <features tabularvalignment="middle">
@@ -1377,6 +4287,8 @@ Immediately following these general headers, there may be device-specific
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Bits
 \end_layout
 
@@ -1386,6 +4298,8 @@ Bits
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Device Specific
 \end_layout
 
@@ -1397,6 +4311,8 @@ Device Specific
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Read/Write
 \end_layout
 
@@ -1406,6 +4322,8 @@ Read/Write
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Device Specific
 \end_layout
 
@@ -1417,6 +4335,8 @@ Device Specific
 \begin_inset Text
 
 \begin_layout Plain Layout
+
+\change_inserted 1986246365 1320786351
 Purpose
 \end_layout
 
@@ -1427,6 +4347,8 @@ Purpose
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \size footnotesize
 Device Specific...
 \end_layout
@@ -1440,6 +4362,8 @@ Device Specific...
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \end_layout
 
 \end_inset
@@ -1449,6 +4373,8 @@ Device Specific...
 
 \begin_layout Plain Layout
 
+\change_inserted 1986246365 1320786351
+
 \end_layout
 
 \end_inset
@@ -1461,6 +4387,15 @@ Device Specific...
 
 \end_layout
 
+\begin_layout Standard
+
+\change_inserted 1986246365 1320786619
+Legacy device-specific headers are supported for backwards compatibility.
+ As such, they are not required to map the whole device configuration structure
+ - only the initial segment expected by legacy drivers needs to be mapped.
+ The size of such legacy segment size is device specific.
+\end_layout
+
 \begin_layout Subsubsection
 Device Status
 \end_layout
@@ -1531,8 +4466,10 @@ name "sub:Feature-Bits"
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
@@ -1540,7 +4477,9 @@ reference "cha:Reserved-Feature-Bits"
 \end_inset
 
 ).
- The bits are allocated as follows:
+ 
+\change_unchanged
+The bits are allocated as follows:
 \end_layout
 
 \begin_layout Description
@@ -1615,10 +4554,14 @@ This allows for forwards and backwards compatibility: if the device is enhanced
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
@@ -1629,10 +4572,14 @@ Configuration/Queue Vectors
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
