Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab1I1IT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 04:19:56 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15354 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1I1ITx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 04:19:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=rJZrAP3vIL/BFMsWY57Q11f/kkossBd3f/B6PFWNbUvGXhzluH8sLjYgO00oECrN0
	tLYJiLmh6l0jBZveAzHgA==
MIME-Version: 1.0
In-Reply-To: <20110928171309.b45c684f.kamezawa.hiroyu@jp.fujitsu.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-7-git-send-email-walken@google.com>
	<20110928171309.b45c684f.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 28 Sep 2011 01:19:50 -0700
Message-ID: <CANN689GFE_hqtndKY6i4ouBBe+gVU_pqOK2HRrc-U1LJMONaXw@mail.gmail.com>
Subject: Re: [PATCH 6/9] kstaled: rate limit pages scanned per second.
From: Michel Lespinasse <walken@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 1:13 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 27 Sep 2011 17:49:04 -0700
> Michel Lespinasse <walken@google.com> wrote:
>
>> Scan some number of pages from each node every second, instead of trying to
>> scan the entime memory at once and being idle for the rest of the configured
>> interval.
>>
>> In addition to spreading the CPU usage over the entire scanning interval,
>> this also reduces the jitter between two consecutive scans of the same page.
>>
>>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>
> Does this scan thread need to be signle thread ?

It tends to perform worse if we try making it multithreaded. What
happens is that the scanning threads call page_referenced() a lot, and
if they both try scanning pages that belong to the same file that
causes the mapping's i_mmap_mutex lock to bounce. Same things happens
if they try scanning pages that belong to the same anon VMA too.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
