Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab0HTQDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 12:03:50 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:12402 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752755Ab0HTQDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 12:03:47 -0400
X-Greylist: delayed 11319 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Aug 2010 12:03:47 EDT
From: Ian Campbell <ijc@hellion.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
In-Reply-To: <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
References: <20100818203143.735033743@clark.site>
	 <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
	 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-6LtsUrp4x0oNqP3Lo6o0"
Date: Fri, 20 Aug 2010 17:02:48 +0100
Message-ID: <1282320168.3170.5450.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard
 page
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=DhNl2YeytwJssBBGe49HJX82LNDFEEVkpVB34RXKaPo= c=1 sm=0 a=isDwiucj6PoA:10 a=AZfGcq7nAAAA:8 a=sDhpR5-PNnBMExrf8zoA:9 a=rYqF4uPi3lymanjBROoA:7 a=BehrsqOfbuK1IPNGs6apI9G-FbcA:4 a=QEXdDO2ut3YA:10 a=N3JbSJf1TJndABtr:21 a=EMtQXZlQisIDhhzG:21 a=QcP-WqvZ55I9Y53hEysA:9 a=wKD5anaGGekg8zW0CasA:7 a=jCC3ikCXJ8jsJVzrv74kcfjBm_0A:4 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6LtsUrp4x0oNqP3Lo6o0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Fri, 2010-08-20 at 08:54 -0700, Linus Torvalds wrote:
> On Fri, Aug 20, 2010 at 5:54 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
> >
> > Since we have split the original VMA into 3, shouldn't only the bottom
> > one still have VM_GROWSDOWN set? (how can the top two grow down with the
> > bottom one in the way?) Certainly it seems wrong to enforce a guard page
> > on anything but the bottom VMA (which is what appears to be happening).
> 
> Yes, it does seem like we should teach vma splitting to remove
> VM_GROWSDOWN on all but the lowest mapping.

Agreed, I was just coding that up to check.

Is there any VMA coalescing which we need to worry about? We don't
appear to do anything like that on munlock at least but I didn't look
elsewhere.

FWIW the attached mlock.c exhibits the issue for me. Under 2.6.35 it
takes 1 additional minor fault if you do not give the "lock" option and
0 minor faults if you do give "lock".

Under 2.6.35.2 and 3.6.35.3-rc it works the same without "lock" but with
"lock" under 2.6.35.2 the mlock fails and with 2.6.35.3 it thinks it
succeeds but didn't really and then bus errors.

> > Out of interest how does the guard page interact with processes which do
> > alloca(N*PAGE_SIZE)?
> 
> It's a guard page, not magic. Some architecture ABI's specify that if
> you expand the stack by more than a certain number, you need to touch
> a page in between (for example, I think alpha had that rule), because
> they don't grow the stack automatically by an arbitrary amount. But
> x86 has never had that rule, and you can certainly defeat a guard page
> by simply accessing by much more than a page.
> 
> As far as I'm concerned, the guard page thing is not - and shouldn't
> be thought of - a "hard" feature. If it's needed, it's really a bug in
> user space. But given that there are bugs in user space, the guard
> page makes it a bit harder to abuse those bugs. But it's about "a bit
> harder" rather than anything else.
> 
> IOW, it does _not_ make up for user space that willfully does crazy
> things, and never will.

Thanks, was just curious...

Ian.

--=-6LtsUrp4x0oNqP3Lo6o0
Content-Disposition: attachment; filename="mlock.c"
Content-Type: text/x-csrc; name="mlock.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/mman.h>

#include <sys/time.h>
#include <sys/resource.h>

#define PAGE_SIZE 4096
#define PAGE_MASK (~(PAGE_SIZE-1))

static void do_lock(void *addr, size_t len)
{
      void *laddr = (void *)((unsigned long)addr & PAGE_MASK);
      size_t llen = (len + ((unsigned long)addr - (unsigned long)laddr) +
                     PAGE_SIZE - 1) & PAGE_MASK;
      int e = mlock(laddr, llen);

      printf("locking %p-%p -> %p-%p -> %d\n",
	     addr, addr+len, laddr, laddr+llen, e);
      if (e < 0)
	      exit(1);
}

static void do_test(int lock_it)  __attribute__((noinline));
static void do_test(int lock_it) {
	struct rusage rbefore, rafter;
	struct {
		char pad1[2*PAGE_SIZE];
		unsigned long lock_me;
		char pad2[2*PAGE_SIZE];
	} s;
	unsigned long esp;

	s.pad1[0] = 1;
	s.pad2[2*PAGE_SIZE-1] = 1;

	//memset(&s.pad1, 0, sizeof(s.pad1));
	//memset(&s.pad2, 0, sizeof(s.pad2));

	printf("pad1 at %p-%p\n", &s.pad1[0], &s.pad1[sizeof(s.pad1)-1]);
	printf("LCK  at %p-%p\n", &s.lock_me, &s.lock_me + 1);
	printf("pad2 at %p-%p\n", &s.pad2[0], &s.pad2[sizeof(s.pad2)-1]);
	asm volatile("mov %%esp, %0\n" : "=r" (esp));
	printf("esp: %#lx\n", esp);

	if (lock_it) {
		do_lock(&s.lock_me, sizeof(s.lock_me));
	}

	getrusage(RUSAGE_SELF, &rbefore);

	s.lock_me = 0xdeadbeef;

	getrusage(RUSAGE_SELF, &rafter);

	printf("minor faults: %ld -> %ld\n", rbefore.ru_minflt, rafter.ru_minflt);
	printf("major faults: %ld -> %ld\n", rbefore.ru_majflt, rafter.ru_majflt);
	if (lock_it && (rbefore.ru_minflt != rafter.ru_minflt || rbefore.ru_majflt != rafter.ru_majflt))
		printf("ERROR -- Should not have faulted\n");
}

int main(int argc, char **argv)
{
	do_test(argc > 1 && strcmp(argv[1], "lock") == 0);
	return 0;
}

--=-6LtsUrp4x0oNqP3Lo6o0--

