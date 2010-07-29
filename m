Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab0G2APi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 20:15:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:43142 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0G2APh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 20:15:37 -0400
Message-ID: <4C50C7F2.8020305@windriver.com>
Date: Wed, 28 Jul 2010 19:14:42 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net
Subject: Re: [GIT PULL] kgdb regression fixes for 2.6.35-rc5
References: <1280349590-27754-1-git-send-email-jason.wessel@windriver.com> <20100728211725.GF5394@nowhere> <AANLkTikXGm0WK+N=YMWJc+hBgVAyLc0adu4K1iX5UMW=@mail.gmail.com>
In-Reply-To: <AANLkTikXGm0WK+N=YMWJc+hBgVAyLc0adu4K1iX5UMW=@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jul 2010 00:14:44.0237 (UTC) FILETIME=[0BCF9BD0:01CB2EB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2010 04:26 PM, Linus Torvalds wrote:
> On Wed, Jul 28, 2010 at 2:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> I'm sorry I spot it a bit late.
>> There is a little issue in this patch, irqs won't
>> be restored:
>>
>> @@ -588,9 +588,10 @@ int kgdb_ll_trap(int cmd, const char *str,
>>        if (!kgdb_io_module_registered)
>>                return NOTIFY_DONE;
>>
>> +       local_irq_save(flags);
>>        return __kgdb_notify(&args, cmd);
>> +       local_irq_restore(flags);
>>  }
> 
> Yeah, that's obviously crap. I also wonder why __kgdb_notify messes up
> the flags to begin with.
> 

This should not be needed as the irqs should already be off while in the overflow handler.

Sorry for the noise on the one.   I updated the for_linus branch with the final version.


 1 files changed, 7 insertions(+), 2 deletions(-)


--
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -572,7 +572,6 @@ static int __kgdb_notify(struct die_args *args, unsigned long cmd)
 	return NOTIFY_STOP;
 }
 
-#ifdef CONFIG_KGDB_LOW_LEVEL_TRAP
 int kgdb_ll_trap(int cmd, const char *str,
 		 struct pt_regs *regs, long err, int trap, int sig)
 {
@@ -590,7 +589,6 @@ int kgdb_ll_trap(int cmd, const char *str,
 
 	return __kgdb_notify(&args, cmd);
 }
-#endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
 
 static int
 kgdb_notify(struct notifier_block *self, unsigned long cmd, void *ptr)
@@ -625,6 +623,12 @@ int kgdb_arch_init(void)
 	return register_die_notifier(&kgdb_notifier);
 }
 
+static void kgdb_hw_overflow_handler(struct perf_event *event, int nmi,
+		struct perf_sample_data *data, struct pt_regs *regs)
+{
+	kgdb_ll_trap(DIE_DEBUG, "debug", regs, 0, 0, SIGTRAP);
+}
+
 void kgdb_arch_late(void)
 {
 	int i, cpu;
@@ -655,6 +659,7 @@ void kgdb_arch_late(void)
 		for_each_online_cpu(cpu) {
 			pevent = per_cpu_ptr(breakinfo[i].pev, cpu);
 			pevent[0]->hw.sample_period = 1;
+			pevent[0]->overflow_handler = kgdb_hw_overflow_handler;
 			if (pevent[0]->destroy != NULL) {
 				pevent[0]->destroy = NULL;
 				release_bp_slot(*pevent);
