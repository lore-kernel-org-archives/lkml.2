Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab2H2CUO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 22:20:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:32526 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab2H2CUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 22:20:13 -0400
X-IronPort-AV: E=Sophos;i="4.80,331,1344182400"; 
   d="scan'208";a="5742566"
Message-ID: <503D7CBB.9080301@cn.fujitsu.com>
Date: Wed, 29 Aug 2012 10:21:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] workqueue: single pass rebind_workers
References: <1346090307-3020-1-git-send-email-laijs@cn.fujitsu.com> <1346090307-3020-5-git-send-email-laijs@cn.fujitsu.com> <20120827190431.GB13094@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120827190431.GB13094@dhcp-172-17-108-109.mtv.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/29 10:20:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/29 10:20:01,
	Serialize complete at 2012/08/29 10:20:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2012 03:04 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Tue, Aug 28, 2012 at 01:58:24AM +0800, Lai Jiangshan wrote:
>> busy_worker_rebind_fn() can't return until all idle workers are rebound,
>> the code of busy_worker_rebind_fn() ensure this.
>>
>> So we can change the order of the code of rebind_workers(),
>> and make it a single pass do the rebind_workers().
>>
>> It makes the code much clean and better readability.
> 
> I can't see how this could be correct.  

Could you elaborate more why it is not correct. 

> What prevents busy worker from
> grabbing manager_mutex before idle one?
> 

busy worker still has WORKER_REBIND when it enter busy_worker_rebind_fn(),
so it can sleep(include grab the manager_mutex). When this mutex_lock()
returns, it means rebind_workers() are done which means all idle are rebound
and can be locally woken up. So busy worker can return from busy_worker_rebind_fn()
and handle other possible-sleeping items.

If the CPU is offline again, the busy worker has WORKER_UNBOUND, it is also correct
when it returns from busy_worker_rebind_fn().
