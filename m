Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2CSNuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:50:20 -0400
Received: from david.siemens.de ([192.35.17.14]:25742 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655Ab2CSNuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 09:50:18 -0400
Message-ID: <4F673981.8030709@siemens.com>
Date: Mon, 19 Mar 2012 14:49:53 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 4/4] kgdb: x86: Detach gdb if machine shuts down or reboots
References: <cover.1331900215.git.jan.kiszka@siemens.com> <f0f7cff3e5a7679de73a3338138f023ed3aca39c.1331900215.git.jan.kiszka@siemens.com> <4F635E06.8070006@windriver.com>
In-Reply-To: <4F635E06.8070006@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-16 16:36, Jason Wessel wrote:
> On 03/16/2012 07:17 AM, Jan Kiszka wrote:
>> Hook into machine restart/power-off/halt handlers and call gdbstub_exit
>> so that a attached gdb frontend is properly informed. If kgdb is
>> disabled or no frontend attached, gdbstub_exit will do nothing.
>>
> 
> 
> We have long had an out of tree patch which hooked the reboot notifier, vs adding call backs to the actual reboot functions.  It seems at first glance that all of cases that Jan probably cares about are actually caught by the reboot notifier.
> 
> I attached the patch I am referencing, and perhaps Jan can try it out.   It applies on top of Jan's series at the moment.
> 
> A few more comments first.
> 
>>  static void __machine_emergency_restart(int emergency)
>>  {
>>  	reboot_emergency = emergency;
>> +	gdbstub_exit(1);
> 
> 
> If we do have to add callbacks at the arch level, my preference is to pass the stop code like you would have received in the reboot notifier.  Specifically something like:  gdbstub_exit(SYS_RESTART).

Yes, that sounds reasonable.

> 
>>  	machine_ops.emergency_restart();
>>  }
>>  
>> @@ -730,6 +732,7 @@ struct machine_ops machine_ops = {
>>  
>>  void machine_power_off(void)
>>  {
>> +	gdbstub_exit(0);
> 
> 
> Similarly gdbstub_exit(SYS_HALT) and so on.
> 
> Jan, what do you think about trying the reboot notifier version?

An arch-independent hook has its advantages, no question. Maybe we
should just start this way and then evolved on top as needed.

I was wondering why those other archs do not use the notifier. Maybe one
motivation is to avoid that too much code is excluded from the debugger
by detaching too early. Could possibly be addressed by making
detach-on-reboot runtime configurable.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
