Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab0G3SVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:21:40 -0400
Received: from kroah.org ([198.145.64.141]:58734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759926Ab0G3R41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:27 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:44 2010
Message-Id: <20100730175144.106631994@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [112/205] x86: Fix x2apic preenabled system with kexec
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit fd19dce7ac07973f700b0f13fb7f94b951414a4c upstream.

Found one x2apic system kexec loop test failed
when CONFIG_NMI_WATCHDOG=y (old) or CONFIG_LOCKUP_DETECTOR=y (current tip)

first kernel can kexec second kernel, but second kernel can not kexec third one.

it can be duplicated on another system with BIOS preenabled x2apic.
First kernel can not kexec second kernel.

It turns out, when kernel boot with pre-enabled x2apic, it will not execute
disable_local_APIC on shutdown path.

when init_apic_mappings() is called in setup_arch, it will skip setting of
apic_phys when x2apic_mode is set. ( x2apic_mode is much early check_x2apic())
Then later, disable_local_APIC() will bail out early because !apic_phys.

So check !x2apic_mode in x2apic_mode in disable_local_APIC with !apic_phys.

another solution could be updating init_apic_mappings() to set apic_phys even
for preenabled x2apic system. Actually even for x2apic system, that lapic
address is mapped already in early stage.

BTW: is there any x2apic preenabled system with apicid of boot cpu > 255?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4C3EB22B.3000701@kernel.org>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -920,7 +920,7 @@ void disable_local_APIC(void)
 	unsigned int value;
 
 	/* APIC hasn't been mapped yet */
-	if (!apic_phys)
+	if (!x2apic_mode && !apic_phys)
 		return;
 
 	clear_local_APIC();


