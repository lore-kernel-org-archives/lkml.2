Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0DLJ6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 05:58:31 -0400
Received: from ns2.intersolute.de ([193.110.43.67]:54075 "EHLO
	ns2.intersolute.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab0DLJ6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 05:58:30 -0400
Message-ID: <4BC2EEBD.3070504@lumino.de>
Date: Mon, 12 Apr 2010 11:58:21 +0200
From: Michael Schnell <mschnell@lumino.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       nios2-dev <nios2-dev@sopc.et.ntust.edu.tw>
Subject: Re: atomic RAM ?
References: <4BBD86A5.5030109@lumino.de> <201004081615.01151.arnd@arndb.de> <4BBEECC8.10005@lumino.de> <201004091714.04990.arnd@arndb.de>
In-Reply-To: <201004091714.04990.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 05:14 PM, Arnd Bergmann wrote:
>
>> I don't see how (to do FUTEX) a hashlock can be implemented in a way
>> that we stay in user mode when locking it and - if it's already locked -
>> we do a Kernel call for waiting on it being unlocked by another thread.
>> (This is what FUTEX does.)
>>     
> You wouldn't. For user space, you can always do a syscall for atomic
> operations, like some architectures do that lack atomic instructions.
>   
Of course. This is what pthread_mutex_...() does, if the arch does not
provide the appropriate atomic functions and/or does not have FUTEX. But
this discussion is about fast thread communication, thus avoiding
syscalls is essential to me..
> You already need that with a non-SMP system anyway. As Alan explained,
> futex is only an optimization for a relatively uninteresting case
> (multi-threaded user applications), you really need to solve this for
> kernel space first, because the kernel is inherently multi-threaded.
>   
I don't see why optimizing for speed and especially latency is
uninteresting (with embedded systems like the one I'm planning).

Multi-threaded user applications is exactly the case that is extremely
interesting to me and that is why I started this discussion. The
non-SMP-Kernel ( and non-FUTEX)  case already is solved for NIOS
(supposedly by interrupt disabling). An SMP-Linux is not yet crafted
(and for me its a lot lower priority than decent user-space
multithreading, but of course it _is_ a valuable task).
> If you want to have atomics in user space, why not go all the way and
> make a small extension to your cache coherency logic to do load-locked/
> store-conditional as well.
Of course doing load-locked, store-conditional custom instructions was
an option I did consider, but as there is no way to access memory
through cache and MMU with custom instructions, I don't see how this
could be done, as the current way FUTEX works, the code will define the
DWORDs to be handled atomically anywhere in the user space memory. Of
course disabling the cache completely is not an option for a task that
is aimed to improve user space performance.
>  As far as I understand, NIOS-2 does not
> come with a coherency logic normally, so you must already have made some
> extensions on that level in order to make the dcache coherent.
>   
The user space cache coherency is *somehow* provided by the current
(non-SMP) Kernel. I understand that special considerations only are
necessary when the MMU tables are modified. There is no SMP Kernel for
NIOS yet. I in fact have no idea how cache coherency can/will be handled
in the SMP case.
> Typically, there is one dcache line that you can mark as exclusive-locked,
> which behaves just like exclusive, except that the store-conditional
> instruction only performs a store to an exclusive-locked cache line,
> setting a condition code if the cache line has transitioned to another
> state in the meantime.
>   
AFAIK, the current NIOS cache hardware design does not provide for
features such as external invalidating of cache lines. So those who
start the NIOS SMP project will need to deal with that by having Altera
enhance the NIOS design and/or use additional "hardware" outside of the
CPU/cache/MMU block.

Thanks,
-Michael
