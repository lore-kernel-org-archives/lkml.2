Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab1KWHuQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 02:50:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64201 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757412Ab1KWHuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 02:50:14 -0500
Message-ID: <4ECCA578.6020700@cn.fujitsu.com>
Date: Wed, 23 Nov 2011 15:49:12 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Paul Menage <paul@paulmenage.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.2-rc3] cpusets: stall when updating mems_allowed
 for mempolicy or disjoint nodemask
References: <alpine.DEB.2.00.1111161307020.23629@chino.kir.corp.google.com> <4EC4C603.8050704@cn.fujitsu.com> <alpine.DEB.2.00.1111171328120.15918@chino.kir.corp.google.com> <4EC62AEA.2030602@cn.fujitsu.com> <alpine.DEB.2.00.1111181545170.24487@chino.kir.corp.google.com> <4ECC5FC8.9070500@cn.fujitsu.com> <alpine.DEB.2.00.1111221902300.30008@chino.kir.corp.google.com> <4ECC7B1E.6020108@cn.fujitsu.com> <alpine.DEB.2.00.1111222210341.21009@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1111222210341.21009@chino.kir.corp.google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-23 15:49:54,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-11-23 15:49:55,
	Serialize complete at 2011-11-23 15:49:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Nov 2011 22:25:46 -0800 (pst), David Rientjes wrote:
> On Wed, 23 Nov 2011, Miao Xie wrote:
> 
>> This is a good idea. But I worry that oom will happen easily, because we do
>> direct reclamation and compact by mems_allowed.
>>
> 
> Memory compaction actually iterates through each zone regardless of 
> whether it's allowed or not in the current context.  Recall that the 
> nodemask passed into __alloc_pages_nodemask() is non-NULL only when there 
> is a mempolicy that restricts the allocations by MPOL_BIND.  That nodemask 
> is not protected by get_mems_allowed(), so there's no change in 
> compaction's behavior with my patch.

That nodemask is also protected by get_mems_allowed().

> Direct reclaim does, however, require mems_allowed staying constant 
> without the risk of early oom as you mentioned.  It has its own 
> get_mems_allowed(), though, so it doesn't have the opportunity to change 
> until returning to the page allocator.  It's possible that mems_allowed 
> will be different on the next call to get_pages_from_freelist() but we 
> don't know anything about that context: it's entirely possible that the 
> set of new mems has an abundance of free memory or are completely depleted 
> as well.  So there's no strict need for consistency between the set of 
> allowed nodes during reclaim and the subsequent allocation attempt.  All 
> we care about is that reclaim has a consistent set of allowed nodes to 
> determine whether it's making progress or not.
> 

Agree.
