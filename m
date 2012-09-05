Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412Ab2IEPN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:13:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33309 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2IEPN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:13:56 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: target-devel@vger.kernel.org
Subject: [RFC PATCH 0/3] target: try satisfying memory requests with higher-order allocations
Date: Wed,  5 Sep 2012 17:13:42 +0200
Message-Id: <1346858025-10459-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

while testing PSCSI I noticed that even requests for a smallish amount
of data (approximately 700 KB) failed due to an excessive number of
segments in the request.  In fact, using alloc_page resulted in a
completely fragmented request, with no merging of consecutive pages
at all.

This patch series fixes this problem by using higher-order allocations
to build the data scatterlist.  The problem is that iscsi assumes that the
scatterlist consists of single pages, which is not true anymore.  So
patch 2 has to introduce some relatively complicated changes to
iscsi_map_iovec and iscsi_unmap_iovec.

While doing this, I noticed something strange in iscsit_do_crypto_hash_sg.
Patch 1 adds a warning about it.

The approach may be completely wrong and it needs more testing anyway.
Please review!

Paolo

Paolo Bonzini (3):
  tcm_iscsi: warn on incorrect precondition for iscsit_do_crypto_hash_sg
  tcm_iscsi: support multiple sizes in the scatterlist
  target: try satisfying memory requests with contiguous blocks

 drivers/target/iscsi/iscsi_target.c      |  106 +++++++++++++++++++++++++-----
 drivers/target/iscsi/iscsi_target_core.h |    2 +-
 drivers/target/target_core_transport.c   |   58 ++++++++++++++---
 3 files changed, 138 insertions(+), 28 deletions(-)

