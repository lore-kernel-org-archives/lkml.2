Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1I1Ny6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:54:58 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50807 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754369Ab1I1Ny5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:54:57 -0400
Subject: Re: [PATCH] virtio: Add platform bus driver for memory mapped
 virtio device
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Cc: peter.maydell@linaro.org, Rusty Russell <rusty@rustcorp.com.au>,
        Anthony Liguori <aliguori@us.ibm.com>,
        "Michael S.Tsirkin" <mst@redhat.com>
In-Reply-To: <1317217663-32647-1-git-send-email-pawel.moll@arm.com>
References: <1317217663-32647-1-git-send-email-pawel.moll@arm.com>
Date: Wed, 28 Sep 2011 14:54:46 +0100
Message-ID: <1317218086.3058.142.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 28 Sep 2011 13:54:47.0080 (UTC) FILETIME=[2EF72280:01CC7DE6]
X-MC-Unique: 111092814545203601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So here I am with the first non-RFC patch :-) It will be followed by the
> spec, as we discussed, in the form of an appendix to the main document.

Here it goes than... It's LaTeX so Rusty can easily get it into his
spec, hope it's readable enough - if not I can provide a PDF.

8<---------------------------------------------------------------------

\documentclass[12pt]{article}

\begin{document}

Virtual environments without PCI support (a common situation in embedded
devices models) might use simple memory mapped device (``virtio-mmio'')
instead of the PCI device.

The memory mapped virtio device behaviour is based on the PCI device
specification. Therefore most of operations like device initialization,
queues configuration and buffer transfers are nearly identical. Existing
differences are described in the following sections. 

\subsection{Device Initialization}

Instead of using the PCI IO space for virtio header, the ``virtio-mmio''
device provides a set of memory mapped control registers, all 32 bits
wide, followed by device-specific configuration space. The following
list presents their layout: 

\begin{itemize}
\item Offset from the device base address | Direction | Name \\
Description
\item 0x000 | R | MagicValue \\
``virt'' string.
\item 0x004 | R | Version \\
Device version number. Currently must be 1.
\item 0x008 | R | DeviceID \\
Virtio Subsystem Device ID (ie. 1 for network card).
\item 0x00c | R | VendorID \\
Virtio Subsystem Vendor ID.
\item 0x010 | R | HostFeatures \\
Flags representing features the device supports.\\
Reading from this register returns 32 consecutive flag bits, first bit
depending on the last value written to HostFeaturesSel register.  Access
to this register returns bits $HostFeaturesSel*32$ to
$(HostFeaturesSel*32)+31$, eg. feature bits 0 to 31 if HostFeaturesSel
is set to 0 and features bits 32 to 63 if HostFeaturesSel is set to 1.
Also see p. 2.2.2.2 ``Feature Bits''.
\item 0x014 | W | HostFeaturesSel \\
Device (Host) features word selection.\\
Writing to this register selects a set of 32 device feature bits
accessible by reading from HostFeatures register. Device driver must
write a value to the HostFeaturesSel register before reading from the
HostFeatures register.
\item 0x020 | W | GuestFeatures \\
Flags representing device features understood and activated by the
driver.\\
Writing to this register sets 32 consecutive flag bits, first bit
depending on the last value written to GuestFeaturesSel register. Access
to this register sets bits $GuestFeaturesSel*32$ to
$(GuestFeaturesSel*32)+31$, eg. feature bits 0 to 31 if GuestFeaturesSel
is set to 0 and features bits 32 to 63 if GuestFeaturesSel is set to 1.\
\
Also see p. 2.2.2.2 ``Feature Bits''.
\item 0x024 | W | GuestFeaturesSel \\
Activated (Guest) features word selection.\\
Writing to this register selects a set of 32 activated feature bits
accessible by writing to the GuestFeatures register. Device driver must
write a value to the GuestFeaturesSel register before writing to the
GuestFeatures register.
\item 0x028 | W | GuestPageSize \\
Guest page size.\\
Device driver must write the guest page size in bytes to the register
during initialization, before any queues are used.
\item 0x030 | W | QueueSel \\
Virtual queue index (first queue is 0).\\
Writing to this register selects the virtual queue that the following
operations on QueueNum, QueueAlign and QueuePFN apply to.
\item 0x034 | RW | QueueNum \\
Virtual queue size (number of elements in the queue, therefore size of
the descriptor table and both available and used rings).\\
Writing to this register notifies the Host what size of the queue the
Guest would like to use.\\
Reading from the register returns the queue size that the Host is ready
to process (might be different than the requested size) or zero (0x0) if
queue is not available.\\
Both read and write accesses apply to the queue selected by writing to
QueueSel.
\item 0x038 | W | QueueAlign \\
Used Ring alignment in the virtual queue.\\
Writing to this register notifies the Host about alignment boundary of
the Used Ring in bytes. This applies to the queue selected by writing to
QueueSel.
\item 0x03c | RW | QueuePFN \\
Guest physical page number of the virtual queue.\\
Writing to this register notifies the host about location of the virtual
queue in the Guest's physical address space. This value is the index
number of a page starting with the queue Descriptor Table.  Value zero
(0x0) means physical address zero (0x00000000) and is illegal. When the
Guest stops using the queue it must write zero (0x0) to this register.\\
Reading from this register returns the currently used page number of the
queue, therefore a value other than zero (0x0) means that the queue is
in use.\\
Both read and write accesses apply to the queue selected by writing to
QueueSel.
\item 0x050 | W | QueueNotify \\
Queue notifier.\\
Writing a queue index to this register notifies the Host that there are
new buffers to process in the queue.
\item 0x060 | W | InterruptACK \\
Interrupt acknowledge. \\
Writing to this register notifies the Host that the Guest finished
receiving used buffers from the device and therefore serviced an
asserted interrupt. Values written to this register are currently not
used, but for future extensions it must be set to one (0x1).
\item 0x070 | RW | Status \\
Device status. \\
Reading from this register returns the current device status flags. \\
Writing non-zero values to this register sets the status flags,
indicating the Guest progress. Writing zero (0x0) to this register
triggers a device reset. \\
Also see p. 2.2.2.1 ``Device Status''.
\item 0x100+ | RW | Config \\
Device-specific configuration space starts at an offset 0x100 and is
accessed with byte alignment. Its meaning and size depends on the device
and the driver.
\end{itemize}

The endianness of the registers follows the native endianness of the
Guest. Writing to registers described as ``R'' and reading from
registers described as ``W'' is not permitted and can cause undefined
behavior.

The device initialization is performed as described in p. 2.2.1 ``Device
Initialization Sequence'' with one exception: the Guest must notify the
Host about its page size, writing the size in bytes to GuestPageSize
register before the initialization is finished.

The memory mapped virtio devices generate single interrupt only,
therefore no special configuration is required.


\subsection{Virtqueue Configuration}

The virtual queue configuration is performed in a similar way to the one
described in p 2.3 ``Virtqueue Configuration'' with a few additional
operations:
\begin{enumerate}
\item Write the queue index (first queue is 0) to the QueueSel register.
\item Check if the queue is not already in use: read QueuePFN register,
returned value should be zero (0x0).
\item Optionally write requested queue size to QueueNum register. If
this is not done, the Host uses the default, device specific, queue
size.
\item Read configured queue size from the QueueNum register. Note that
it might be different from the size requested in previous step.
\item Allocate and zero the queue in contiguous virtual memory, aligning
the Used Ring to an optimal boundary (usually page size).
\item Notify the Host about the used alignment by writing its value in
bytes to QueueAlign register.
\item Write the physical number of the first page of the queue to the
QueuePFN register.
\end{enumerate}
The queue and the device are ready to begin normal operations now.


\subsection{Device Operation}

The memory mapped virtio device behaves in the same way as described in
p. 2.4 ``Device Operation'', with the following exceptions:
\begin{enumerate}
\item The device is notified about new buffers available in a queue by
writing the queue index to register QueueNum instead of the virtio
header in PCI I/O space (p. 2.4.1.4 ``Notifying The Device'').
\item As the memory mapped virtio device is using single, dedicated
interrupt signal, its handling is much simpler than in the PCI (MSI-X)
case (p.  2.4.2 ``Receiving Used Buffer From The Device''). Therefore
all the Guest interrupt handler should do after receiving used buffers
is acknowledging the interrupt by writing a value to the InterruptACK
register. Currently this value does not carry any meaning, but for
future extensions it must be set to one (0x1).
\item The dynamic configuration changes, as described in p. 2.4.3
``Dealing With Configuration Changes'' are not permitted.
\end{enumerate}

\end{document}


8<---------------------------------------------------------------------

Cheers!

Paweł


