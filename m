Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538Ab2EDHp2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:45:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65009 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2EDHp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:45:27 -0400
Date: Fri, 4 May 2012 00:38:10 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 3/3] vmevent: Implement special low-memory attribute
Message-ID: <20120504073810.GA25175@lizard>
References: <20120501132409.GA22894@lizard>
 <20120501132620.GC24226@lizard>
 <4FA35A85.4070804@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4FA35A85.4070804@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 01:26:45PM +0900, Minchan Kim wrote:
[...]
> > be useful for different use cases.
> 
> Why should we do it in kernel side?

Because currently you can't do this in userland, see below. Today
this would be effectively the same as constantly reading /proc/vmstat,
which is surely not friendly performance/context switches/battery
wise.

> If vmevent will have VMEVENT_ATTR_[FILE|MOCK|DIRTY|WRITEBACK|SHMEM|ANON|SWAP]_PAGES
> and so on which is needed by calculation, we can calculate it in userspace without
> forking /proc/vmstat to see it. So I think there is no problem to do it in userspace.

There are two problems.

1. Originally, the idea behind vmevent was that we should not expose all
   these mm details in vmevent, because it ties ABI with Linux internal
   memory representation;

2. If you have say a boolean '(A + B + C + ...) > X' attribute (which is
   exactly what blended attributes are), you can't just set up independent
   thresholds on A, B, C, ... and have the same effect.

   (What we can do, though, is... introduce arithmetic operators in
   vmevent. :-D But then, at the end, we'll probably implement in-kernel
   forth-like stack machine, with vmevent_config array serving as a
   sequence of op-codes. ;-)

If we'll give up on "1." (Pekka, ping), then we need to solve "2."
in a sane way: we'll have to add a 'NR_FILE_PAGES - NR_SHMEM -
<todo-locked-file-pages>' attribute, and give it a name.

RECLAIMABLE_CACHE_PAGES maybe?

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
