Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0CWNwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:52:42 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:34658 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753302Ab0CWNwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:52:41 -0400
X-Sasl-enc: qqq3Hl5XlauaR3PtMGIgdKjKlo0BT9WU6qQ+5sOwoP3u 1269352360
Message-ID: <4BA8C7A4.8050502@ladisch.de>
Date: Tue, 23 Mar 2010 14:52:36 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: David R <david@unsolicited.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.34-rc2 - crash on shutdown
References: <20100323090206.33932wop73sdefm6@unsolicited.net>	 <4BA8ADB8.1030802@ladisch.de> <bd4cb8901003230631q22cdac6dg8011489b94c6d5e0@mail.gmail.com>
In-Reply-To: <bd4cb8901003230631q22cdac6dg8011489b94c6d5e0@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
> On Tue, Mar 23, 2010 at 1:02 PM, Clemens Ladisch <clemens@ladisch.de> wrote:
> > The only pointer access in this function is cpuhw->amd_nb, but
> > I don't see any obvious bugs.
> 
> I reported a problem with the AMD initialization just last week.
> There is an issue with amd_pmu_cpu_online() which gets called
> too early, and thus fails. That leaves some bogus state and causes
> a crash in amd_pmu_cpu_offline().
> 
> I proposed a fix which was rejected. The alternative involves moving
> some the of CPU initialization code (on AMD) to an earlier position,i.e.,
> which would be executed before the CPU_STARTED notifier. Nobody
> has proposed anything else so far.

I don't know about the early bootmem stuff, but regardless of this issue,
if amd_pmu_cpu_online() can fail, then amd_pmu_cpu_offline() must be able
to handle this without blowing up.  Something like this (untested):

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -324,17 +324,17 @@ static void amd_pmu_cpu_online(int cpu)
 	if (boot_cpu_data.x86_max_cores < 2)
 		return;
 
+	cpu1 = &per_cpu(cpu_hw_events, cpu);
+	cpu1->amd_nb = NULL;
+
 	/*
 	 * function may be called too early in the
 	 * boot process, in which case nb_id is bogus
 	 */
 	nb_id = amd_get_nb_id(cpu);
 	if (nb_id == BAD_APICID)
 		return;
 
-	cpu1 = &per_cpu(cpu_hw_events, cpu);
-	cpu1->amd_nb = NULL;
-
 	raw_spin_lock(&amd_nb_lock);
 
 	for_each_online_cpu(i) {
@@ -370,7 +370,7 @@ static void amd_pmu_cpu_offline(int cpu)
 
 	raw_spin_lock(&amd_nb_lock);
 
-	if (--cpuhw->amd_nb->refcnt == 0)
+	if (cpuhw->amd_nb && --cpuhw->amd_nb->refcnt == 0)
 		kfree(cpuhw->amd_nb);
 
 	cpuhw->amd_nb = NULL;
