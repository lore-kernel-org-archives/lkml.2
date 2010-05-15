Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab0EOCoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 22:44:17 -0400
Received: from smtp-out.google.com ([74.125.121.35]:54539 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0EOCoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 22:44:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:message-id:user-agent:
	mime-version:content-type:x-system-of-record;
	b=i7l0eBfGgKdMssb0oRgR7ZAIKYbuUGSJid9AoS0O5UUNUyYNon9YZnaEbDZYBMqcn
	EW9X3GCGSBFii982GdFUQ==
Date: Fri, 14 May 2010 19:44:10 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] profile: fix stats and data leakage
Message-ID: <alpine.DEB.1.00.1005141942280.19908@tigran.mtv.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the kernel is large or the profiling step small, /proc/profile
leaks data and readprofile shows silly stats, until readprofile -r
has reset the buffer: clear the prof_buffer when it is vmalloc()ed.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@kernel.org
---

 kernel/profile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- 2.6.34-rc7/kernel/profile.c	2009-12-02 19:51:21.000000000 -0800
+++ linux/kernel/profile.c	2010-05-13 14:57:37.000000000 -0700
@@ -127,8 +127,10 @@ int __ref profile_init(void)
 		return 0;
 
 	prof_buffer = vmalloc(buffer_bytes);
-	if (prof_buffer)
+	if (prof_buffer) {
+		memset(prof_buffer, 0, buffer_bytes);
 		return 0;
+	}
 
 	free_cpumask_var(prof_cpu_mask);
 	return -ENOMEM;
