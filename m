Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab0HQVoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:44:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42261
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746Ab0HQVoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:44:03 -0400
Date: Tue, 17 Aug 2010 14:44:20 -0700 (PDT)
Message-Id: <20100817.144420.226783254.davem@davemloft.net>
To: tony.luck@intel.com
Cc: torvalds@linux-foundation.org, walken@google.com, dhowells@redhat.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: tasks getting stuck on mmap_sem?
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com>
References: <20100816.211218.189709876.davem@davemloft.net>
	<AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
	<AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Luck <tony.luck@intel.com>
Date: Tue, 17 Aug 2010 11:24:19 -0700

> On Tue, Aug 17, 2010 at 9:14 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> No. Looks like the rwsem changes broke sparc too. ia64 had some problems too.
> 
> I did have some similar mmap_sem issues - but the combination of
> fixing the types
> of the RWSEM_* defines to be unsigned, and the return value of
> ia64_atomic64_add()
> to be "long" rather than "int" looks to have cleared up the problems I
> was seeing. I
> could generally see the hung processes in less than 10 consecutive
> kernel builds, but
> ran a few thousand builds over the weekend with no issues.

You might be triggering it via threading as well, since make uses
vfork() for running sub-jobs.

> If git is multi-threaded, it may be hitting some different code path
> ... but it isn't trivial
> for me to try this out (my systems are on an isolated lab network segment).

Like you I tried fixing atomic64, but as I mentioned it turns out
sparc64 (like powerpc) always uses a 32-bit 'int' semaphore count.

I thought perhaps that for some reason the rwsem generic code had
a dependency on 'long' so I switched sparc64's rwsems over to 'long'
counters last night too, but I still get the problem.

Even reverting the rwsem commit that added the "<" test didn't fix
things, so now I'm simply going to bisect.
