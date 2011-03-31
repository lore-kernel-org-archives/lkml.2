Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab1CaTwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:52:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44400 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab1CaTwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:52:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=FZI4eBVCeakGvICxRHFhzkrDDFv7xbA6IRCOE+xydkHaSFo/N1vf+VUJghW/6b11X6
         VMgqfZjcMYbAuLK+3ogGMt6W7XZnNhhD0btTbNyIwvpRz335ghIOB4sZFcjGCNwYh6rM
         jErnYj8z+5L/xkp0g4gsxkkIeJP8B6Y8aIgj4=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Steven Rostedt" <rostedt@goodmis.org>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Johan MOSSBERG" <johan.xx.mossberg@stericsson.com>,
        "Mel Gorman" <mel@csn.ul.ie>, "Pawel Osciak" <pawel@osciak.com>
Subject: Re: [PATCH 05/12] mm: alloc_contig_range() added
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-6-git-send-email-m.szyprowski@samsung.com>
 <1301587361.31087.1040.camel@nimitz> <op.vs7umufd3l0zgt@mnazarewicz-glaptop>
 <20110331192821.GF14441@home.goodmis.org>
Date: Thu, 31 Mar 2011 21:52:26 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vs735nki3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110331192821.GF14441@home.goodmis.org>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 21:28:21 +0200, Steven Rostedt wrote:
> WARN_ON() should never do anything but test. That ret++ does not belong
> inside the WARN_ON() condition. If there are other locations in the
> kernel that do that, then those locations need to be fixed.

Testing implies evaluating, so if we allow:

     if (++i == end) { /* ... */ }

I see no reason why not to allow:

     if (WARN_ON(++i == end)) { /* ... */ }

In both cases the condition is tested.

>> On Thu, 2011-03-31 at 15:16 +0200, Marek Szyprowski wrote:
>>> +       ret = 0;
>>> +       while (!PageBuddy(pfn_to_page(start & (~0UL << ret))))
>>> +               if (WARN_ON(++ret >= MAX_ORDER))
>>> +                       return -EINVAL;

> On Thu, Mar 31, 2011 at 09:02:41AM -0700, Dave Hansen wrote:
>> In any case, please pull the ++ret bit out of the WARN_ON().  Some
>> people like to do:
>>
>> #define WARN_ON(...) do{}while(0)
>>
>> to save space on some systems.

On Thu, 31 Mar 2011 21:26:50 +0200, Steven Rostedt wrote:
> That should be fixed, as the if (WARN_ON()) has become a standard in
> most of the kernel. Removing WARN_ON() should be:
>
> #define WARN_ON(x) ({0;})

This would break a lot of code which expect that testing to take place.
Also see <http://lxr.linux.no/linux+*/include/asm-generic/bug.h#L108>.

> But I agree, that there should be no "side effects" inside a WARN_ON(),
> which that "++ret" is definitely one.

Thus I don't really agree with this point.

At any rate, I don't really care.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
