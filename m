Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab0IOOxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:53:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42165 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753350Ab0IOOxP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:53:15 -0400
MIME-Version: 1.0
In-Reply-To: <20100916001232.0c496b02@lilo>
References: <20100915104855.41de3ebf@lilo> <4C90A6C7.9050607@redhat.com> <20100916001232.0c496b02@lilo>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Sep 2010 07:52:39 -0700
Message-ID: <AANLkTikkAs5jUPhsq5=_Efv-MbbfCNmT10rcV6VUc54D@mail.gmail.com>
Subject: Re: [RFC][PATCH] Cross Memory Attach
To: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 7:42 AM, Christopher Yeoh <cyeoh@au1.ibm.com> wrote:
> On Wed, 15 Sep 2010 12:58:15 +0200
> Avi Kivity <avi@redhat.com> wrote:
>
>>   On 09/15/2010 03:18 AM, Christopher Yeoh wrote:
>> > The basic idea behind cross memory attach is to allow MPI programs
>> > doing intra-node communication to do a single copy of the message
>> > rather than a double copy of the message via shared memory.
>>
>> If the host has a dma engine (many modern ones do) you can reduce
>> this to zero copies (at least, zero processor copies).
>
> Yes, this interface doesn't really support that. I've tried to keep
> things really simple here, but I see potential for increasing
> level/complexity of support with diminishing returns:

I think keeping things simple is a good goal. The vmfd() approach
might be worth looking into, but your patch certainly is pretty simple
as-is.

That said, it's also buggy. You can't just get a task and then do

  down_read(task->mm->mmap_sem)

on it. Not even if you have a refcount. The mm may well go away. You
need to do the same thing "get_task_mm()" does, ie look up the mm
under task_lock, and get a reference to it. You already get the
task-lock for permission testing, so it looks like doing it there
would likely work out.

> 3. ability to map part of another process's address space directly into
>   the current one. Would have setup/tear down overhead, but this would
>   be useful specifically for reduction operations where we don't even
>   need to really copy the data once at all, but use it directly in
>   arithmetic/logical operations on the receiver.

Don't even think about this. If you want to map another tasks memory,
use shared memory. The shared memory code knows about that. The races
for anything else are crazy.

                   Linus
