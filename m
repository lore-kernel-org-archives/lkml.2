Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab1AGOKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:10:24 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:55569 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab1AGOKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:10:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH V8 09/13] posix clocks: introduce dynamic clocks
Date: Thu, 6 Jan 2011 20:56:22 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1293820862.git.richard.cochran@omicron.at> <c28004fc5d121c1dd5f842550663fc9d6f55a114.1293820862.git.richard.cochran@omicron.at>
In-Reply-To: <c28004fc5d121c1dd5f842550663fc9d6f55a114.1293820862.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101062056.22423.arnd@arndb.de>
X-Provags-ID: V02:K0:5zC925fxCDbKpYBSylvvKgvF80EJNbWk/ObD2+8FMzb
 YJlF/qb4m868e3GGfQCzoPTK5Pnu0Zlh7CdrJuXTjgod2T+ISF
 U/Z544za9aJftw9L1yZP+SZ4v1bsPBL4BpDO0Zkd7spkFQHcwq
 oM90+1AdwVVNXUtnLRsyK3sU1068vqUqyI8VOCrv/P6boQOnKz
 5k+2YXyXRCXR80h1ZBazQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 December 2010, Richard Cochran wrote:
> This patch adds support for adding and removing posix clocks. The
> clock lifetime cycle is patterned after usb devices. Each clock is
> represented by a standard character device. In addition, the driver
> may optionally implemented custom character device operations.
> 
> The posix clock and timer system calls listed below now work with
> dynamic posix clocks, as well as the traditional static clocks.
> For the performance critical calls (eg clock_gettime) the code path
> from the traditional static clocks is preserved.

Combining the operations structures and using container_of as you did
looks much better than before, but I had something slightly different
in mind:

The way that other subsystems do this is to pass a pointer to the
actual low-level object (struct posix_clock in your case) to the
abstracted functions, while you pass a pointer to the operations
structure. This has the advantage of keeping the definition of
posix_clock private to posix-clock.c, but it is something we do
very rarely.

I can see disadvantages with your approach: You still need to dynamically
allocate the posix_clock in posix_clock_create(), and the operations
structure cannot be const, which is a theoretical security problem
if there is a hole that can replace one of the pointers with a
reference to user memory.

I would recommend changing this to the more common model, where you
passs the (publically defined) struct posix_clock to all operations
and can do something like:

struct my_posix_clock {
	...
	struct posix_clock pclk;
} this_clock = {
	...
	.pclk = {
		.ops = &my_posix_clock_operations,
	}
};

int my_init(void)
{
	return posix_clock_operations_register(&my_posix_clock.pclk);
}

void my_exit(void)
{
	posix_clock_operations_unregister(&my_posix_clock.pclk);
}

It should be just a trivial change and just affect how easy it is for
other people to understand the code if they are already familiar
with other kernel code.

Overall, your series looks really good now, it would be nice if this
could still make it into 2.6.38.

	Arnd

