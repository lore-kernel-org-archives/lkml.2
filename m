Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab3AJDsx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 22:48:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:47330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932781Ab3AJDsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 22:48:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,441,1355126400"; 
   d="scan'208";a="275180767"
Message-ID: <50EE3A66.4060407@intel.com>
Date: Thu, 10 Jan 2013 11:49:58 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Morten Rasmussen <Morten.Rasmussen@arm.com>
CC: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "bp@alien8.de" <bp@alien8.de>, "pjt@google.com" <pjt@google.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 0/22] sched: simplified fork, enable load average into
 LB and power awareness scheduling
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <20130109171641.GA2046@e103034-lin>
In-Reply-To: <20130109171641.GA2046@e103034-lin>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> 3, power awareness scheduling, patch 13~22,
>> The subset implement my previous power aware scheduling proposal:
>> https://lkml.org/lkml/2012/8/13/139
>> It defines 2 new power aware policy balance and powersaving, and then
>> try to spread or pack tasks on each of sched group level according the
>> different scheduler policy. That can save much power when task number in
>> system is no more then LCPU number.
> 
> Interesting stuff. I have read through your patches, but it is still not
> clear to me what metrics you use to determine whether a sched group is
> fully utilized or if it can be used for packing more tasks. Is it based on
> nr_running or PJT's tracked load or both? How is the threshold defined?

Thanks review, Morten!

cpu utilisation = rq->util * (rq->nr_running? rq->running : 1),
here: rq->util = running time / whole period.

If nr_running == 2, util == 99%, the potential max 'utilisation' is 99 *
2 = 198, because both of tasks may has the possibility to run full time.

group utils = Sum of all cpu's util,
like a 2 LCPU group, A nr_running is 0, B cpu util is 99%, and has 3 tasks,
So, the group utils = A'util + 99 * 3, that is bigger than threshold =
99% * 2.

The above calculation bias to performance, and that is our purpose.

