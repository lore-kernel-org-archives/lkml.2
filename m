Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab2HREK1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 00:10:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab2HREKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 00:10:18 -0400
Message-ID: <502F15A6.5060902@redhat.com>
Date: Sat, 18 Aug 2012 00:10:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: Repeated fork() causes SLAB to grow without bound
References: <20120816024610.GA5350@evergreen.ssec.wisc.edu> <502D42E5.7090403@redhat.com> <20120818000312.GA4262@evergreen.ssec.wisc.edu> <502F100A.1080401@redhat.com> <20120818040747.GA22793@evergreen.ssec.wisc.edu>
In-Reply-To: <20120818040747.GA22793@evergreen.ssec.wisc.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2012 12:07 AM, Daniel Forrest wrote:

> I was being careful since I wasn't certain about the locking.  Does
> the test need to be protected by "lock_anon_vma_root"?  That's why I
> chose the overhead of the possible wasted "anon_vma_chain_alloc".

The function anon_vma_clone is being called from fork().

When running fork(), the kernel holds the mm->mmap_sem for
write, which prevents page faults by the parent process.
This means if the anon_vma in question belongs to the parent
process, no new pages will be added to it in this time.

Likewise, if the anon_vma belonged to a grandparent process,
any new pages instantiated in it will not be visible to the
parent process, or to the newly created process. This means
it is safe to skip the anon_vma.

-- 
All rights reversed
