Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933909Ab1CXRGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:06:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59050 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933672Ab1CXRGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hrjpa2LdrjuZuYDS3nCZ2bJFf0Qc6Wce5xiCO8gfskYG3j7ee9gzqLCnyCehLhqjhN
         HQU+4cnxlo3cXRsgpj1+C4O0HamQsBD9DmUT7pOwCGw6Fmqc+Gnl3Iy217OT1CH3zTTV
         f1isKNk6OsMm6QdeMK4aidS9hus4CJUcfqgFg=
Message-ID: <4D8B7A01.70304@gmail.com>
Date: Thu, 24 Mar 2011 20:06:09 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Lin Ming <ming.m.lin@intel.com>, Don Zickus <dzickus@redhat.com>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: P4 PMU - Add missing read of a counter
 before test
References: <AANLkTikwJFCrpTit8=-=agowkTwZtoyEtFaE7yp0O8MF@mail.gmail.com> <20110324084819.GH30812@elte.hu> <4D8B6569.2030001@gmail.com> <20110324163332.GA2414@elte.hu> <4D8B7570.40101@gmail.com> <20110324165142.GB2414@elte.hu>
In-Reply-To: <20110324165142.GB2414@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 07:51 PM, Ingo Molnar wrote:
> 
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
>> Unflagged overflows never have been catched due to missed read of a register which
>> is to signalize about it, and as result unknown nmi may happen leading to
>> "Dazen and confused" message. That is what supposed to be in changelog?
> 
> Exactly, the 'Dazed and confused' message is *all* that the user cares about so 
> it must feature prominently in the changelog.
> 
> If a P4 user searches lkml he wants to know which fixed address 
> dazed-and-confused messages. He will know nothing about 'unflagged overflows' 
> or other internals ...
> 
> All the other details about how the patch does the fix is secondary to what 
> users experience when they hit this bug.
> 
> Thanks,
> 
> 	Ingo

ok, let me try
---
From: Don Zickus <dzickus@redhat.com>
Subject: [PATCH -tip] perf, x86: P4 PMU - Catch unknown NMI on unflagged overflows

The read of a proper MSR register was missed and instead of counter the
configration register was tested (it has ARCH_P4_UNFLAGGED_BIT always
cleared) leading to unknown NMI hitting the system. As result the user may
obtain "Dazed and confused, but trying to continue" message. Fix it by reading
a proper MSR register.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
===================================================================
--- linux-2.6.tip.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.tip/arch/x86/kernel/cpu/perf_event_p4.c
@@ -777,6 +777,7 @@ static inline int p4_pmu_clear_cccr_ovf(
 	 * the counter has reached zero value and continued counting before
 	 * real NMI signal was received:
 	 */
+	rdmsrl(hwc->event_base, v);
 	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;

