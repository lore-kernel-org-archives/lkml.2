Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab2CWDFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 23:05:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756612Ab2CWDFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 23:05:06 -0400
Subject: [RFC V2 PATCH] virtio-spec: ack the announce notification through
 ctrl_vq
To: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 23 Mar 2012 11:05:01 +0800
Message-ID: <20120323030501.6912.96218.stgit@jason-ThinkPad-T400>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During link announcement, driver needs a method to notify device that it has
received the notification and let it clear the VIRITO_NET_S_ANNOUNCE bit in the
status field. Doing this through a dedicated command looks suitable for all
platforms (especially for the ones who don't trap the status read or write) with
a ctrl vq and can solve the race between host and guest.

So this patch makes VIRTIO_NET_F_ANNOUNCE depends on VIRTIO_NET_F_CTRL_VQ and
introduces a dedicated command VIRTIO_NET_CTRL_ANNOUNCE_ACK to let device clear
the VIRTIO_NET_S_ANNOUNCE bit in the status field.

Changes from v1:
- Send the gratuitous packets or mark them as pending before send
VIRTIO_NET_CTRL_ANNOUNCE_ACK command.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 virtio-0.9.4.lyx |   76 +++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/virtio-0.9.4.lyx b/virtio-0.9.4.lyx
index 9d30977..f376cb8 100644
--- a/virtio-0.9.4.lyx
+++ b/virtio-0.9.4.lyx
@@ -4013,8 +4013,12 @@ configuration
 layout Two configuration fields are currently defined.
  The mac address field always exists (though is only valid if VIRTIO_NET_F_MAC
  is set), and the status field only exists if VIRTIO_NET_F_STATUS is set.
- Two bits are currently defined for the status field: VIRTIO_NET_S_LINK_UP
- and VIRTIO_NET_S_ANNOUNCE.
+ Two 
+\change_inserted 2090695081 1332406434
+read-only 
+\change_unchanged
+bits are currently defined for the status field: VIRTIO_NET_S_LINK_UP and
+ VIRTIO_NET_S_ANNOUNCE.
  
 \begin_inset listings
 inline false
@@ -4902,18 +4906,58 @@ Gratuitous Packet Sending
 \end_layout
 
 \begin_layout Standard
-If the driver negotiates the VIRTIO_NET_F_GUEST_ANNOUNCE, it can ask the
- guest to send gratuitous packets; this is usually done after the guest
- has been physically migrated, and needs to announce its presence on the
- new network links.
+If the driver negotiates the VIRTIO_NET_F_GUEST_ANNOUNCE
+\change_inserted 2090695081 1332407810
+ (depends on VIRTIO_NET_F_CTRL_VQ)
+\change_unchanged
+, it can ask the guest to send gratuitous packets; this is usually done
+ after the guest has been physically migrated, and needs to announce its
+ presence on the new network links.
  (As hypervisor does not have the knowledge of guest network configuration
  (eg.
  tagged vlan) it is simplest to prod the guest in this way).
+\change_inserted 2090695081 1332405026
+
+\end_layout
+
+\begin_layout Standard
+
+\change_inserted 2090695081 1332405026
+\begin_inset listings
+inline false
+status open
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1332405658
+
+#define VIRTIO_NET_CTRL_ANNOUNCE       3
+\end_layout
+
+\begin_layout Plain Layout
+
+\change_inserted 2090695081 1332407582
+
+ #define VIRTIO_NET_CTRL_ANNOUNCE_ACK             0
+\end_layout
+
+\end_inset
+
+
+\change_unchanged
+
 \end_layout
 
 \begin_layout Standard
 The Guest needs to check VIRTIO_NET_S_ANNOUNCE bit in status field when
  it notices the changes of device configuration.
+
+\change_inserted 2090695081 1332407079
+ The command VIRTIO_NET_CTRL_ANNOUNCE_ACK is used to indicate that driver
+ has recevied the notification and device would clear the VIRTIO_NET_S_ANNOUNCE
+ bit in the status filed after it received this command.
+\change_unchanged
+
 \end_layout
 
 \begin_layout Standard
@@ -4921,11 +4965,29 @@ Processing this notification involves:
 \end_layout
 
 \begin_layout Enumerate
+
+\change_inserted 2090695081 1332471639
+Sending the gratuitous packets or marking there are pending gratuitous packets
+ to be sent and letting deferred routine to send them.
+\end_layout
+
+\begin_layout Enumerate
+
+\change_inserted 2090695081 1332405963
+Sending VIRTIO_NET_CTRL_ANNOUNCE_ACK command through control vq.
+ 
+\change_deleted 2090695081 1332405924
 Clearing VIRTIO_NET_S_ANNOUNCE bit in the status field.
+\change_unchanged
+
 \end_layout
 
 \begin_layout Enumerate
-Sending the gratuitous packets.
+
+\change_deleted 2090695081 1332471331
+Sending the gratuitous packets
+\change_unchanged
+.
  
 \end_layout
 

