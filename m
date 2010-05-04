Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0EDNDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:03:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58456 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab0EDNDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:03:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=VB45w/Jr9C3KrrrjxD0r99qIeiec0KezJU1Xy90bJu72A+ytzhPXqbeyMpNTjnfoVS
         +RZY+Lux6yTM2y1QYDQK9s5FJ8MJxXLLo9o4YzYoPTlIyHa7oZNQqY0H145soUUyqHie
         BsC+iB/zYZ1eGUjbuE/SEl/8H6fuTVWmv6NFk=
Date: Tue, 4 May 2010 22:03:33 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 6/12 not tested yet] PPC: introduce copy_in_user() for
 32-bit
Message-Id: <20100504220333.61e44128.takuya.yoshikawa@gmail.com>
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
the need of copy_in_user() for 32-bit ppc and x86: these will be used for
manipulating dirty bitmaps in user space.

So we implement copy_in_user() for 32-bit with __copy_tofrom_user().

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
CC: Alexander Graf <agraf@suse.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/include/asm/uaccess.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index bd0fb84..3a01ce8 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -359,6 +359,23 @@ static inline unsigned long copy_to_user(void __user *to,
 	return n;
 }
 
+static inline unsigned long copy_in_user(void __user *to,
+		const void __user *from, unsigned long n)
+{
+	unsigned long over;
+
+	if (likely(access_ok(VERIFY_READ, from, n) &&
+	    access_ok(VERIFY_WRITE, to, n)))
+		return __copy_tofrom_user(to, from, n);
+	if (((unsigned long)from < TASK_SIZE) ||
+	    ((unsigned long)to < TASK_SIZE)) {
+		over = max((unsigned long)from, (unsigned long)to)
+			+ n - TASK_SIZE;
+		return __copy_tofrom_user(to, from, n - over) + over;
+	}
+	return n;
+}
+
 #else /* __powerpc64__ */
 
 #define __copy_in_user(to, from, size) \
-- 
1.7.0.4

