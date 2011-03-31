Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab1CaWvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 18:51:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52479 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1CaWvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 18:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:organization:message-id:in-reply-to
         :user-agent;
        b=jj928NlbwBr+mARkEoXnUt0Uq97ED+HT+koDYmkX4FI6pKdNz82FhL1O0SHgTeJczf
         FCmnuWr5UtSN5LXKJ5rCk6tuGrJ9nXE8ZoyowOf3DAsD/3m0/Qu9EJc5Bu2G2mUeV9U+
         HP9fldOSUhjmz/DJicDMb9UvPQYH8wAThQFgQ=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Johan MOSSBERG" <johan.xx.mossberg@stericsson.com>,
        "Mel Gorman" <mel@csn.ul.ie>, "Pawel Osciak" <pawel@osciak.com>
Subject: Re: [PATCH 04/12] mm: alloc_contig_freed_pages() added
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-5-git-send-email-m.szyprowski@samsung.com>
 <1301587083.31087.1032.camel@nimitz> <op.vs77qfx03l0zgt@mnazarewicz-glaptop>
 <1301606078.31087.1275.camel@nimitz> <op.vs8awkrx3l0zgt@mnazarewicz-glaptop>
 <1301610411.30870.29.camel@nimitz>
Date: Fri, 01 Apr 2011 00:51:32 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Organization: Google
Message-ID: <op.vs8cf5xd3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1301610411.30870.29.camel@nimitz>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Apr 2011 00:26:51 +0200, Dave Hansen <dave@linux.vnet.ibm.com>  
wrote:

> On Fri, 2011-04-01 at 00:18 +0200, Michal Nazarewicz wrote:
>> On Thu, 31 Mar 2011 23:14:38 +0200, Dave Hansen wrote:
>> > We BUG_ON() in bootmem.  Basically if we try to allocate an early-boot
>> > structure and fail, we're screwed.  We can't keep running without an
>> > inode hash, or a mem_map[].
>> >
>> > This looks like it's going to at least get partially used in drivers,  
>> at
>> > least from the examples.  Are these kinds of things that, if the  
>> driver
>> > fails to load, that the system is useless and hosed?  Or, is it
>> > something where we might limp along to figure out what went wrong  
>> before
>> > we reboot?
>>
>> Bug in the above place does not mean that we could not allocate  
>> memory.  It means caller is broken.
>
> Could you explain that a bit?
>
> Is this a case where a device is mapped to a very *specific* range of
> physical memory and no where else?  What are the reasons for not marking
> it off limits at boot?  I also saw some bits of isolation and migration
> in those patches.  Can't the migration fail?

The function is called from alloc_contig_range() (see patch 05/12) which
makes sure that the PFN is valid.  Situation where there is not enough
space is caught earlier in alloc_contig_range().

alloc_contig_freed_pages() must be given a valid PFN range such that all
the pages in that range are free (as in are within the region tracked by
page allocator) and of MIGRATETYPE_ISOLATE so that page allocator won't
touch them.

That's why invalid PFN is a bug in the caller and not an exception that
has to be handled.

Also, the function is not called during boot time.  It is called while
system is already running.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
