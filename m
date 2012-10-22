Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858Ab2JVDe1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 23:34:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63529 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab2JVDe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 23:34:26 -0400
X-IronPort-AV: E=Sophos;i="4.80,628,1344182400"; 
   d="scan'208";a="6039884"
Message-ID: <5084BE7C.4020303@cn.fujitsu.com>
Date: Mon, 22 Oct 2012 11:33:16 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "miaox@cn.fujitsu.com" <miaox@cn.fujitsu.com>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        "wency@cn.fujitsu.com" <wency@cn.fujitsu.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 2/2] Do not change worker's running cpu in cmci_rediscover().
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com> <1350625528-1385-3-git-send-email-tangchen@cn.fujitsu.com> <20121019164233.GF11958@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F19D57AA5@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D57AA5@ORSMSX108.amr.corp.intel.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/22 11:33:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/22 11:33:53,
	Serialize complete at 2012/10/22 11:33:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2012 01:21 AM, Luck, Tony wrote:
>> In this case, the following BUG_ON in try_to_wake_up_local() will be triggered:
>> BUG_ON(rq != this_rq());
>
> Logically this looks OK - what is the test case to trigger this?  I've done a moderate
> amount of testing of cpu online/offline while injecting corrected errors (when testing
> the CMCI storm patches) ... but didn't see this problem.

Hi Tony, Borislav,

Here is my case.

I have 2 nodes, node0 and node1. node1 could be hotpluged.
node0 has cpu0 ~ cpu15, node1 has cpu16 ~ cpu31.

I online all the cpus on node1, and hot-remove node1 directly.

When this problem is triggered, current is a work thread.

For example: cpu20 is dying. current is on cpu21, it migrates
itself to cpu22.

Assume current is process1, and it is a work thread.

        cpu21                        cpu22
p1:
....
cmci_rediscover()
|-set_cpus_allowed_ptr()
   |-stop_one_cpu()
     |-create a work to excute migration_cpu_stop()
       |-wait_for_completion()
         |-wait_for_common()
           |-might_sleep()
Here, p1 gives up cpu21.

The work starts:
migration_cpu_stop()
|-migrate p1 to cpu22

                                On cpu22, p1 wakes up:
                                p1:
                                In wait_for_common()
                                   |-do_wait_for_common()
                                     |-schedule_timeout()
                                       |-schedule()
                                         |-__schedule()
                                           |-try_to_wake_up_local()
                                             |-wq_worker_sleeping()
                                             |-BUG_ON(rq != this_rq())

On cpu22, wq_worker_sleeping() uses p1's worker_pool to find a worker
to go on to execute p1. But p1's worker_pool is on cpu21, and p1 is now
on cpu22. So the BUG_ON(rq != this_rq()) is triggered.

Thanks. :)

>
> -Tony
>

