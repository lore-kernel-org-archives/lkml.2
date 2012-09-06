Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205Ab2IFCI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 22:08:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12817 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753400Ab2IFCI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 22:08:58 -0400
X-IronPort-AV: E=Sophos;i="4.80,377,1344182400"; 
   d="scan'208";a="5791709"
Message-ID: <50480624.3070308@cn.fujitsu.com>
Date: Thu, 06 Sep 2012 10:10:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/11 V5] workqueue: new day don't need WORKER_REBIND
 for busy rebinding
References: <1346841475-4422-1-git-send-email-laijs@cn.fujitsu.com> <1346841475-4422-4-git-send-email-laijs@cn.fujitsu.com> <20120905183148.GB13737@google.com>
In-Reply-To: <20120905183148.GB13737@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 10:08:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/06 10:08:33,
	Serialize complete at 2012/09/06 10:08:33
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 02:31 AM, Tejun Heo wrote:
> On Wed, Sep 05, 2012 at 06:37:40PM +0800, Lai Jiangshan wrote:
>> because old busy_worker_rebind_fn() have to wait until all idle worker finish.
>> so we have to use two flags WORKER_UNBOUND and WORKER_REBIND to avoid
>> prematurely clear all NOT_RUNNING bit when highly frequent offline/online.
>>
>> but current code don't need to wait idle workers. so we don't need to
>> use two flags, just one is enough. remove WORKER_REBIND from busy rebinding.
> 
> ROGUE / REBIND thing existed for busy workers from the beginning when
> there was no idle worker rebinding, so this definitely wasn't about
> whether idle rebind is synchronous or not. 

In very old day, this definitely wasn't about whether idle rebind is synchronous or not.
but after you reimplement rebind_worker(), it is the only reason for WORKER_REBIND in busy rebinding.

if I miss something, this 03/11 will be wrong. the old code did not comment all why
WORKER_REBIND is needed. so we have to think more about the correctness of this 03/11.

> Trying to remember
> what... ah, okay, setting of DISASSOCIATED and setting of WORKER_ROGUE
> didn't use to happen together with gcwq->lock held.  CPU_DOWN would
> first set ROGUE and then later on set DISASSOCIATED, so if the
> rebind_fn kicks in inbetween that, it would break CPU_DOWN.
> 
> I think now that both CPU_DOWN and UP are done under single holding of
> gcwq->lock, this should be safe.  It would be nice to note what
> changed in the patch description and the atomicity requirement as a
> comment tho.
> 

Oh, I forgot to add changelog about single holding of gcwq->lock.


Thanks
Lai

