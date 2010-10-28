Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab0J1OMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 10:12:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63726 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056Ab0J1OMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 10:12:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH v2] preempt: fix kernel build with !CONFIG_BKL
Date: Thu, 28 Oct 2010 16:12:33 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Brian Gerst <brgerst@gmail.com>, David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, x86@kernel.org
References: <20101028095910.GA15970@shutemov.name> <201010281320.44765.arnd@arndb.de> <20101028134658.GA17769@shutemov.name>
In-Reply-To: <20101028134658.GA17769@shutemov.name>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201010281612.33732.arnd@arndb.de>
X-Provags-ID: V02:K0:FkUcEuAVYMCbESdmrF6HhUtbqo+f+AkyUxzR+JtEkbb
 +qmnYk2iYtWeTLK7SKAoJcs8dErKAcLTbLm80pNE/ck5jo8Wh9
 C+NAXxG8ZHbJ5b4kD+SEYFIXDIyQazwOMp6eZUgcb3uDGvlE9D
 FzD9JZJuGlUhqtfG16vaJyv6yzHG3QoFCuQKAeNYBnOXkpd0fP
 4tlLUbpxjVqCgC7UcKL1g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The preempt count logic tries to take the BKL into account, which breaks
when CONFIG_BKL is not set.

Use the same preempt_count offset that we use without CONFIG_PREEMPT
when CONFIG_BKL is disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: Kirill Shutemov <kirill@shutemov.name>
---
> On Thursday 28 October 2010, Kirill A. Shutemov wrote:
> On Thu, Oct 28, 2010 at 01:20:44PM +0200, Arnd Bergmann wrote:
> > The preempt count logic tries to take the BKL into account, which breaks
> > when CONFIG_BKL is not set.
> > 
> > Use the same preempt_count offset that we use without CONFIG_PREEMPT
> > when CONFIG_BKL is disabled.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> Remove quotes, please.

That would make it an invalid email address because of the dot. I left out
the middle initial now, if that's better.

> I've got a lot of __schedule_bug. Log attached.

Ok. I really don't understand the preempt code all that well, let's
hope that this one is right.

Thanks for your patience and for your testing!

	Arnd

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 8a389b6..41cb31f 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -96,11 +96,15 @@
  */
 #define in_nmi()	(preempt_count() & NMI_MASK)
 
-#if defined(CONFIG_PREEMPT)
+#if defined(CONFIG_PREEMPT) && defined(CONFIG_BKL)
 # define PREEMPT_INATOMIC_BASE kernel_locked()
-# define PREEMPT_CHECK_OFFSET 1
 #else
 # define PREEMPT_INATOMIC_BASE 0
+#endif
+
+#if defined(CONFIG_PREEMPT)
+# define PREEMPT_CHECK_OFFSET 1
+#else
 # define PREEMPT_CHECK_OFFSET 0
 #endif
 
