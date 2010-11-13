Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731Ab0KMJyi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 04:54:38 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57534 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab0KMJye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 04:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YkOmO+XDA01po+2vgxD7kSRCd6ozBxJ9W3hNEe860cwMR1cIspd+CRF2MSFEQLyDMz
         FacDH533EuKgNtptMj/0QcZnEpJsKfEMLM3OD9q1aR9I6Mg3cYnoq3mGAprsOwbpMbAt
         Kapdi7MkNRVtK2BsSYN/ircONcJTouIYOzOgk=
Date: Sat, 13 Nov 2010 17:57:32 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 01/20] x86/ticketlock: clean up types and accessors
Message-ID: <20101113095732.GF3837@hack>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com> <742be99eb6d64784dbc3e446d22df78b7a55fc0c.1288794124.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <742be99eb6d64784dbc3e446d22df78b7a55fc0c.1288794124.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 03, 2010 at 10:59:42AM -0400, Jeremy Fitzhardinge wrote:
...
> static __always_inline void __ticket_spin_lock(arch_spinlock_t *lock)
> {
>-	int inc = 0x00010000;
>-	int tmp;
>+	unsigned inc = 1 << TICKET_SHIFT;
>+	unsigned tmp;

Please don't use old implicit-int.

> 
>-	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
>+	return ((tmp.tail - tmp.head) & TICKET_MASK) > 1;


There is a type promotion here.


> }
> 
> #ifndef CONFIG_PARAVIRT_SPINLOCKS
>diff --git a/arch/x86/include/asm/spinlock_types.h b/arch/x86/include/asm/spinlock_types.h
>index dcb48b2..4582640 100644
>--- a/arch/x86/include/asm/spinlock_types.h
>+++ b/arch/x86/include/asm/spinlock_types.h
>@@ -5,11 +5,27 @@
> # error "please don't include this file directly"
> #endif
> 
>+#include <linux/types.h>
>+
>+#if (CONFIG_NR_CPUS < 256)
>+typedef u8  __ticket_t;
>+#else
>+typedef u16 __ticket_t;
>+#endif
>+
>+#define TICKET_SHIFT	(sizeof(__ticket_t) * 8)
>+#define TICKET_MASK	((1 << TICKET_SHIFT) - 1)


So here you may need to cast the result to __ticket_t.


Thanks.
