Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1FFQQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:16:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:53324 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab1FFQQo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:16:44 -0400
Subject: Re: Change in functionality of futex() system call.
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1307376672.2322.167.camel@twins>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 18:16:29 +0200
Message-ID: <1307376989.2322.171.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-06 at 18:11 +0200, Peter Zijlstra wrote:
> On Mon, 2011-06-06 at 17:23 +0200, Eric Dumazet wrote:
> > Le lundi 06 juin 2011 à 09:28 -0500, David Oliver a écrit :
> > > Hello,
> > > 
> > > The functionality of the futex() system call appears to have changed
> > > between versions 2.6.18 and 2.6.32.28.
> > > 
> > > Specifically, performing a FUTEX_WAIT on a read-only mapped location
> > > results in an EFAULT. Although other operations, such as FUTEX_WAKE,
> > > are only meaningful for writable locations, FUTEX_WAIT is useful for
> > > processes with read-only access to a memory-mapped file.
> > > 
> > > The code below illustrates the changed behavior (each of the EXPECT
> > > operations succeed on the older kernel, the ASSERTs pass in each
> > > case), assuming the file /tmp/futex_test exists and contains int(42).
> > > 
> > > With the older kernel, the syscall() suspends until another process
> > > changes the file and issues a FUTEX_WAKE, whereas the new behavior is
> > > for an EFAULT error, independent of the file contents.
> > > 
> > > Let me know if you need further clarification.
> > > 
> > > Cheers!
> > > 
> > > David Oliver.
> > > 
> > > 
> > > #include <errno.h>
> > > #include <fcntl.h>
> > > #include <stdint.h>
> > > typedef uint32_t u32;   // for futex.h
> > > #include <linux/futex.h>
> > > #include <sys/mman.h>
> > > #include <sys/syscall.h>
> > > #include <unistd.h>
> > > #include "gtest/gtest.h" // test framework to illustrate issue.
> > > 
> > > 
> > > TEST(Futex, futex_in_read_only_file_is_ok) {
> > >   int fd = open("/tmp/futex_test", O_RDONLY);
> > >   ASSERT_GE(fd, 0);
> > >   int* futex = static_cast<int *>(mmap(0, sizeof(int), PROT_READ,
> > > MAP_SHARED, fd, 0));
> > >   ASSERT_NE((int *)(0), futex);
> > > 
> > >   int rc = syscall(SYS_futex, futex, FUTEX_WAIT, 42, 0, 0, 0);
> > > 
> > >   EXPECT_NE(-1, rc);              // fails.
> > >   if (rc == -1) {
> > >       EXPECT_NE(errno, EFAULT);   // fails.
> > >   }
> > > }
> > > 
> > 
> > Right you are, this came from commit 7485d0d3758e8e6491a5 (futexes:
> > Remove rw parameter from get_futex_key()) in 2.6.33
> > 
> > commit 7485d0d3758e8e6491a5c9468114e74dc050785d
> > Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Date:   Tue Jan 5 16:32:43 2010 +0900
> > 
> >     futexes: Remove rw parameter from get_futex_key()
> >     
> >     Currently, futexes have two problem:
> >     
> >     A) The current futex code doesn't handle private file mappings properly.
> >     
> >     get_futex_key() uses PageAnon() to distinguish file and
> >     anon, which can cause the following bad scenario:
> >     
> >       1) thread-A call futex(private-mapping, FUTEX_WAIT), it
> >          sleeps on file mapping object.
> >       2) thread-B writes a variable and it makes it cow.
> >       3) thread-B calls futex(private-mapping, FUTEX_WAKE), it
> >          wakes up blocked thread on the anonymous page. (but it's nothing)
> >     
> >     B) Current futex code doesn't handle zero page properly.
> > 
> >     Read mode get_user_pages() can return zero page, but current
> >     futex code doesn't handle it at all. Then, zero page makes
> >     infinite loop internally.
> >     
> >     The solution is to use write mode get_user_page() always for
> >     page lookup. It prevents the lookup of both file page of private
> >     mappings and zero page.
> >     
> >     Performance concerns:
> >     
> >     Probaly very little, because glibc always initialize variables
> >     for futex before to call futex(). It means glibc users never see
> >     the overhead of this patch.
> >     
> >     Compatibility concerns:
> >     
> >     This patch has few compatibility issues. After this patch,
> >     FUTEX_WAIT require writable access to futex variables (read-only
> >     mappings makes EFAULT). But practically it's not a problem,
> >     glibc always initalizes variables for futexes explicitly - nobody
> >     uses read-only mappings.
> 
> Urgh,. maybe something like the below but with more conditionals that
> enable the extra logic only for FUTEX_WAIT..
> 
> The idea is to try a RO gup() when the RW gup() fails so as not to slow
> down the common path of writable anonymous maps and bail when we used
> the RO path on anonymous memory.
> 
> ---
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fe28dc2..11f2ad1 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -234,7 +234,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  	unsigned long address = (unsigned long)uaddr;
>  	struct mm_struct *mm = current->mm;
>  	struct page *page, *page_head;
> -	int err;
> +	int err, ro = 0;
>  
>  	/*
>  	 * The futex address must be "naturally" aligned.
> @@ -262,6 +262,10 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  
>  again:
>  	err = get_user_pages_fast(address, 1, 1, &page);
> +	if (err == -EFAULT) {
> +		err = get_user_pages_fast(address, 1, 0, &page);
> +		ro = 1;
> +	}
>  	if (err < 0)
>  		return err;
>  
> @@ -316,6 +320,11 @@ again:
>  	 * the object not the particular process.
>  	 */
>  	if (PageAnon(page_head)) {
> +		if (ro) {
> +			err = -EFAULT;
> +			goto out;
> +		}
> +
>  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
>  		key->private.mm = mm;
>  		key->private.address = address;
> @@ -327,9 +336,10 @@ again:
>  
>  	get_futex_key_refs(key);
>  
> +out:
>  	unlock_page(page_head);
>  	put_page(page_head);
> -	return 0;
> +	return err;
>  }
>  
>  static inline void put_futex_key(union futex_key *key)
> 

Hmm, wouldn't that still be susceptible to the zero-page thing if: we
create a writable private file map of a sparse file, touch a page and
then remap the thing RO?



