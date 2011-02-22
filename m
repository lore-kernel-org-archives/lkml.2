Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab1BVRPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:15:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:42831 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab1BVRO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:14:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,207,1297065600"; 
   d="scan'208";a="711815054"
Message-ID: <4D63EF18.5080807@linux.intel.com>
Date: Tue, 22 Feb 2011 09:15:04 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Christoph Lameter <cl@linux.com>, Andi Kleen <andi@firstfloor.org>,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, lwoodman@redhat.com, arcange@redhat.com
Subject: Re: [PATCH 3/8] Preserve local node for KSM copies
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-4-git-send-email-andi@firstfloor.org> <alpine.DEB.2.00.1102220945210.16060@router.home> <20110222162011.GD13092@random.random>
In-Reply-To: <20110222162011.GD13092@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/22/2011 8:20 AM, Andrea Arcangeli wrote:
> On Tue, Feb 22, 2011 at 09:47:26AM -0600, Christoph Lameter wrote:
>> On Mon, 21 Feb 2011, Andi Kleen wrote:
>>
>>> Add a alloc_page_vma_node that allows passing the "local" node in.
>>> Use it in ksm to allocate copy pages on the same node as
>>> the original as possible.
>> Why would that be useful? The shared page could be on a node that is not
>> near the process that maps the page. Would it not be better to allocate on
>> the node that is local to the process that maps the page?
> This is what I was trying to understand. To me it looks like this is
> making things worse. Following the "vma" advice like current code

The problem is: most people use local policy and for that the correct node
is the node that the memory got allocated on.

You cannot get that information from the vma because the vma just says
"local"

If you don't use that node the daemon will arbitarily destroy memory 
locality.
In fact this has happened. This is really bad regression caused by THP.

Now full KSM locality is more difficult (obviously you can have a 
conflict), but
keeping it on the original node is still the most predictable. At least 
you won't
make anything worse for that process.

-Andi

