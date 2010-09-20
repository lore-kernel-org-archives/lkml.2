Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab0ITUL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:11:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34400 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756778Ab0ITULz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:11:55 -0400
Message-ID: <4C97BFE7.6050202@zytor.com>
Date: Mon, 20 Sep 2010 13:11:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Thunderbird/3.1.3
MIME-Version: 1.0
To: Venkatesh Pallipadi <venki@google.com>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, asit.k.mallick@intel.com,
        arjan@linux.kernel.org, a.p.zijlstra@chello.hl, lenb@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: Re: [tip:x86/idle] x86, hotplug: Move WBINVD back outside the play_dead
 loop
References: <tip-ea53069231f9317062910d6e772cca4ce93de8c8@git.kernel.org>	<tip-a68e5c94f7d3dd64fef34dd5d97e365cae4bb42a@git.kernel.org> <AANLkTimCXZWVb7ajANPg15Zuo22nst=d5p-MjXhzu1NX@mail.gmail.com> <4C97A5EF.4070100@zytor.com>
In-Reply-To: <4C97A5EF.4070100@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------030005090709000904020900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030005090709000904020900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/20/2010 11:20 AM, H. Peter Anvin wrote:
> On 09/17/2010 05:48 PM, Venkatesh Pallipadi wrote:
>>>
>>> +       wbinvd();
>>> +
>>>        while (1) {
>>> -               mb();
>>> -               wbinvd();
>>>                __monitor(&current_thread_info()->flags, 0, 0);
>>>                mb();
>>
>>
>> Just one observation. There are some CPUs with errata that need
>> clflush before monitor. So, if that CPU wakesup spuriously it may have
>> problem reentering idle. Not sure whether that will be a problem as
>> that errata also depended on read happening on the flag. May be its
>> better to do monitor (0, 0, 0).
>>
> 
> It seems the easy way to deal with that would be to just add clflush
> before monitor... it is *probably* redundant, but it should be safe to
> do. It means depending on X86_FEATURE_CLFLUSH as well as
> X86_FEATURE_MWAIT, but I don't think there is any x86 processor which
> has MWAIT and not CLFLUSH, and I highly doubt there ever will be.
> 
> Does anyone see any downside?
> 

Patch for review... anyone see any problem with it?

	-hpa


--------------030005090709000904020900
Content-Type: text/x-patch;
 name="0001-x86-hotplug-In-the-MWAIT-case-of-play_dead-CLFLUSH-t.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-hotplug-In-the-MWAIT-case-of-play_dead-CLFLUSH-t.pa";
 filename*1="tch"

>From 83c70ace9aad19ba7c41986f3c34a0808fbaf78f Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Mon, 20 Sep 2010 13:04:45 -0700
Subject: [PATCH] x86, hotplug: In the MWAIT case of play_dead, CLFLUSH the cache line

When we're using MWAIT for play_dead, explicitly CLFLUSH the cache
line before executing MONITOR.  This is a potential workaround for the
Xeon 7400 erratum AAI65 after having a spurious wakeup and returning
around the loop.  "Potential" here because it is not certain that that
erratum could actually trigger; however, the CLFLUSH should be
harmless.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Asit Mallick <asit.k.mallick@intel.com>
Cc: Arjan van de Ven <arjan@linux.kernel.org>
Cc: Len Brown <lenb@kernel.org>
Cc: Venkatesh Pallipadi <venki@google.com>
---
 arch/x86/kernel/smpboot.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 55c80ffb..fdccfe9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1394,9 +1394,12 @@ static inline void mwait_play_dead(void)
 	unsigned int highest_cstate = 0;
 	unsigned int highest_subcstate = 0;
 	int i;
+	void *mwait_ptr;
 
 	if (!cpu_has(&current_cpu_data, X86_FEATURE_MWAIT))
 		return;
+	if (!cpu_has(&current_cpu_data, X86_FEATURE_CLFLSH))
+		return;
 	if (current_cpu_data.cpuid_level < CPUID_MWAIT_LEAF)
 		return;
 
@@ -1422,10 +1425,25 @@ static inline void mwait_play_dead(void)
 			(highest_subcstate - 1);
 	}
 
+	/*
+	 * This should be a memory location in a cache line which is
+	 * unlikely to be touched by other processors.  The actual
+	 * content is immaterial as it is not actually modified in any way.
+	 */
+	mwait_ptr = &current_thread_info()->flags;
+
 	wbinvd();
 
 	while (1) {
-		__monitor(&current_thread_info()->flags, 0, 0);
+		/*
+		 * The CLFLUSH is a workaround for erratum AAI65 for
+		 * the Xeon 7400 series.  It's not clear it is actually
+		 * needed, but it should be harmless in either case.
+		 * The WBINVD is insufficient due to the spurious-wakeup
+		 * case where we return around the loop.
+		 */
+		clflush(mwait_ptr);
+		__monitor(mwait_ptr, 0, 0);
 		mb();
 		__mwait(eax, 0);
 	}
-- 
1.7.2


--------------030005090709000904020900--
