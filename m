Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1HRDEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 23:04:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55082 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab1HRDEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 23:04:54 -0400
Message-ID: <4E4C81CE.8030508@cn.fujitsu.com>
Date: Thu, 18 Aug 2011 11:06:54 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 1/2] kvm tools: fix repeated io emulation
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 11:03:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-08-18 11:03:42,
	Serialize complete at 2011-08-18 11:03:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kvm emulates repeation io read instruction, it can exit to user-space with
'count' > 1, we need to emulate io access for many times

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 tools/kvm/ioport.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/kvm/ioport.c b/tools/kvm/ioport.c
index 2d69ae4..6b0bd30 100644
--- a/tools/kvm/ioport.c
+++ b/tools/kvm/ioport.c
@@ -129,6 +129,7 @@ bool kvm__emulate_io(struct kvm *kvm, u16 port, void *data, int direction, int s
 	struct ioport_operations *ops;
 	bool ret = false;
 	struct ioport *entry;
+	void *ptr = data;
 
 	br_read_lock();
 	entry = ioport_search(&ioport_tree, port);
@@ -137,12 +138,16 @@ bool kvm__emulate_io(struct kvm *kvm, u16 port, void *data, int direction, int s
 
 	ops	= entry->ops;
 
-	if (direction == KVM_EXIT_IO_IN) {
-		if (ops->io_in)
-			ret = ops->io_in(entry, kvm, port, data, size, count);
-	} else {
-		if (ops->io_out)
-			ret = ops->io_out(entry, kvm, port, data, size, count);
+	while (count--) {
+		if (direction == KVM_EXIT_IO_IN) {
+			if (ops->io_in)
+				ret = ops->io_in(entry, kvm, port, ptr, size, count);
+		} else {
+			if (ops->io_out)
+				ret = ops->io_out(entry, kvm, port, ptr, size, count);
+		}
+
+		ptr += size;
 	}
 
 	br_read_unlock();
-- 
1.7.5.4
