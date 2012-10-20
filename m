Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab2JTE4s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2012 00:56:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28070 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2JTE4q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2012 00:56:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,619,1344182400"; 
   d="scan'208";a="6033899"
Message-ID: <5082305A.2050108@cn.fujitsu.com>
Date: Sat, 20 Oct 2012 13:02:18 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] acpi,memory-hotplug : add memory offline code to
 acpi_memory_device_remove()
References: <506C0AE8.40702@jp.fujitsu.com> <506C0C53.60205@jp.fujitsu.com> <CAHGf_=p7PaQs-kpnyB8uC1MntHQfL-CXhhq4QQP54mYiqOswqQ@mail.gmail.com> <50727984.20401@cn.fujitsu.com> <CAHGf_=pCrx8AkL9eiSYVgwvT1v0SW2__P_DW-1Wwj_zskqcLXw@mail.gmail.com> <507E77D1.3030709@cn.fujitsu.com> <CAHGf_=rxGeb0RsgEFF2FRRfdX0wiE9cDyVaftsG3E8AgyzYi1g@mail.gmail.com> <508118A6.80804@cn.fujitsu.com> <CAHGf_=qfzEJ0VjeYkKFVtyew+wYM-rHS4nqmXU4t7HYGuv8k9w@mail.gmail.com>
In-Reply-To: <CAHGf_=qfzEJ0VjeYkKFVtyew+wYM-rHS4nqmXU4t7HYGuv8k9w@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/20 12:56:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/20 12:56:18,
	Serialize complete at 2012/10/20 12:56:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/20/2012 02:19 AM, KOSAKI Motohiro Wrote:
>> Hmm, IIRC, if the memory is recognized from kerenl before driver initialization,
>> the memory device is not managed by the driver acpi_memhotplug.
> 
> Yup.
> 
> 
>> I think we should also deal with REMOVAL_NORMAL here now. Otherwise it will cause
>> some critical problem: we unbind the device from the driver but we still use
>> it. If we eject it, we have no chance to offline and remove it. It is very dangerous.
> 
> ??
> If resource was not allocated a driver, a driver doesn't need to
> deallocate it when
> error path. I haven't caught your point.
> 

REMOVAL_NORMAL can be in 2 cases:
1. error path. If init call fails, we don't call it. We call this function
   only when something fails after init.

2. unbind the device from the driver.
   If we don't offline and remove memory when unbinding the device from the driver,
   the device may be out of control. When we eject this driver, we don't offline and
   remove it, but we will eject and poweroff the device. It is very dangerous because
   the kernel uses the memory but we poweroff it.

   acpi_bus_hot_remove_device()
       acpi_bus_trim() // this function successes because the device has no driver
       _PS3 // poweroff
       _EJ0 // eject

Thanks
Wen Congyang
