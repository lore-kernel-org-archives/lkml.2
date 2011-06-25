Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab1FYAAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 20:00:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:11462 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab1FYAAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 20:00:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,422,1304319600"; 
   d="scan'208";a="17959487"
Message-ID: <4E052531.3010603@linux.intel.com>
Date: Fri, 24 Jun 2011 17:00:49 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>	 <1307373819.3098.40.camel@edumazet-laptop>	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>	 <1307377349.3098.65.camel@edumazet-laptop>	 <1307377782.2322.183.camel@twins>	 <1307378564.3098.67.camel@edumazet-laptop>	 <1307379926.2322.219.camel@twins>	 <1307380297.3098.74.camel@edumazet-laptop>	 <1307384634.2497.736.camel@laptop> <1307384871.3098.98.camel@edumazet-laptop>
In-Reply-To: <1307384871.3098.98.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

I'm finally getting time to review this in depth and try to help Shawn
get his fix upstream. Trying to make sure I have all the facets of this
straight in my head... or on paper at least ;-)

On 06/06/2011 11:27 AM, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 20:23 +0200, Peter Zijlstra a écrit :
> 
>>
>> That's really not the point, what do we do when the COW happens during
>> the FUTEX_WAIT? At that point the process vaddr changes mapping and we
>> cannot continue the wait on the old page, since that would expose
>> invisible information, nor can we switch to the new page since we queued
>> on the old page.
>>
>> Therefore we have to force the COW and queue on the private copy, it
>> really is the only semi sane semantic.
> 
> The point is we dont necessarly have to COW the page. If you attempt
> this COW, you shoot on user that did not expect to have a COW.
> 
> Take this program : COW is not allowed, still this worked on 2.6.18 (it
> waits until another process change the value in file and call
> futex_wait())
> 
> Using PROT_READ | PROT_WRITE instead of PROT_READ was OK too.
> 
> (If we use PROT_READ | PROT_WRITE, then after your patch, program doesnt
> work anymore since this process gets a private page after your hidden
> COW : It'll wait forever)


As I understand MMAP(2), this is working due to undefined behavior as
Stephen pointed out earlier:

"It is unspecified whether changes made to the file after the     mmap()
call are visible in the mapped region."

I don't think we are under any obligation to keep that working.

--
Darren

> 
> #include <errno.h>
> #include <fcntl.h>
> #include <stdint.h>
> typedef uint32_t u32;   // for futex.h
> #include <linux/futex.h>
> #include <sys/mman.h>
> #include <sys/syscall.h>
> #include <unistd.h>
> 
> 
> int main(int argc, char *argv[]) {
>  	int fd, *futex, rc, val = 42;
> 
> 	fd = open("/tmp/futex_test", O_RDWR|O_CREAT, 0644);
> 	write(fd, &val, 4);
> 	futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE, fd, 0);
> 	rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, 0, 0, 0);
> 	printf("rc=%d errno=%d\n", rc, errno);
> }
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
