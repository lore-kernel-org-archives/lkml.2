Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab0DLB5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 21:57:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38605 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab0DLB5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 21:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=cC6XViJwY9FRf7UZ+hRZcrU684Xn3OxX+DIoDAqIP0fM4+ykLe+Tp1PlHOp3ve39kt
         X3DKSzhcEIPN/sMTE9oFQlRXrxKGaGXHWCVJFyveP+YF6WZ540hZR0FJx0mJNNzt6ZDh
         KSjUQ6g1MKOflJSmiPUzMy/QvHpffTEsfoBbM=
Date: Mon, 12 Apr 2010 09:57:14 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: [PATCH] KVM: Enhance the coalesced_mmio_write() parameter to avoid stack buffer overflow
Message-ID: <20100412015714.GA2815@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

coalesced_mmio_write() is not check the len value, if len is negative,
memcpy(ring->coalesced_mmio[ring->last].data, val, len); will cause
stack buffer overflow.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 virt/kvm/coalesced_mmio.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index c0dcfb7..eb4601c 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -61,6 +61,10 @@ static int coalesced_mmio_write(struct kvm_io_device *this,
 {
 	struct kvm_coalesced_mmio_dev *dev = to_mmio(this);
 	struct kvm_coalesced_mmio_ring *ring = dev->kvm->coalesced_mmio_ring;
+
+	if (len < 0)
+		return -EOPNOTSUPP;
+
 	if (!coalesced_mmio_in_range(dev, addr, len))
 		return -EOPNOTSUPP;
 
-- 
1.6.5.3

