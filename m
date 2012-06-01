Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677Ab2FANIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:08:23 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:38549 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab2FANIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:08:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20424.48827.778644.310736@quad.stoffel.home>
Date: Fri, 1 Jun 2012 09:08:11 -0400
From: "John Stoffel" <john@stoffel.org>
To: Cong Wang <amwang@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Matthew Wilcox <matthew@wil.cx>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [RFC Patch] fs: implement per-file drop caches
In-Reply-To: <1338550337.17012.27.camel@cr0>
References: <1338385120-14519-1-git-send-email-amwang@redhat.com>
	<4FC6393B.7090105@draigBrady.com>
	<1338445233.19369.21.camel@cr0>
	<4FC70FFE.50809@gmail.com>
	<1338466281.19369.44.camel@cr0>
	<4FC7C1CD.7020701@gmail.com>
	<1338550337.17012.27.camel@cr0>
X-Mailer: VM 8.1.2 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Cong" == Cong Wang <amwang@redhat.com> writes:

Cong> On Thu, 2012-05-31 at 15:09 -0400, KOSAKI Motohiro wrote:
>> (5/31/12 8:11 AM), Cong Wang wrote:
>> > On Thu, 2012-05-31 at 02:30 -0400, KOSAKI Motohiro wrote:
>> >> (5/31/12 2:20 AM), Cong Wang wrote:
>> >>> On Wed, 2012-05-30 at 16:14 +0100, Pádraig Brady wrote:
>> >>>> On 05/30/2012 02:38 PM, Cong Wang wrote:
>> >>>>> This is a draft patch of implementing per-file drop caches.
>> >>>>>
>> >>>>> It introduces a new fcntl command  F_DROP_CACHES to drop
>> >>>>> file caches of a specific file. The reason is that currently
>> >>>>> we only have a system-wide drop caches interface, it could
>> >>>>> cause system-wide performance down if we drop all page caches
>> >>>>> when we actually want to drop the caches of some huge file.
>> >>>>
>> >>>> This is useful functionality.
>> >>>> Though isn't it already provided with POSIX_FADV_DONTNEED?
>> >>>
>> >>> Thanks for teaching this!
>> >>>
>> >>> However, from the source code of madvise_dontneed() it looks like it is
>> >>> using a totally different way to drop page caches, that is to invalidate
>> >>> the page mapping, and trigger a re-mapping of the file pages after a
>> >>> page fault. So, yeah, this could probably drop the page caches too (I am
>> >>> not so sure, haven't checked the code in details), but with my patch, it
>> >>> flushes the page caches directly, what's more, it can also prune
>> >>> dcache/icache of the file.
>> >>
>> >> madvise should work. I don't think we need duplicate interface. Moreomover
>> >> madvise(2) is cleaner than fcntl(2).
>> >>
>> >
>> > I think madvise(DONTNEED) attacks the problem in a different approach,
>> > it munmaps the file mapping and by the way drops the page caches, my
>> > approach is to drop the page caches directly similar to what sysctl
>> > drop_caches.
>> >
>> > What about private file mapping? Could madvise(DONTNEED) drop the page
>> > caches too even when the other process is doing the same private file
>> > mapping? At least my patch could do this.
>> 
>> Right. But a process can makes another mappings if a process have enough
>> permission. and if it doesn't, a process shouldn't be able to drop a shared
>> cache.
>> 

Cong> Ok, then this patch is not a dup of madvise(DONTNEED).

>> 
>> > I am not sure if fcntl() is a good interface either, this is why the
>> > patch is marked as RFC. :-D
>> 
>> But, if you can find certain usecase, I'm not against anymore.
>> 

Cong> Yeah, at least John Stoffel expressed his interests on this, as
Cong> a sysadmin. So I believe there are some people need it.

I expressed an interest if there was a way to usefully *find* the
processes that are hogging cache.  Without a reporting mechanism of
cache usage on per-file or per-process manner, then I don't see a
great use for this.  It's just simpler to drop all the caches when you
hit a wall.  

Cong> Now the problem is that I don't find a proper existing utility
Cong> to patch, maybe Pádraig has any hints on this? Could this
Cong> feature be merged into some core utility? Or I have to write a
Cong> new utility for this?

I'd write a new tutorial utility, maybe you could call it 'cache_top'
and have it both show the biggest users of cache, as well as exposing
your new ability to drop the cache on a per-fd basis.

It's really not much use unless we can measure it.

John
