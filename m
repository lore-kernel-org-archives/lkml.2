Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab2CSIXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:23:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757840Ab2CSIXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:23:38 -0400
Date: Mon, 19 Mar 2012 10:23:44 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: qemu-devel@nongnu.org, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-spec: split virtio-net device status filed into
 ro and rw byte
Message-ID: <20120319082343.GD17673@redhat.com>
References: <20120316152026.6428.6983.stgit@jason-ThinkPad-T400>
 <20120318122252.GE29902@redhat.com>
 <4F66A364.2080600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F66A364.2080600@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:09:24AM +0800, Jason Wang wrote:
> On 03/18/2012 08:22 PM, Michael S. Tsirkin wrote:
> >On Fri, Mar 16, 2012 at 11:20:26PM +0800, Jason Wang wrote:
> >>This patch splits the device status field of virtio-net into ro and rw
> >>byte. This would simplify the implementation of both host and guest
> >>and make the layout more clean. As VIRTIO_NET_S_ANNOUNCE is a rw bit,
> >>it was moved to bit 8 (0x100).
> >>
> >>btw. looks like there's no implementation that depends on
> >>VIRTIO_NET_S_ANNOUNCE, so the move is safe.
> >>
> >>Signed-off-by: Jason Wang<jasowang@redhat.com>
> >Hmm, I know I proposed this myself, and I thought it will
> >prevent problems if we will add more rw bits,
> >but I missed the following race:
> >
> >host writes VIRTIO_NET_S_ANNOUNCE = 1, interrupt
> >
> >				guest reads VIRTIO_NET_S_ANNOUNCE = 1
> >
> >host writes VIRTIO_NET_S_SOME_NEW_FIELD = 1, interrupt
> >
> >				guest writes VIRTIO_NET_S_ANNOUNCE = 0
> >				VIRTIO_NET_S_SOME_NEW_FIELD is overwritten
> >
> >				guest reads VIRTIO_NET_S_SOME_NEW_FIELD = 0
> >
> >How about making the new bit write 1 to clear?
> >If we do, we can keep it where it is currently ...
> >
> 
> Didn't follow, do you mean to make VIRITO_NET_S_ANNOUNCE bit clear
> on read? Looks like this can prevent the race and keep what
> currently we have.

Clear on read is evil, it makes debugging harder
since you can't check the state without destroying it.
Write 1 to clear means writing 0 to a bit does not
change it, writing 1 clears it. This makes it possible
to flip individual bits in config space without
making Schrödinger's cat experiments.

> >
> >>---
> >>  virtio-0.9.4.lyx |   20 +++++++++++++++++++-
> >>  1 files changed, 19 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/virtio-0.9.4.lyx b/virtio-0.9.4.lyx
> >>index 6c7bab1..ef3951c 100644
> >>--- a/virtio-0.9.4.lyx
> >>+++ b/virtio-0.9.4.lyx
> >>@@ -58,6 +58,7 @@
> >>  \html_be_strict false
> >>  \author -608949062 "Rusty Russell,,,"
> >>  \author 1531152142 "pbonzini"
> >>+\author 2090695081 "Jason"
> >>  \end_header
> >>
> >>  \begin_body
> >>@@ -4012,8 +4013,19 @@ configuration
> >>  layout Two configuration fields are currently defined.
> >>   The mac address field always exists (though is only valid if VIRTIO_NET_F_MAC
> >>   is set), and the status field only exists if VIRTIO_NET_F_STATUS is set.
> >>+
> >>+\change_inserted 2090695081 1331907586
> >>+ The low byte of status field is read-only, guest write to this byte would
> >>+ be ignored.
> >>+ Currently only one bit is defined for this byte: VIRTIO_NET_S_LINK_UP.
> >>+ The high byte of status field is read-writable.
> >>+ Currently only one bit is defined for this byte: VIRTIO_NET_S_ANNOUNCE.
> >>+
> >>+\change_deleted 2090695081 1331907489
> >>   Two bits are currently defined for the status field: VIRTIO_NET_S_LINK_UP
> >>   and VIRTIO_NET_S_ANNOUNCE.
> >>+
> >>+\change_unchanged
> >>
> >>  \begin_inset listings
> >>  inline false
> >>@@ -4026,7 +4038,13 @@ status open
> >>
> >>  \begin_layout Plain Layout
> >>
> >>-#define VIRTIO_NET_S_ANNOUNCE	2
> >>+#define VIRTIO_NET_S_ANNOUNCE	
> >>+\change_inserted 2090695081 1331907493
> >>+0x100
> >>+\change_deleted 2090695081 1331907491
> >>+2
> >>+\change_unchanged
> >>+
> >>  \end_layout
> >>
> >>  \begin_layout Plain Layout
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >Please read the FAQ at  http://www.tux.org/lkml/
