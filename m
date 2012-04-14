Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2DNSMm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:12:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:36946 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab2DNSMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:12:40 -0400
Message-ID: <1334427139.2528.110.camel@twins>
Subject: Re: sched: WARNING: at include/linux/cpumask.h:108
 select_fallback_rq+0x241/0x280()
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, mingo@kernel.org,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>, vapier@gentoo.org,
        rusty@rustcorp.com.au
Date: Sat, 14 Apr 2012 20:12:19 +0200
In-Reply-To: <CA+1xoqe6UL36=F2mg8cYJsyW9_kxjmdX-H=khdKmbhg+mEpbmw@mail.gmail.com>
References: <CA+1xoqcf6qJOouKXGEHsjWSBJdA7qtMnuVopq+hoHS+TX8fvSg@mail.gmail.com>
	 <CA+1xoqcJAwgTgQG=nZPsH_SLkPFkGt2rUiVWGn5SO5JOAC1RAA@mail.gmail.com>
	 <4F75BED4.9050005@linux.vnet.ibm.com> <1333118719.2960.27.camel@laptop>
	 <4F76B7B9.5080709@linux.vnet.ibm.com> <1334395065.2528.43.camel@twins>
	 <CA+1xoqe6UL36=F2mg8cYJsyW9_kxjmdX-H=khdKmbhg+mEpbmw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-14 at 13:40 +0200, Sasha Levin wrote:
> On Sat, Apr 14, 2012 at 11:17 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Sat, 2012-03-31 at 13:22 +0530, Srivatsa S. Bhat wrote:
> >>
> >> One of the perils of using macros instead of true function calls :-(
> >>
> > You can do type checking in macros too, its not pretty, but there's
> > several such things already, see min()/max() for example.
> 
> Would it make sense to somehow standardize type checking in kernel
> macros? Possibly a set of wrappers that would make type checking easy
> to get into new and existing macros?


I had a quick go with the below and that doesn't quite work for no
obvious reasons as of yet.. Also, that call out to cpumask_next() should
already do type validation for us, so still no clue why my earlier code
compiled at all.

---
 include/linux/cpumask.h |    1 +
 include/linux/kernel.h  |   10 ++++++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index a2c819d..aec8355 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -201,6 +201,7 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
  * After the loop, cpu is >= nr_cpu_ids.
  */
 #define for_each_cpu(cpu, mask)				\
+	match_type(const struct cpumask *, (mask));	\
 	for ((cpu) = -1;				\
 		(cpu) = cpumask_next((cpu), (mask)),	\
 		(cpu) < nr_cpu_ids;)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 645231c..bcb7da3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -549,6 +549,16 @@ ftrace_vprintk(const char *fmt, va_list ap)
 static inline void ftrace_dump(enum ftrace_dump_mode oops_dump_mode) { }
 #endif /* CONFIG_TRACING */
 
+#define match_type_type(t1, t2)			\
+do {						\
+	t1 uninitialized_var(____t1);		\
+	t2 uninitialized_var(____t2);		\
+	(void) (&____t1 == &____t2);		\
+} while (0)
+
+#define match_type(t, v)			\
+	match_type_type(t, typeof(v))
+
 /*
  * min()/max()/clamp() macros that also do
  * strict type-checking.. See the

