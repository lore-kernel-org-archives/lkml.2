Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab1JMSVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 14:21:53 -0400
Received: from claw.goop.org ([74.207.240.146]:49954 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553Ab1JMSVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 14:21:51 -0400
Message-ID: <4E97188A.6040400@goop.org>
Date: Thu, 13 Oct 2011 09:57:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC V4 09/10] x86/jump_label: use GENERIC_NOP5_ATOMIC
 instead of jmp5 +0
References: <cover.1318464169.git.jeremy.fitzhardinge@citrix.com> <34ede5db1571d541a5c3fc49923bb353a37dd431.1318464413.git.jeremy.fitzhardinge@citrix.com> <4E97067A.2070305@zytor.com>
In-Reply-To: <4E97067A.2070305@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 08:40 AM, H. Peter Anvin wrote:
> On 10/12/2011 05:08 PM, Jeremy Fitzhardinge wrote:
>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>
>> GENERIC_NOP5_ATOMIC should make a better nop.
>>
> On 32 bits, yes.  On 64 bits you should use P6_NOP5_ATOMIC.

Something like this?

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Thu, 13 Oct 2011 09:55:25 -0700
Subject: [PATCH] x86/nop: we can use P6 as generic NOP on 64-bit

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
index 405b403..f9fead9 100644
--- a/arch/x86/include/asm/nops.h
+++ b/arch/x86/include/asm/nops.h
@@ -19,15 +19,15 @@
    6: leal 0x00000000(%esi),%esi
    7: leal 0x00000000(,%esi,1),%esi
 */
-#define GENERIC_NOP1 0x90
-#define GENERIC_NOP2 0x89,0xf6
-#define GENERIC_NOP3 0x8d,0x76,0x00
-#define GENERIC_NOP4 0x8d,0x74,0x26,0x00
-#define GENERIC_NOP5 GENERIC_NOP1,GENERIC_NOP4
-#define GENERIC_NOP6 0x8d,0xb6,0x00,0x00,0x00,0x00
-#define GENERIC_NOP7 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00
-#define GENERIC_NOP8 GENERIC_NOP1,GENERIC_NOP7
-#define GENERIC_NOP5_ATOMIC NOP_DS_PREFIX,GENERIC_NOP4
+#define GAS_NOP1 0x90
+#define GAS_NOP2 0x89,0xf6
+#define GAS_NOP3 0x8d,0x76,0x00
+#define GAS_NOP4 0x8d,0x74,0x26,0x00
+#define GAS_NOP5 GENERIC_NOP1,GENERIC_NOP4
+#define GAS_NOP6 0x8d,0xb6,0x00,0x00,0x00,0x00
+#define GAS_NOP7 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00
+#define GAS_NOP8 GENERIC_NOP1,GENERIC_NOP7
+#define GAS_NOP5_ATOMIC NOP_DS_PREFIX,GENERIC_NOP4
 
 /* Opteron 64bit nops
    1: nop
@@ -87,6 +87,28 @@
 #define P6_NOP8	0x0f,0x1f,0x84,0x00,0,0,0,0
 #define P6_NOP5_ATOMIC P6_NOP5
 
+#ifdef CONFIG_X86_32
+#define GENERIC_NOP1		GAS_NOP1
+#define GENERIC_NOP2		GAS_NOP2
+#define GENERIC_NOP3		GAS_NOP3
+#define GENERIC_NOP4		GAS_NOP4
+#define GENERIC_NOP5		GAS_NOP5
+#define GENERIC_NOP6		GAS_NOP6
+#define GENERIC_NOP7		GAS_NOP7
+#define GENERIC_NOP8		GAS_NOP8
+#define GENERIC_NOP5_ATOMIC	GAS_NOP5_ATOMIC
+#else
+#define GENERIC_NOP1		P6_NOP1
+#define GENERIC_NOP2		P6_NOP2
+#define GENERIC_NOP3		P6_NOP3
+#define GENERIC_NOP4		P6_NOP4
+#define GENERIC_NOP5		P6_NOP5
+#define GENERIC_NOP6		P6_NOP6
+#define GENERIC_NOP7		P6_NOP7
+#define GENERIC_NOP8		P6_NOP8
+#define GENERIC_NOP5_ATOMIC	P6_NOP5_ATOMIC
+#endif
+
 #define _ASM_MK_NOP(x) ".byte " __stringify(x) "\n"
 
 #if defined(CONFIG_MK7)


