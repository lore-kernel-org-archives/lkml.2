Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab1DNTnb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 15:43:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60816 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822Ab1DNTn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 15:43:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MjnqIx1SNamZB+wKhlfjGhOfQEXw/A5EL5bauo95VHbPEu3miW9Qq/fW6BngRsbSqv
         ZmjaQDCByzUZgExmUNUsGTqn1ksc8MewYfrkcvvyOFh3hl1AEbbHb0Xrsc8WkVpgPtbK
         izPx8I7h2i7n1e397xxxQ3z465uR1J3qIZR3k=
Message-ID: <4DA74E5D.4060002@openvz.org>
Date: Thu, 14 Apr 2011 23:43:25 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, Lin Ming <ming.m.lin@intel.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Robert Richter <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf, x86: fix unknown NMIs on a Pentium4 box
References: <4DA70950.3060102@openvz.org> <20110414174327.GA8863@elte.hu> <20110414183231.GN16939@redhat.com> <20110414184606.GD16064@elte.hu>
In-Reply-To: <20110414184606.GD16064@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2011 10:46 PM, Ingo Molnar wrote:
> 
> btw., the bug went away once i removed your patch so it's 100% sure caused by 
> this change.
> 
> Thanks,
> 
> 	Ingo

Ingo if you have a chance mind to give this patch a shot please? Seems we might miss unmasking
for inflight nmis.
-- 
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -1365,14 +1365,15 @@ perf_event_nmi_handler(struct notifier_b
 		 * will be empty and daze the CPU. So, we drop it to
 		 * avoid false-positive 'unknown nmi' messages.
 		 */
+		apic_write(APIC_LVTPC, APIC_DM_NMI);
 		return NOTIFY_STOP;
 	default:
 		return NOTIFY_DONE;
 	}

-	apic_write(APIC_LVTPC, APIC_DM_NMI);

 	handled = x86_pmu.handle_irq(args->regs);
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
 	if (!handled)
 		return NOTIFY_DONE;

