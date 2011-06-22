Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab1FVLII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:08:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab1FVLIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:08:07 -0400
Message-ID: <4E01CCED.5050609@redhat.com>
Date: Wed, 22 Jun 2011 19:07:25 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        dave@linux.vnet.ibm.com, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mel@csn.ul.ie>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/4] mm: make the threshold of enabling THP configurable
References: <1308643849-3325-1-git-send-email-amwang@redhat.com> <1308643849-3325-2-git-send-email-amwang@redhat.com> <alpine.DEB.2.00.1106211817340.5205@chino.kir.corp.google.com> <4E015C36.2050005@redhat.com> <alpine.DEB.2.00.1106212024210.8712@chino.kir.corp.google.com> <4E018060.3050607@redhat.com> <alpine.DEB.2.00.1106212325400.14693@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1106212325400.14693@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年06月22日 14:32, David Rientjes 写道:
> On Wed, 22 Jun 2011, Cong Wang wrote:
>
>>> Either way, this patch isn't needed since it has no benefit over doing it
>>> through an init script.
>>
>> If you were right, CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS is not needed,
>> you can do it through an init script.
>>
>
> They are really two different things: config options like
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS and CONFIG_SLUB_DEBUG_ON are shortcuts
> for command line options when you want the _default_ behavior to be
> specified.  They could easily be done on the command line just as they can
> be done in the config.  They typically have far reaching consequences
> depending on whether they are enabled or disabled and warrant the entry in
> the config file.
>
> This patch, however, is not making the heuristic any easier to work with;
> in fact, if the default were ever changed or the value is changed on your
> kernel, then certain kernels will have THP enabled by default and others
> will not.  That's why I suggested an override command line option like
> transparent_hugepage=force to ignore any disabling heursitics either
> present or future.

Actually, if we move this out of kernel, to user-space, everything
you worried will be solved by just changing the user-space code.
Just add the following pseudo code into your init script,

if [ $total_memory -lt 512 ]
then
	echo never > /sys/kernel/mm/transparent_hugepage/enabled
fi

BTW, "=force" makes people confused with "=always", like "=never"
actually means "=disabled".

>
>> If you were right, the 512M limit is not needed neither, you have
>> transparent_hugepage=never boot parameter and do the check of
>> 512M later in an init script. (Actually, moving the 512M check to
>> user-space is really more sane to me.)
>>
>
> It's quite obvious that the default behavior intended by the author is
> that it is defaulted off for systems with less than 512M of memory.
> Obfuscating that probably isn't a very good idea, but I'm always in favor
> of command lines that allow users to override settings when they really do
> know better.

The better way to express this is to add one line in Kconfig help said
"Please set CONFIG_THP_NEVER=y when you have less than 512M memory",
rather than enforcing a decision in code.

 From either aspect, I don't think the current 512M check code in kernel
is a good thing.

Thanks.
