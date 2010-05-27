Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932763Ab0E0GG7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:06:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44118 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755251Ab0E0GG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:06:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4BFE0BE1.4040408@jp.fujitsu.com>
Date: Thu, 27 May 2010 15:06:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Jin Dongming <jin.dongming@np.css.fujitsu.com>,
       LKLM <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [Patch-next] Remove notify_die in do_machine_check functioin
References: <4BFDDBA9.4010702@np.css.fujitsu.com> <1274930481.3444.258.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1274930481.3444.258.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/05/27 12:21), Huang Ying wrote:
> I have heard about that on some machine, some hardware error output pin
> of chipset may be linked with some input pin of CPU which can cause MCE.
> That is, MCE is used to report some chipset errors too. I think that is
> why notify_die is called in do_machine_check. Simply removing notify_die
> is not good for these machines.

Hum, it sounds like "notify_die here is hook for proprietary chipset
driver".  Anyone who have such machine and driver in real?

But if my understanding is correct the notify_die here will call all
registered callbacks and let them process if "DIE_NMI" is an event
what the callback really interested in.

Problems are (1) many callbacks will behave wrongly since they don't
aware that DIE_NMI event can be posted from Machine Check, and (2)
if the machine is not such special hardware it is just waste of time
in critical context where quick page-poisoning might be required.

> Maybe we should fix the notifier user instead. Which notifier user
> consumes the DIE_NMI notification?

What I found at a glance is:

[arch/x86/kernel/cpu/perf_event.c]
   1183 static int __kprobes
   1184 perf_event_nmi_handler(struct notifier_block *self,
   1185                          unsigned long cmd, void *__args)
   1186 {
   1187         struct die_args *args = __args;
   1188         struct pt_regs *regs;
   1189
   1190         if (!atomic_read(&active_events))
   1191                 return NOTIFY_DONE;
   1192
   1193         switch (cmd) {
   1194         case DIE_NMI:
   1195         case DIE_NMI_IPI:
   1196                 break;
   1197
   1198         default:
   1199                 return NOTIFY_DONE;
   1200         }
   1201
   1202         regs = args->regs;
   1203
   1204         apic_write(APIC_LVTPC, APIC_DM_NMI);
   1205         /*
   1206          * Can't rely on the handled return value to say it was our NMI, two
   1207          * events could trigger 'simultaneously' raising two back-to-back NMIs.
   1208          *
   1209          * If the first NMI handles both, the latter will be empty and daze
   1210          * the CPU.
   1211          */
   1212         x86_pmu.handle_irq(regs);
   1213
   1214         return NOTIFY_STOP;
   1215 }

However I think fixing the notifier users is wrong direction.
(At least I have no idea how many ISVs will be affected)

One quick alternative is define "DIE_MCE" and use it instead, but
if special hook like this is really required, I suppose we should
invent some special interface for external plug-in like a chipset's
LLHEH (low-level hardware error handler) etc., to allow additional
platform-specific error handling in critical context.

So I think simply removing it is good to start.
If there are no complaints and no users in these days, we are done.
Otherwise we will get fresh real requirement and will be able to do
proper things.


Thanks,
H.Seto

