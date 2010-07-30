Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759031Ab0G3RVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:21:04 -0400
Received: from kroah.org ([198.145.64.141]:52349 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758880Ab0G3RUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:20:35 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:14 2010
Message-Id: <20100730171514.186002717@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:16:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tony Luck <tony.luck@intel.com>
Subject: [161/165] [IA64] Fix spinaphore down_spin()
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tony Luck <tony.luck@intel.com>

commit b70f4e85bfc4d7000036355b714a92d5c574f1be upstream.

Typo in down_spin() meant it only read the low 32 bits of the
"serve" value, instead of the full 64 bits. This results in the
system hanging when the values in ticket/serve get larger than
32-bits. A big enough system running the right test can hit this
in a just a few hours.

Broken since 883a3acf5b0d4782ac35981227a0d094e8b44850
    [IA64] Re-implement spinaphores using ticket lock concepts

Reported via IRC by Bjorn Helgaas

Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/mm/tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/ia64/mm/tlb.c
+++ b/arch/ia64/mm/tlb.c
@@ -120,7 +120,7 @@ static inline void down_spin(struct spin
 	ia64_invala();
 
 	for (;;) {
-		asm volatile ("ld4.c.nc %0=[%1]" : "=r"(serve) : "r"(&ss->serve) : "memory");
+		asm volatile ("ld8.c.nc %0=[%1]" : "=r"(serve) : "r"(&ss->serve) : "memory");
 		if (time_before(t, serve))
 			return;
 		cpu_relax();


