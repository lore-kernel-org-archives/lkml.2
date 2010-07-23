Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab0GWF4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 01:56:19 -0400
Received: from claw.goop.org ([74.207.240.146]:37954 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757812Ab0GWF4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 01:56:15 -0400
Message-ID: <4C492EFD.1090007@goop.org>
Date: Thu, 22 Jul 2010 22:56:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: linux-next: build failure after merge of the xen tree
References: <20100723140107.2883b2d3.sfr@canb.auug.org.au>
In-Reply-To: <20100723140107.2883b2d3.sfr@canb.auug.org.au>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2010 09:01 PM, Stephen Rothwell wrote:
> After merging the xen tree, today's linux-next build (86_64 allmodconfig)
> failed like this:
>
> arch/x86/xen/enlighten.c:71: error: __pcpu_scope_xen_vcpu causes a section type conflict
> arch/x86/xen/enlighten.c:72: error: __pcpu_scope_xen_vcpu_info causes a section type conflict
> arch/x86/xen/enlighten.c:71: error: __pcpu_unique_xen_vcpu causes a section type conflict
> arch/x86/xen/enlighten.c:72: error: __pcpu_unique_xen_vcpu_info causes a section type conflict
> arch/x86/xen/enlighten.c:558: error: __pcpu_unique_idt_desc causes a section type conflict
> arch/x86/xen/enlighten.c:760: error: __pcpu_unique_xen_cr0_value causes a section type conflict
>
> Not sure what has caused this.  I have dropped the xen tree for today.
>
> gcc version 4.4.4 binutils version 2.20.1.
>   

I can reproduce this.

I bisected it down to change bee6ab53e652a414af20392899879b58cd80d033.

Ah!   That change uses RESERVE_BRK(), which creates a dummy function and
puts it into the .discard section.  Presumably that makes gcc think that
.discard is for code, and so when the percpu stuff starts putting data
into .discard, gcc (now) complains.  If we add more .discard.* sections
then everyone is happy:

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 86b1506..ef292c7 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -82,7 +82,7 @@ void *extend_brk(size_t size, size_t align);
  * executable.)
  */
 #define RESERVE_BRK(name,sz)						\
-	static void __section(.discard) __used				\
+	static void __section(.discard.text) __used			\
 	__brk_reservation_fn_##name##__(void) {				\
 		asm volatile (						\
 			".pushsection .brk_reservation,\"aw\",@nobits;" \
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..ae6b88e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -643,6 +643,7 @@
 	EXIT_DATA							\
 	EXIT_CALL							\
 	*(.discard)							\
+	*(.discard.*)							\
 	}
 
 /**

I'll write up a proper patch.


Thanks,
    J
