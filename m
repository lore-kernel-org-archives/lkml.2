Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341Ab1HRHzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 03:55:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36660 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab1HRHzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 03:55:05 -0400
Subject: [PATCH] virtio-blk: Update spec with new stats vq
From: Sasha Levin <levinsasha928@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 18 Aug 2011 10:53:52 +0300
Message-ID: <1313654032.28910.9.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The diff below is an update to virtio-spec with specification of a stats
vq added to virtio-blk.

The idea behind adding a stats vq is to simplify pull of information
which exists only on the guest and can't be collected on the host.

The idea is basically same as the stats vq which exists in
virtio-balloon and reporting host memory statistics.

---
diff --git a/old/virtio-spec.lyx b/new/virtio-spec.lyx
index 448af76..8c3fe7b 100644
--- a/old/virtio-spec.lyx
+++ b/new/virtio-spec.lyx
@@ -58,6 +58,7 @@
 \html_be_strict false
 \author -608949062 "Rusty Russell,,," 
 \author 1 "Michael S. Tsirkin" 
+\author 2090695081 "Sasha Levin" 
 \end_header
 
 \begin_body
@@ -5224,7 +5225,24 @@ ID 2
 \end_layout
 
 \begin_layout Description
-Virtqueues 0:requestq.
+Virtqueues 0:requestq
+\change_inserted 2090695081 1313645732
+.
+ 1:statsq.
+\begin_inset Foot
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313645739
+Only if VIRTIO_BLK_F_STATS_VQ set
+\end_layout
+
+\end_inset
+
+
+\change_unchanged
+.
 \end_layout
 
 \begin_layout Description
@@ -5330,6 +5348,20 @@ VIRTIO_BLK_F_SECTOR_MAX
 \end_inset
 
 (10) Maximum total sectors in an I/O.
+\change_inserted 2090695081 1313645792
+
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 2090695081 1313645806
+VIRTIO_BLK_F_STATS_VQ
+\begin_inset space \space{}
+\end_inset
+
+(11) A virtqueue for reporting guest block statistics is present.
+\change_unchanged
+
 \end_layout
 
 \end_deeper
@@ -5449,8 +5481,32 @@ If the VIRTIO_BLK_F_RO feature is set by the
device, any write requests
 If the VIRTIO_BLK_F_SECTOR_MAX feature is negotiated, the sectors_max
field
  should be read to determine the maximum I/O size for the driver to
use.
  No requests should be submitted which go beyond this limit.
+\change_inserted 2090695081 1313653667
+
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1313653667
+If the VIRTIO_BLK_F_STATS_VQ feature bit is negotiated:
+\end_layout
+
+\begin_deeper
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1313653667
+Identify the stats virtqueue.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1313653667
+Add one empty buffer to the stats virtqueue and notify the host.
+\change_unchanged
+
 \end_layout
 
+\end_deeper
 \begin_layout Section*
 Device Operation
 \end_layout
@@ -5849,6 +5905,312 @@ residual
 status
 \emph default
  field is a separate read-only buffer of size 1 byte, by itself.
+\change_inserted 2090695081 1313646835
+
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 2090695081 1313646856
+Block
+\begin_inset space \space{}
+\end_inset
+
+Statistics
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313646867
+The stats virtqueue is atypical because communication is driven by the
device
+ (not the driver).
+ The channel becomes active at driver initialization time when the
driver
+ adds an empty buffer and notifies the device.
+ A request for block statistics proceeds as follows:
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1313646835
+The device pushes the buffer onto the used ring and sends an interrupt.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1313646835
+The driver pops the used buffer and discards it.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1313646878
+The driver collects block statistics and writes them into a new buffer.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1313646835
+The driver adds the buffer to the virtqueue and notifies the device.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1313646835
+The device pops the buffer (retaining it to initiate a subsequent
request)
+ and consumes the statistics.
+\end_layout
+
+\begin_layout Description
+
+\change_inserted 2090695081 1313646925
+Block
+\begin_inset space \space{}
+\end_inset
+
+Statistics
+\begin_inset space \space{}
+\end_inset
+
+Format Each statistic consists of a 16 bit tag and a 64 bit value.
+ Both quantities are represented in the native endian of the guest.
+ All statistics are optional and the driver may choose which ones to
supply.
+ To guarantee backwards compatibility, unsupported statistics should be
+ omitted.
+\end_layout
+
+\begin_deeper
+\begin_layout Standard
+
+\change_inserted 2090695081 1313646835
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313646940
+
+struct virtio_blk_stat {
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651887
+
+#define VIRTIO_BLK_S_READ_IO 0
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651942
+
+#define VIRTIO_BLK_S_READ_MERGES 1
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651940
+
+#define VIRTIO_BLK_S_READ_SECTORS 2
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651939
+
+#define VIRTIO_BLK_S_READ_TICKS 3
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651938
+
+#define VIRTIO_BLK_S_WRITE_IO 4
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651936
+
+#define VIRTIO_BLK_S_WRITE_MERGES 5
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651935
+
+#define VIRTIO_BLK_S_WRITE_SECTORS 6
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651934
+
+#define VIRTIO_BLK_S_WRITE_TICKS 7
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651932
+
+#define VIRTIO_BLK_S_IN_FLIGHT 8
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651931
+
+#define VIRTIO_BLK_S_IO_TICKS 9
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313651930
+
+#define VIRTIO_BLK_S_TIME_IN_QUEUE 10
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313646835
+
+	u16 tag;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313646835
+
+	u64 val;
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1313646835
+
+} __attribute__((packed));
+\end_layout
+
+\end_inset
+
+
+\end_layout
+
+\end_deeper
+\begin_layout Description
+
+\change_inserted 2090695081 1313651968
+Tags
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652455
+
+\series bold
+VIRTIO_BLK_S_READ_IO 
+\series default
+Number of read I/Os processed.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652609
+
+\series bold
+VIRTIO_BLK_S_READ_MERGE
+\series default
+S Number of read I/Os merged with in-queue I/O.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652608
+
+\series bold
+VIRTIO_BLK_S_READ_SECTORS 
+\series default
+Number of sectors read.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652607
+
+\series bold
+VIRTIO_BLK_S_READ_TICKS 
+\series default
+Total wait time for read requests.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652606
+
+\series bold
+VIRTIO_BLK_S_WRITE_IO 
+\series default
+Number of write I/Os processed.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652605
+
+\series bold
+VIRTIO_BLK_S_WRITE_MERGES 
+\series default
+Number of write I/Os merged with in-queue I/O.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652604
+
+\series bold
+VIRTIO_BLK_S_WRITE_SECTORS 
+\series default
+Number of sectors written.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652604
+
+\series bold
+VIRTIO_BLK_S_WRITE_TICKS 
+\series default
+Total wait time for write requests.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652603
+
+\series bold
+VIRTIO_BLK_S_IN_FLIGHT 
+\series default
+Number of I/Os currently in flight.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652602
+
+\series bold
+VIRTIO_BLK_S_IO_TICKS 
+\series default
+Total time this block device has been active.
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1313652601
+
+\series bold
+VIRTIO_BLK_S_TIME_IN_QUEUE 
+\series default
+Total wait time for all requests.
 \end_layout
 
 \begin_layout Chapter*

-- 

Sasha.

