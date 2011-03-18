Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab1CRF0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 01:26:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42907 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131Ab1CRF0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 01:26:22 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4D82ED01.304@np.css.fujitsu.com>
Date: Fri, 18 Mar 2011 14:26:25 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Check whether pages are poisoned before copying
References: <4D817234.9070106@jp.fujitsu.com> <4D8172D7.3040201@jp.fujitsu.com> <20110317041424.GD11094@one.firstfloor.org> <4D819A2A.8050606@jp.fujitsu.com> <20110317062612.GE11094@one.firstfloor.org> <4D81BB87.10803@jp.fujitsu.com> <20110317152150.GF11094@one.firstfloor.org>
In-Reply-To: <20110317152150.GF11094@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andi

(2011/03/18 0:21), Andi Kleen wrote:
>> At least copy to the last page of the huge page is performed after
>> all preceding copies are finished.  So I'm not sure it is really
>> "a few" or not.
>> Still I think making the window smaller than now is worthwhile,
>> no matter it is change from 0.1% to 0.01%, or from 0.01% to 0.001%.
> 
> Note that hwpoison will never reach 100% coverage. That's impossible.
> But to get nearer to 100% it's better to concentrate of the paths
> that affect long time windows and significant amounts of memory.
> What those are is often non-obvious and needs measurements.
> 
>>
>> Or did you find the downside of the check here?
> 
> The usual problem is how to test it. That tends to be harder 
> than just writing the code. If it's not tested it's probably 
> not worth having.
> 

We did the test with our own test method. And the problem happened
as we expected really.

The method needs kernel part and user part. They are listed as following.
    1. Kernel part
       A. Debug interface
          - check whether the THP aligned page belongs to THP.
          - set the page position to be poisoned.
          - set the flag whether 4K page or THP in khugepaged daemon will
            be poisoned.
          - split the requested THP to 4K pages.

       B. A daemon poison_sched
          Make poison_sched daemon call memory_failure().

       C. Changes in khugepaged for debug.
          - Check whether the requested page will be collapsed.
          - Set poison information for poison_sched daemon
            when the requested page will be collapsed.
          - print the poison information to kernel log
            when the page has been poisoned.

    2. User part
       A test APL
         - Request memory which may be containing THP.
         - Set test conditions with debug interface.

The steps for our own test are like following:
    1. APL requests memory and check whether the THP aligned page is
       THP with debug interface. If the THP aligned page is not THP,
       APL will be restarted until THP is mapped.

    2. APL set the page position being poisoned and the flag
       whether 4K page or THP in khugepaged daemon is poisoned
       with debug interface.

    3. APL requests to split the requested THP with debug interface.
       Here kernel must remember the split THP page address and pfn
       for later page collapse.

       (Waiting for page collapse ...)

    4. When khugepaged daemon collapses the remembered split THP address
       and pfn, khugepaged daemon will set poison information
       for poison_sched daemon.

    5. khugepaged daemon will do its work continually, and poison_sched
       daemon will call memory_failure() deal with poisoned page
       at the same time.

    6. khugepaged daemon will print poison information to kernel log.
       And whether the APL will be killed or not will be checked
       by ourselves.
       
After we confirmed the above problem, the patch set is also implemented to
be tested. we confirmed the patch set could resolve the problem we got.

Thanks.

Best Regards,
Jin Dongming

> -Andi


