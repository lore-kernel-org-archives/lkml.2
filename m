Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab0E0DVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 23:21:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:10111 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807Ab0E0DVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 23:21:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,308,1272870000"; 
   d="scan'208";a="570934097"
Subject: Re: [Patch-next] Remove notify_die in do_machine_check functioin
From: Huang Ying <ying.huang@intel.com>
To: Jin Dongming <jin.dongming@np.css.fujitsu.com>
Cc: LKLM <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <4BFDDBA9.4010702@np.css.fujitsu.com>
References: <4BFDDBA9.4010702@np.css.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 11:21:21 +0800
Message-ID: <1274930481.3444.258.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 10:40 +0800, Jin Dongming wrote:
> This patch fixes do_machine_check() failure caused by DIE_NMI.
> 
> I do MCE tests on my machine. When I inject Uncorrected Error(UE) into
> kernel, the messages of test failure are always gotten. This problem
> is caused by the notification of DIE_NMI in the front of do_machine_check().
> Because there are some notifications used DIE_NMI, and when they finish their
> own work and return NOTIFY_STOP as a result. The result makes
> do_machine_check() return at that time.
> 
> So we decide to delete the notification of DIE_NMI. It is because when UE error
> happens, if one of the cpu is down caused by the error of hook function of
> DIE_NMI, the error type of UE may be different with the real one. For example,
> 
>         CPU0                                  CPU1
> UE      do_machine_check()                    do_machine_check()
>         |                                     |
>         cpu down(hook error of DIE_NMI)       cpu OK(no hook error of DIE_NMI)
>                                               |
>                                               wait CPU0 timeout
>                                               |
>                                               Fatal Error
>                                               (Timeout synchronizing machine
>                                                check over CPUs)

Fatal error will only occur if tolerant = 0, which is not the common
case.

But I think the notify_die can be an issue here. For example UE is on
CPU0, and the MCE is consumed by notify_die; MCE on CPU1 will detect
nothing.

I have heard about that on some machine, some hardware error output pin
of chipset may be linked with some input pin of CPU which can cause MCE.
That is, MCE is used to report some chipset errors too. I think that is
why notify_die is called in do_machine_check. Simply removing notify_die
is not good for these machines.

Maybe we should fix the notifier user instead. Which notifier user
consumes the DIE_NMI notification?

Best Regards,
Huang Ying


