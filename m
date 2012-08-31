Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2HaBGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 21:06:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53138 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab2HaBGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 21:06:45 -0400
X-IronPort-AV: E=Sophos;i="4.80,344,1344182400"; 
   d="scan'208";a="5756467"
Message-ID: <50400E86.8090500@cn.fujitsu.com>
Date: Fri, 31 Aug 2012 09:08:22 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/9 V3] workqueue: add non_manager_role_manager_mutex_unlock()
References: <1346259120-6216-1-git-send-email-laijs@cn.fujitsu.com> <1346259120-6216-5-git-send-email-laijs@cn.fujitsu.com> <20120829182510.GB2258@dhcp-172-17-108-109.mtv.corp.google.com> <503F2F51.8000301@cn.fujitsu.com> <20120830091739.GA10874@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120830091739.GA10874@dhcp-172-17-108-109.mtv.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/31 09:06:29,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/08/31 09:06:29,
	Serialize complete at 2012/08/31 09:06:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2012 05:17 PM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Thu, Aug 30, 2012 at 05:16:01PM +0800, Lai Jiangshan wrote:
>> gcwq_unbind_fn() is unsafe even it is called from a work item.
>> so we need non_manager_role_manager_mutex_unlock().
>>
>> If rebind_workers() is called from a work item, it is safe when there is
>> no CPU_INTENSIVE items. but we can't disable CPU_INTENSIVE items,
>> so it is still unsafe, we need non_manager_role_manager_mutex_unlock() too.
> 
> Can you please elaborate?  Why is it not safe if there are
> CPU_INTENSIVE items?
> 
> Thanks.
> 

Imaging there only two workers, they all have UNBOUND bit because the rebind_workers()
has not been called. The First one is processing work items, the second one is idle,
when the first one encounter the work item of rebind_workers() and handle it, at the same
the second one try to create workers and failed and go to process work items too.
but unlikely the second one encounters a CPU_INTENSIVE items, the nr_running is still
<=1 after the first one finish rebind_workers().

								nr_running.
first one:	process work item endless			+0 or +1
second one:	process the CPU_INTENSIVE item endless		+0

No one can service for manager role.

Thanks.
Lai
