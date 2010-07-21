Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0GULcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:32:15 -0400
Received: from mail001.aei.ca ([206.123.6.130]:58048 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163Ab0GULcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:32:13 -0400
From: Ed Tomlinson <edt@aei.ca>
To: ngupta@vflare.org
Subject: Re: [PATCH 4/8] Shrink zcache based on memlimit
Date: Wed, 21 Jul 2010 07:32:02 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc5-crc+; KDE/4.4.5; x86_64; ; )
Cc: Minchan Kim <minchan.kim@gmail.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-mm" <linux-mm@kvack.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org> <AANLkTinaX-huEMGP-k4mCSr0USQhJp68AUgOf4FHqr5Q@mail.gmail.com> <4C467D18.4050901@vflare.org>
In-Reply-To: <4C467D18.4050901@vflare.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007210732.03909.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 July 2010 00:52:40 Nitin Gupta wrote:
> On 07/21/2010 04:33 AM, Minchan Kim wrote:
> > On Fri, Jul 16, 2010 at 9:37 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> >> User can change (per-pool) memlimit using sysfs node:
> >> /sys/kernel/mm/zcache/pool<id>/memlimit
> >>
> >> When memlimit is set to a value smaller than current
> >> number of pages allocated for that pool, excess pages
> >> are now freed immediately instead of waiting for get/
> >> flush for these pages.
> >>
> >> Currently, victim page selection is essentially random.
> >> Automatic cache resizing and better page replacement
> >> policies will be implemented later.
> > 
> > Okay. I know this isn't end. I just want to give a concern before you end up.
> > I don't know how you implement reclaim policy.
> > In current implementation, you use memlimit for determining when reclaim happen.
> > But i think we also should follow global reclaim policy of VM.
> > I means although memlimit doen't meet, we should reclaim zcache if
> > system has a trouble to reclaim memory.
> 
> Yes, we should have a way to do reclaim depending on system memory pressure
> and also when user explicitly wants so i.e. when memlimit is lowered manually.
> 
> > AFAIK, cleancache doesn't give any hint for that. so we should
> > implement it in zcache itself.
> 
> I think cleancache should be kept minimal so yes, all reclaim policies should
> go in zcache layer only.
> 
> > At first glance, we can use shrink_slab or oom_notifier. But both
> > doesn't give any information of zone although global reclaim do it by
> > per-zone.
> > AFAIK, Nick try to implement zone-aware shrink slab. Also if we need
> > it, we can change oom_notifier with zone-aware oom_notifier. Now it
> > seems anyone doesn't use oom_notifier so I am not sure it's useful.
> > 
> 
> I don't think we need these notifiers as we can simply create a thread
> to monitor cache hit rate, system memory pressure etc. and shrink/expand
> the cache accordingly.

Nitin,

Based on experience gained when adding the shrinker callbacks, I would 
strongly recommend you use them.  I tried several hacks along the lines of
what you are proposing before moving settling on the callbacks.  They 
are effective and make sure that memory is released when its required.
What would happen with the other methods is that memory would either 
not be released or would be released when it was not needed.

Thanks
Ed Tomlinson.
