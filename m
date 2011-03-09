Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928Ab1CIWRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 17:17:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab1CIWRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 17:17:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Qt6DqWlgDIhDiMPLGdNnQrrjl4TwFFgr1Q5xsqFUUkEJ1aQIXBkYdelMRe636HL3fX
         gskPC96VJJEiy9aHCM2Q==
Date: Wed, 9 Mar 2011 14:17:18 -0800
From: Michel Lespinasse <walken@google.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Darren Hart <darren@dvhart.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
Message-ID: <20110309221718.GA28592@google.com>
References: <20110307021127.GB31188@google.com>
 <alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
 <20110309112550.GA3050@google.com>
 <20110309160839.283e241a@mschwide.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110309160839.283e241a@mschwide.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 04:08:39PM +0100, Martin Schwidefsky wrote:
> On Wed, 9 Mar 2011 03:25:50 -0800
> Michel Lespinasse <walken@google.com> wrote:
> > All right. Attaching updated version of the diff. I also fixed the s390
> > issue reported by Martin Schwidefsky.
> 
> The inline assmeblies look good now but I get this compile error on s390:
> 
>   CC      arch/s390/lib/uaccess_pt.o
> arch/s390/lib/uaccess_pt.c:373: error: conflicting types for 'futex_atomic_cmpxchg_pt'
> arch/s390/lib/uaccess.h:21: note: previous declaration of 'futex_atomic_cmpxchg_pt' was here
> arch/s390/lib/uaccess_pt.c:403: warning: initialization from incompatible pointer type
> make[1]: *** [arch/s390/lib/uaccess_pt.o] Error 1

My bad. Somehow I made the change in arch/s390/lib/uaccess_std.c but missed
it in arch/s390/lib/uaccess_pt.c ... Attached patch below goes on top of
the previous changes - Thomas, if you have picked the previous patch,
please squash this one on top of it :)

Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/arch/s390/lib/uaccess_pt.c b/arch/s390/lib/uaccess_pt.c
index afc716a..7483383 100644
--- a/arch/s390/lib/uaccess_pt.c
+++ b/arch/s390/lib/uaccess_pt.c
@@ -370,8 +370,8 @@ static int __futex_atomic_cmpxchg_pt(u32 *uval, u32 __user *uaddr,
 	return ret;
 }
 
-int futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
-			    int oldval, int newval)
+int futex_atomic_cmpxchg_pt(u32 *uval, u32 __user *uaddr,
+			    u32 oldval, u32 newval)
 {
 	int ret;
 

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
