Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab2EXQmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:42:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38861 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2EXQl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:41:56 -0400
Message-ID: <4FBE64D0.7040507@gmail.com>
Date: Thu, 24 May 2012 10:41:52 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: Re: perf, x86: only do lbr init if bts is available
References: <4FBE5FA6.5050802@gmail.com> <CABPqkBT7dKa3P2hk=_pismGdPHuseWMbCKhUzz1sQNDemb133A@mail.gmail.com>
In-Reply-To: <CABPqkBT7dKa3P2hk=_pismGdPHuseWMbCKhUzz1sQNDemb133A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/12 10:35 AM, Stephane Eranian wrote:
> Well, no. There is no connection between BTS and LBR and you're creating one.

Ok. That was not clear to me from skimming the manual.
Then should it be tied to X86_FEATURE_DTES64?

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c 
b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 520b426..1090ae6 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -640,6 +640,9 @@ void intel_pmu_lbr_init_core(void)
  /* nehalem/westmere */
  void intel_pmu_lbr_init_nhm(void)
  {
+   if (!boot_cpu_has(X86_FEATURE_DTES64))
+       return;
+
     x86_pmu.lbr_nr     = 16;
     x86_pmu.lbr_tos    = MSR_LBR_TOS;
     x86_pmu.lbr_from   = MSR_LBR_NHM_FROM;


> Where is the wrmsr coming from? What we need to do is ensure that LBR is not
> touched if we don't actually use it.

e.g., intel_pmu_lbr_init_nhm sets up lbr_nr, lbr_from, lbr_to and from, 
etc. Fhat I can tell intel_pmu_lbr_reset() gets invoked some where 
during the VM boot; I haven't traced how/when yet.

David
