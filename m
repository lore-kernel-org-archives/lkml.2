Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab0KSXbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 18:31:47 -0500
Received: from smtp-out.google.com ([74.125.121.35]:8149 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab0KSXbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 18:31:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XFZ+T9Q+zkebzkR7hAI/VO3rg5MA/bhrTrTuBEXWLVwT/6Uo5S3bPEEUj/q8P7aElE
         GnGuDK4YaavKJBqIH5OA==
MIME-Version: 1.0
In-Reply-To: <20101119145442.ddf0c0e8.akpm@linux-foundation.org>
References: <1289996638-21439-1-git-send-email-walken@google.com>
	<1289996638-21439-4-git-send-email-walken@google.com>
	<20101117125756.GA5576@amd>
	<1290007734.2109.941.camel@laptop>
	<AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
	<20101117231143.GQ22876@dastard>
	<20101118133702.GA18834@infradead.org>
	<alpine.LSU.2.00.1011180934400.3210@tigran.mtv.corp.google.com>
	<20101119072316.GA14388@google.com>
	<20101119145442.ddf0c0e8.akpm@linux-foundation.org>
Date: Fri, 19 Nov 2010 15:31:42 -0800
Message-ID: <AANLkTi=N=+hLd7bJZ87mgp0bGnyvT=43yQHBaDFZGTjY@mail.gmail.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering writeback
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 2:54 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 18 Nov 2010 23:23:16 -0800
> Michel Lespinasse <walken@google.com> wrote:
>
>> On Thu, Nov 18, 2010 at 09:41:22AM -0800, Hugh Dickins wrote:
>> > On Thu, 18 Nov 2010, Christoph Hellwig wrote:
>> > > I think it would help if we could drink a bit of the test driven design
>> > > coolaid here. Michel, can you write some testcases where pages on a
>> > > shared mapping are mlocked, then dirtied and then munlocked, and then
>> > > written out using msync/fsync.  Anything that fails this test on
>> > > btrfs/ext4/gfs/xfs/etc obviously doesn't work.
>> > Whilst it's hard to argue against a request for testing, Dave's worries
>> > just sprang from a misunderstanding of all the talk about "avoiding ->
>> > page_mkwrite".  There's nothing strange or risky about Michel's patch,
>> > it does not avoid ->page_mkwrite when there is a write: it just stops
>> > pretending that there was a write when locking down the shared area.
>>
>> So, I decided to test this using memtoy.
>
> Wait.  You *tested* the kernel?
>
> I dunno, kids these days...

Not guilty - I mean, Christoph made me do it !

> Dirtying all that memory at mlock() time is pretty obnoxious.
>
> I'm inclined to agree that your patch implements the desirable
> behaviour: don't dirty the page, don't do block allocation.  Take a
> fault at first-dirtying and do it then.  This does degrade mlock a bit:
> the user will find that the first touch of an mlocked page can cause
> synchronous physical I/O, which isn't mlocky behaviour *at all*.  But
> we have to be able to do this anyway - whenever the kupdate function
> writes back the dirty pages it has to mark them read-only again so the
> kernel knows when they get redirtied.

Glad to see that we seem to be coming to an agreement here.

> So all that leaves me thinking that we merge your patches as-is.  Then
> work out why users can fairly trivially use mlock to hang the kernel on
> ext2 and ext3 (and others?)

I would say the hang is not even mlock related - you see without it
also. All you need is mmap a large file with holes and write fault
pages until you run out of disk space. At that point additional write
faults wait for a writeback that can never complete. Sysadmin can
however kill -9 such processes and/or free some space, though.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
