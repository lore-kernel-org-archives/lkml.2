Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab0EDNEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:04:46 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57670 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0EDNEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:04:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=RrKBMK4Q5Kcx21mtvvlYq8CQ09Nk5EMMAyB4JwH9OPRGYlXfpZu0JNdh0YWLvzMVE0
         0O14uvpHPERpVUkEb3CK2VSiNqdxsT6XgRrbmzf0AJygqBIEDDrXKnweU02tYSOK1fYY
         6xrCusUdYBgvN+OUNzemMU99zC6xMMYhakOP0=
Date: Tue, 4 May 2010 22:04:18 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 7/12 not tested yet] PPC: introduce __set_bit() like
 function for bitmaps in user space
Message-Id: <20100504220418.083929bc.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the work of KVM's dirty page logging optimization, we encountered
the need of manipulating bitmaps in user space efficiantly. To achive this,
we introduce a uaccess function for setting a bit in user space following
Avi's suggestion.

  KVM is now using dirty bitmaps for live-migration and VGA. Although we need
  to update them from kernel side, copying them every time for updating the
  dirty log is a big bottleneck. Especially, we tested that zero-copy bitmap
  manipulation improves responses of GUI manipulations a lot.

We also found one similar need in drivers/vhost/vhost.c in which the author
implemented set_bit_to_user() locally using inefficient functions: see TODO
at the top of that.

Probably, this kind of need would be common for virtualization area.

So we introduce a function set_bit_user_non_atomic().

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
CC: Alexander Graf <agraf@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/uaccess.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 3a01ce8..f878326 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -321,6 +321,25 @@ do {								\
 	__gu_err;						\
 })
 
+static inline int set_bit_user_non_atomic(int nr, void __user *addr)
+{
+	u8 __user *p;
+	u8 val;
+
+	p = (u8 __user *)((unsigned long)addr + nr / BITS_PER_BYTE);
+	if (!access_ok(VERIFY_WRITE, p, 1))
+		return -EFAULT;
+
+	if (__get_user(val, p))
+		return -EFAULT;
+
+	val |= 1U << (nr % BITS_PER_BYTE);
+	if (__put_user(val, p))
+		return -EFAULT;
+
+	return 0;
+}
+
 
 /* more complex routines */
 
-- 
1.7.0.4

