Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab0JEHyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:54:05 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20111 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab0JEHyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:54:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ymEFuIi2jpFWuK2ShLIh9xe7twwm3rQ2PC2Y5i25WpQ/GWTdFIQUgyLmKu7xZ7kYl1
         IlcjNxRy3iC3qJcjeJ+Q==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 3/3] access_error API cleanup
Date: Tue,  5 Oct 2010 00:53:35 -0700
Message-Id: <1286265215-9025-4-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286265215-9025-1-git-send-email-walken@google.com>
References: <1286265215-9025-1-git-send-email-walken@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

access_error() already takes error_code as an argument, so there is
no need for an additional write flag.

Signed-off-by: Michel Lespinasse <walken@google.com>
---
 arch/x86/mm/fault.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index b355b92..844d46f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -915,9 +915,9 @@ spurious_fault(unsigned long error_code, unsigned long address)
 int show_unhandled_signals = 1;
 
 static inline int
-access_error(unsigned long error_code, int write, struct vm_area_struct *vma)
+access_error(unsigned long error_code, struct vm_area_struct *vma)
 {
-	if (write) {
+	if (error_code & PF_WRITE) {
 		/* write, present and write, not present: */
 		if (unlikely(!(vma->vm_flags & VM_WRITE)))
 			return 1;
@@ -1110,7 +1110,7 @@ retry:
 	 * we can handle it..
 	 */
 good_area:
-	if (unlikely(access_error(error_code, write, vma))) {
+	if (unlikely(access_error(error_code, vma))) {
 		bad_area_access_error(regs, error_code, address);
 		return;
 	}
-- 
1.7.1
