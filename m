Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909Ab2FOGvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 02:51:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:32946 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab2FOGvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 02:51:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="157919843"
Message-ID: <4FDADB74.3060701@linux.intel.com>
Date: Fri, 15 Jun 2012 14:51:32 +0800
From: Chen Gong <gong.chen@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: tony.luck@intel.com, borislav.petkov@amd.com, x86@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmp patch to fix hotplug issue in CMCI storm
References: <alpine.LFD.2.02.1206080940360.3086@ionos> <1339681786-8418-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1206141554290.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206141554290.3086@ionos>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012/6/14 22:07, Thomas Gleixner 写道:
> On Thu, 14 Jun 2012, Chen Gong wrote:
>> this patch is based on tip tree and previous 5 patches.
>
> You really don't need all this complexity to handle that. The main
> thing is that you clear the storm state and adjust the storm counter
> when the cpu goes offline (in case the state is ACTIVE).
>
> When it comes online again then you can simply let it restart cmci. If
> the storm on this cpu (or node) still exists then it will notice and
> everything falls in place.

I ever tested some different scenarios, if storm on this cpu still
exists, it triggers the CMCI and broadcast it on the sibling CPU,
which means the counter *cmci_storm_on_cpus* will increase beyond
the upper limit. E.g. on a 2 sockets SandyBridge-EP system (one socket
has 8 cores and 16 threads), inject one error on one socket, you can
watch *cmci_storm_on_cpus* = 16 becuase of CMCI broadcast, during
this time, offline and online one CPU on this socket, firstly
*cmci_storm_on_cpus* = 15 because of offline and ACTIVE status, and then 
*cmci_storm_on_cpus* = 31 in that CMCI is actived because of
online.That's why I have to disable CMCI during whole online/offline
until CMCI storm is subsided. Frankly, the logic is a little bit
complex so that I write many comments to avoid I forget it after some
time :-)


