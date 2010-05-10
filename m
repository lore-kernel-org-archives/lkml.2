Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933375Ab0EJXoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:44:16 -0400
Received: from ozlabs.org ([203.10.76.45]:48700 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933477Ab0EJXnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:43:53 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: cpumask: fix compat getaffinity
Date: Tue, 11 May 2010 09:13:47 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-21-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Ken Werner <ken.werner@web.de>
References: <201005071445.50147.arnd@arndb.de> <201005081800.48240.rusty@rustcorp.com.au> <201005081111.08720.arnd@arndb.de>
In-Reply-To: <201005081111.08720.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005110913.49162.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 May 2010 06:41:08 pm Arnd Bergmann wrote:
> On Saturday 08 May 2010 10:30:47 Rusty Russell wrote:
> > 
> > On Fri, 7 May 2010 10:15:49 pm Arnd Bergmann wrote:
> > > Commit a45185d2d "cpumask: convert kernel/compat.c" broke
> > > libnuma, which abuses sched_getaffinity to find out NR_CPUS
> > > in order to parse /sys/devices/system/node/node*/cpumap.
> > > 
> > > On NUMA systems with less than 32 possibly CPUs, the
> > > current compat_sys_sched_getaffinity now returns '4'
> > > instead of the actual NR_CPUS/8, which makes libnuma
> > > bail out when parsing the cpumap.
> > 
> > Really?  AFAICT the cpumap is printed using nr_cpu_ids too.  Can you
> > give an example of what cpumap is on this system?
> 
> On Ken's PS3 running the Fedora 12 kernel (2.6.32-something), the output
> from my memory is 00000000,00000000,00000000,00000003\n. NR_CPUs
> is 128, nr_cpu_ids is most likely 2.

Ah, I see.  CONFIG_CPUMASK_OFFSTACK=n.

The nr_cpumask_bits is really an optimization for cpumask_first etc: making
it a constant (NR_CPUS) rather than a variable (nr_cpu_ids) for small NR_CPUS
makes it slightly faster.

However, we also use this for scnprintf et al, revealing this inconsistency.
Your patch would break libnuma on CONFIG_CPUMASK_OFFSTACK=y.

How's this?

cpumask: use nr_cpu_ids for printing and parsing cpumasks

Commit a45185d2d "cpumask: convert kernel/compat.c" broke
libnuma, which abuses sched_getaffinity to find out NR_CPUS
in order to parse /sys/devices/system/node/node*/cpumap.

However, the result now returned reflects nr_cpu_ids, and
cpumask_scnprintf et al. use nr_cpumask_bits which is NR_CPUS (for
CONFIG_CPUMASK_OFFSTACK=n) or nr_cpu_ids (for
CONFIG_CPUMASK_OFFSTACK=y).

We should use nr_cpu_ids consistently.

Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: stable@kernel.org

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -529,7 +529,7 @@ static inline void cpumask_copy(struct c
 static inline int cpumask_scnprintf(char *buf, int len,
 				    const struct cpumask *srcp)
 {
-	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpumask_bits);
+	return bitmap_scnprintf(buf, len, cpumask_bits(srcp), nr_cpu_ids);
 }
 
 /**
@@ -543,7 +543,7 @@ static inline int cpumask_scnprintf(char
 static inline int cpumask_parse_user(const char __user *buf, int len,
 				     struct cpumask *dstp)
 {
-	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpumask_bits);
+	return bitmap_parse_user(buf, len, cpumask_bits(dstp), nr_cpu_ids);
 }
 
 /**
@@ -558,8 +558,7 @@ static inline int cpumask_parse_user(con
 static inline int cpulist_scnprintf(char *buf, int len,
 				    const struct cpumask *srcp)
 {
-	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp),
-				    nr_cpumask_bits);
+	return bitmap_scnlistprintf(buf, len, cpumask_bits(srcp), nr_cpu_ids);
 }
 
 /**
@@ -572,7 +571,7 @@ static inline int cpulist_scnprintf(char
  */
 static inline int cpulist_parse(const char *buf, struct cpumask *dstp)
 {
-	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpumask_bits);
+	return bitmap_parselist(buf, cpumask_bits(dstp), nr_cpu_ids);
 }
 
 /**
