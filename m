Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1GGSG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:06:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:56907 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab1GGSGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:06:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,494,1304319600"; 
   d="scan'208";a="24579114"
Message-ID: <4E15F5BC.6050801@linux.intel.com>
Date: Thu, 07 Jul 2011 11:06:52 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Vitaliy Ivanov <vitalivanov@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [PATCH 4/4] futex: warning corrections
References: <1309821688.4527.10.camel@vitaliy-Vostro-1400>	<4E1494A8.7070109@linux.intel.com>	<1309986669.27362.3.camel@vitaliy-Vostro-1400>	<4E14E1C6.1010202@linux.intel.com> <CAGTPOqefJup5Nn0r3z+UYCh-dqPKz0cwDwL2znTRKzLuBSUtZQ@mail.gmail.com>
In-Reply-To: <CAGTPOqefJup5Nn0r3z+UYCh-dqPKz0cwDwL2znTRKzLuBSUtZQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/07/2011 05:39 AM, Vitaliy Ivanov wrote:
>>> From 8eeaa5a97697bcc606aea23d32028aea7b271a96 Mon Sep 17 00:00:00 2001
>>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
>>> Date: Thu, 7 Jul 2011 00:05:05 +0300
>>> Subject: [PATCH] futex: uninitialized warning corrections
>>> MIME-Version: 1.0
>>> Content-Type: text/plain; charset=UTF-8
>>> Content-Transfer-Encoding: 8bit
>>>
>>> kernel/futex.c: In function ‘fixup_pi_state_owner.clone.17’:
>>> kernel/futex.c:1582:6: warning: ‘curval’ may be used uninitialized in this function
>>> kernel/futex.c: In function ‘handle_futex_death’:
>>> kernel/futex.c:2486:6: warning: ‘nval’ may be used uninitialized in this function
>>> kernel/futex.c: In function ‘do_futex’:
>>> kernel/futex.c:863:11: warning: ‘curval’ may be used uninitialized in this function
>>> kernel/futex.c:828:6: note: ‘curval’ was declared here
>>> kernel/futex.c:898:5: warning: ‘oldval’ may be used uninitialized in this function
>>> kernel/futex.c:890:6: note: ‘oldval’ was declared here
>>>
>>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
>>
>> Please include a blurb in the commit message as to why you used
>> uninitialized_var() rather than just assigning it. This will save people
>> the time of wondering why, and me the time of nacking "it's simpler to
>> just initialize to zero" patches :-)
>>
>> Acked-by: Darren Hart <dvhart@linux.intel.com>
> 
> Darren,
> 
> Thanks for your comments. I think the description is pretty obvious
> here as I don't think any of these variables are affected by cmpxchg.

Not so. Consider the following:

	u32 curval;
	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
		ret = -EFAULT;
	else if (curval != uval)
		ret = -EINVAL;

the cmpxchg here assigns curval to newval if *uaddr==uval or to *uaddr
otherwise. This is where curval gets assigned so that it can then be
read in the following if block. gcc didn't recognize this as an
assignment and is why it complained about it being used uninitialized.


> There is simple assignment at the end. Seems like compiler simply
> doesn't follow all the return cases.

No, the compiler complained about the test of the value, this doesn't
have anything to do with the return cases.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
