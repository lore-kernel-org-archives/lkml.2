Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1H0O44 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:56:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46584 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753202Ab1H0O4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:56:53 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:04:20 2011
Message-Id: <20110826220420.463702970@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 15:03:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [16/20] x86-32, vdso: On system call restart after SYSENTER, use int $0x80
In-Reply-To: <20110826220431.GA15382@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 7ca0758cdb7c241cb4e0490a8d95f0eb5b861daf upstream.

When we enter a 32-bit system call via SYSENTER or SYSCALL, we shuffle
the arguments to match the int $0x80 calling convention.  This was
probably a design mistake, but it's what it is now.  This causes
errors if the system call as to be restarted.

For SYSENTER, we have to invoke the instruction from the vdso as the
return address is hardcoded.  Accordingly, we can simply replace the
jump in the vdso with an int $0x80 instruction and use the slower
entry point for a post-restart.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Link: http://lkml.kernel.org/r/CA%2B55aFztZ=r5wa0x26KJQxvZOaQq8s2v3u50wCyJcA-Sc4g8gQ@mail.gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/vdso/vdso32/sysenter.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/vdso/vdso32/sysenter.S
+++ b/arch/x86/vdso/vdso32/sysenter.S
@@ -43,7 +43,7 @@ __kernel_vsyscall:
 	.space 7,0x90
 
 	/* 14: System call restart point is here! (SYSENTER_RETURN-2) */
-	jmp .Lenter_kernel
+	int $0x80
 	/* 16: System call normal return point is here! */
 VDSO32_SYSENTER_RETURN:	/* Symbol used by sysenter.c via vdso32-syms.h */
 	pop %ebp


