Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab0DLPCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:02:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61567 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab0DLPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:02:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schnell <mschnell@lumino.de>
Subject: Re: atomic RAM ?
Date: Mon, 12 Apr 2010 17:02:35 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "nios2-dev" <nios2-dev@sopc.et.ntust.edu.tw>
References: <4BBD86A5.5030109@lumino.de> <201004091714.04990.arnd@arndb.de> <4BC2EEBD.3070504@lumino.de>
In-Reply-To: <4BC2EEBD.3070504@lumino.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004121702.35237.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/KgtrjvSupXWMl0kl+8PjGimXp12bZG3FOij4
 xmlB4hH7ATy3IWZC6QbYqQkWAYbxbWkSj5y1AK9yFJTGZyQ8PE
 jL05MigeqmwKANxiQYDWA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 April 2010, Michael Schnell wrote:
> > You already need that with a non-SMP system anyway. As Alan explained,
> > futex is only an optimization for a relatively uninteresting case
> > (multi-threaded user applications), you really need to solve this for
> > kernel space first, because the kernel is inherently multi-threaded.
> >   
> I don't see why optimizing for speed and especially latency is
> uninteresting (with embedded systems like the one I'm planning).
> 
> Multi-threaded user applications is exactly the case that is extremely
> interesting to me and that is why I started this discussion. The
> non-SMP-Kernel ( and non-FUTEX)  case already is solved for NIOS
> (supposedly by interrupt disabling). An SMP-Linux is not yet crafted
> (and for me its a lot lower priority than decent user-space
> multithreading, but of course it is a valuable task).

Ok. Your initial post didn't make it clear that this is all you are
looking for. While atomic CPU operations would solve this problem,
you don't really need to make the RAM access itself atomic,
only the instruction flow.

> > If you want to have atomics in user space, why not go all the way and
> > make a small extension to your cache coherency logic to do load-locked/
> > store-conditional as well.
> Of course doing load-locked, store-conditional custom instructions was
> an option I did consider, but as there is no way to access memory
> through cache and MMU with custom instructions, I don't see how this
> could be done, as the current way FUTEX works, the code will define the
> DWORDs to be handled atomically anywhere in the user space memory. Of
> course disabling the cache completely is not an option for a task that
> is aimed to improve user space performance.

Right. So if you cannot implement a 'test-and-set', 'exchange' or
'store-conditional' instruction, I don't think any custom instructions
will help you.

You can probably implement an atomic function in a VDSO though, without
any CPU extensions, I think this has been discussed for blackfin
before. The idea is to let the kernel check if the instruction pointer
is in the critical section of the VDSO while returning to user space.
If it is, the kernel can jump back to the caller of that function
instead of the function itself, and indicate failure so the user can
retry.

	Arnd
