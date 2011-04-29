Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706Ab1D2TD4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:03:56 -0400
Received: from kroah.org ([198.145.64.141]:50332 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933220Ab1D2S6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:34 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:55 2011
Message-Id: <20110429185655.774296728@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [33/55] [S390] kvm-390: Let kernel exit SIE instruction on work
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carsten Otte <cotte@de.ibm.com>

commit 9ff4cfb3fcfd48b49fdd9be7381b3be340853aa4 upstream.

From: Christian Borntraeger <borntraeger@de.ibm.com>

This patch fixes the sie exit on interrupts. The low level
interrupt handler returns to the PSW address in pt_regs and not
to the PSW address in the lowcore.
Without this fix a cpu bound guest might never leave guest state
since the host interrupt handler would blindly return to the
SIE instruction, even on need_resched and friends.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kvm/sie64a.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kvm/sie64a.S
+++ b/arch/s390/kvm/sie64a.S
@@ -48,10 +48,10 @@ sie_irq_handler:
 	tm	__TI_flags+7(%r2),_TIF_EXIT_SIE
 	jz	0f
 	larl	%r2,sie_exit			# work pending, leave sie
-	stg	%r2,__LC_RETURN_PSW+8
+	stg	%r2,SPI_PSW+8(0,%r15)
 	br	%r14
 0:	larl	%r2,sie_reenter			# re-enter with guest id
-	stg	%r2,__LC_RETURN_PSW+8
+	stg	%r2,SPI_PSW+8(0,%r15)
 1:	br	%r14
 
 /*


