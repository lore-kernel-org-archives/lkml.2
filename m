Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0JTNyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:54:31 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34809 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0JTNy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:54:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cong Wang <amwang@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        linux-doc@vger.kernel.org
References: <1287476560-5874-1-git-send-email-amwang@redhat.com>
	<1287476560-5874-2-git-send-email-amwang@redhat.com>
	<4CBD9B7F.6040307@linux.intel.com> <m1vd4yi977.fsf@fess.ebiederm.org>
	<4CBDB385.6080100@linux.intel.com> <m1eibmdvew.fsf@fess.ebiederm.org>
	<4CBE86E0.3050505@redhat.com>
Date: Wed, 20 Oct 2010 06:54:15 -0700
In-Reply-To: <4CBE86E0.3050505@redhat.com> (Cong Wang's message of "Wed, 20
	Oct 2010 14:06:24 +0800")
Message-ID: <m1zku99dh4.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
	*  1.0 XM_Evil_Numbers_Gen maybe a phone number spam
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cong Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] sysctl: remove sysctl syscall
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Wang <amwang@redhat.com> writes:

> On 10/20/10 00:00, Eric W. Biederman wrote:
>> To the best of my knowledge the last and user of sys_sysctl is the glibc
>> ioperm (my apologies I mispoke when I said iopl) implementation on arm.
>> Not that people run around calling ioperm very often in any distro.
>
>
> I saw that in Changelog of glibc too, but that was back to 2000, 10 years
> past, I don't see any code using sysctl() in glibc now, except sys_sysctl()
> itself, of course.

You have to look in the glibc-ports tree to see the arm code.

The arm support is not in the main glibc tree for some reason.

Hmm. Looking I thought sys_sysctl had stopped being exported from glibc
but it appears I was wrong.

>> All of that said I think disabling sys_sysctl by default now is totally
>> reasonable.  If there is a percentage in removing the code we can worry
>> about that later.  Perhaps we should add a CONFIG_CRUFT and move
>> sys_sysctl under there.  Binary compatibility that nothing needs but
>> that we actually have code for just in case.
>
> But you put sysctl in features-removal-schedule.txt 3 years ago. :)

I did and before that the first version of the sysctl man page said
the binary values were not portable between kernels, so don't use
the system call.

> I believe they should see the kernel warnings if they are still using
> sysctl.

Unfortunately sometimes a word to the wise isn't quite enough. Sigh.  I
very much think having the sysctl code disabled by default is definitely
safe right now, and the first responsible step in getting this code
removed from the kernel.

There were two original reasons for the deprecations.  Maintaining the
binary sysctl logic was bug prone, and no one was using sysctl.  

The rewriting of the binary interface into binary_sysctl.c takes care of
most if not all of the maintenance concerns.  You may think you are
using the binary interface but the kernel just rewrites it into a /proc
access.

What is left is an interface in the kernel that no one uses and that
will eventually bit rot, for lack of care, attention, and testing, but we
still have a while until that happens.

I recommend this:

---
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..a9e1cda 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -808,7 +808,7 @@ config UID16
 config SYSCTL_SYSCALL
 	bool "Sysctl syscall support" if EMBEDDED
 	depends on PROC_SYSCTL
-	default y
+	default n
 	select SYSCTL
 	---help---
 	  sys_sysctl uses binary paths that have been found challenging
@@ -816,11 +816,15 @@ config SYSCTL_SYSCALL
 	  using paths with ascii names is now the primary path to this
 	  information.
 
-	  Almost nothing using the binary sysctl interface so if you are
-	  trying to save some space it is probably safe to disable this,
-	  making your kernel marginally smaller.
+	  This option is kept as a service to our loyal customers who
+	  have ignored all of our warnings over the years and have a
+	  binary somewhere that won't work without this.
+
+	  This code is not regularly used or tested and will probably have
+	  bit-rotted before someone cares enough to do more maintenance on it
+	  so enable at your own risk.
 
-	  If unsure say Y here.
+	  Say N here.
 
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EMBEDDED
