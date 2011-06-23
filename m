Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab1FWD6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:58:35 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:36542 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758599Ab1FWD6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:58:33 -0400
Date: Wed, 22 Jun 2011 22:58:21 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH RFC] futex: Fix regression with read only mappings
Message-ID: <20110623035821.GA2180@BohrerMBP.rgmadvisors.com>
References: <4DF8FFF6.4060000@linux.intel.com>
 <1308770340-21895-1-git-send-email-sbohrer@rgmadvisors.com>
 <4E024D2D.6070308@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E024D2D.6070308@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 01:14:37PM -0700, Darren Hart wrote:
> Hi Shawn,
> 
> Thanks for taking this up. Would you share your testcases as well?

I ran our proprietary application, and our test suite.  Which I
unfortunately can't share.  Our code uses FUTEX_WAIT in shared RO
mappings, and FUTEX_WAKE in shared RW mappings directly via syscalls.
We also use pthread mutexes and pthread conditions as synchronization
objects.

I also hacked up a quick little racy test below just to see what
worked and didn't on 2.6.18, 2.6.38, and with this patch.  However, I
wouldn't consider our application or this little test a very thorough
testing of all of the futex functionality.

#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
#include <linux/futex.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <stdio.h>

void child()
{
        int fd, *futex, rc, val = 42;
        struct timespec ts = {.tv_sec = 2, .tv_nsec = 0 };

        fd = open("/tmp/futex_test", O_RDWR|O_CREAT, 0644);
        write(fd, &val, sizeof(val));
        futex = (int *)mmap(0, sizeof(int), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, &ts, 0, 0);
        printf("Test FUTEX_WAIT RW MAP_SHARED: rc=%d errno=%d\n", rc, errno);
        printf("-----\n");

        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_SHARED, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, &ts, 0, 0);
        printf("Test FUTEX_WAIT RO MAP_SHARED: rc=%d errno=%d\n", rc, errno);
        printf("-----\n");

        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, &ts, 0, 0);
        printf("Test FUTEX_WAIT RO MAP_PRIVATE: rc=%d errno=%d\n", rc, errno);
        printf("-----\n");

        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, &ts, 0, 0);
        printf("Test FUTEX_WAIT RO MAP_PRIVATE: rc=%d errno=%d\n", rc, errno);
        printf("-----\n");

        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, &ts, 0, 0);
        printf("Test FUTEX_WAIT RW MAP_PRIVATE (EXPECT errno=110): rc=%d errno=%d\n", rc, errno);
        printf("-----\n");

        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_SHARED, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAIT, val, &ts, 0, 0);
        printf("Test FUTEX_WAIT RO MAP_SHARED (EXPECT errno=110): rc=%d errno=%d\n", rc, errno);
        printf("-----\n");

        close(fd);
        munmap(futex, sizeof(int));
}

void parent()
{
        int fd, *futex, rc, val = 41;

        sleep(1);
        fd = open("/tmp/futex_test", O_RDWR|O_CREAT, 0644);
        write(fd, &val, sizeof(val));
        futex = (int *)mmap(0, sizeof(int), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAKE, val, 0, 0, 0);
        printf("Test FUTEX_WAKE RW MAP_SHARED: rc=%d errno=%d\n", rc, errno);

        sleep(1);
        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_SHARED, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAKE, val, 0, 0, 0);
        printf("Test FUTEX_WAKE RO MAP_SHARED: rc=%d errno=%d\n", rc, errno);

        sleep(1);
        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAKE, val, 0, 0, 0);
        printf("Test FUTEX_WAKE RW MAP_SHARED: rc=%d errno=%d\n", rc, errno);

        sleep(1);
        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAKE, val, 0, 0, 0);
        printf("Test FUTEX_WAKE RO MAP_PRIVATE: rc=%d errno=%d\n", rc, errno);

        sleep(1);
        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAKE, val, 0, 0, 0);
        printf("Test FUTEX_WAKE RO MAP_PRIVATE (EXPECT rc=0): rc=%d errno=%d\n", rc, errno);

        sleep(2);
        lseek(fd, 0, SEEK_SET);
        write(fd, &val, sizeof(val));
        munmap(futex, sizeof(int));
        futex = (int *)mmap(0, sizeof(int), PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
        rc = syscall(SYS_futex, futex, FUTEX_WAKE, val, 0, 0, 0);
        printf("Test FUTEX_WAKE RW MAP_PRIVATE (EXPECT rc=0): rc=%d errno=%d\n", rc, errno);

        close(fd);
        munmap(futex, sizeof(int));
}


int main(int argc, char *argv[])
{
        pid_t pid;
        int status;

        pid = fork();
        if (pid == -1)
                perror("fork");
        else if (!pid)
                child();
        else if (pid > 0)
                parent();

        wait(&status);
        return 0;
}


> On 06/22/2011 12:19 PM, Shawn Bohrer wrote:
> > commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
> > parameter from get_futex_key()) in 2.6.33 introduced a user-mode
> > regression in that it additionally prevented futex operations on a
> > region within a read only memory mapped file.  For example this breaks
> > workloads that have one or more reader processes doing a FUTEX_WAIT on a
> > futex within a read only shared mapping, and a writer processes that has
> > a writable mapping issuing the FUTEX_WAKE.
> > 
> > This fixes the regression for futex operations that should be valid on
> > RO mappings by trying a RO get_user_pages_fast() when the RW
> > get_user_pages_fast() fails so as not to slow down the common path of
> > writable anonymous maps and bailing when we used the RO path on
> > anonymous memory.
> > 
> > Patch based on Peter Zijlstra's initial patch with modifications to only
> > allow RO mappings for futex operations that need VERIFY_READ access.
> > 
> > Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> > ---
> > 
> > Interestingly this patch also allows doing a FUTEX_WAIT on a RO private
> > mapping.
> 
> I don't see any harm in this.
> 
> >  Where my tests on 2.6.18 show that this used to wait
> > indefinitely.  Performing a FUTEX_WAIT on a RW private mapping waits
> > indefinitely in 2.6.18, 3.0.0, and with this patch applied.  It is
> > unclear to me if this is a good thing or a bug.
> > 
> >  kernel/futex.c |   38 ++++++++++++++++++++++++++------------
> >  1 files changed, 26 insertions(+), 12 deletions(-)
> > 
> > diff --git a/kernel/futex.c b/kernel/futex.c
> > index fe28dc2..e8cd532 100644
> > --- a/kernel/futex.c
> > +++ b/kernel/futex.c
> > @@ -218,6 +218,8 @@ static void drop_futex_key_refs(union futex_key *key)
> >   * @uaddr:	virtual address of the futex
> >   * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
> >   * @key:	address where result is stored.
> > + * @rw:		mapping needs to be read/write (values: VERIFY_READ,
> > + *		VERIFY_WRITE)
> >   *
> 
> 
> I'm OK with this, but ideally I I'd prefer fshared and rw be replaced
> with flags. We already have a FLAGS_SHARED, adding a FLAGS_WRITE would
> be simple, and most call sites could be updated to send the bare flags
> rather than a logical and with FLAGS_SHARED as they do now.

Sure, I think that is a reasonable request.

> >   * Returns a negative error code or 0
> >   * The key words are stored in *key on success.
> > @@ -229,12 +231,12 @@ static void drop_futex_key_refs(union futex_key *key)
> >   * lock_page() might sleep, the caller should not hold a spinlock.
> >   */
> >  static int
> > -get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
> > +get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
> >  {
> >  	unsigned long address = (unsigned long)uaddr;
> >  	struct mm_struct *mm = current->mm;
> >  	struct page *page, *page_head;
> > -	int err;
> > +	int err, ro = 0;
> >  
> >  	/*
> >  	 * The futex address must be "naturally" aligned.
> > @@ -262,6 +264,10 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
> >  
> >  again:
> >  	err = get_user_pages_fast(address, 1, 1, &page);
> > +	if (err == -EFAULT && rw == VERIFY_READ) {
> > +		err = get_user_pages_fast(address, 1, 0, &page);
> 
> I verified this is correct .... we ran into a little trouble a while
> back mixing up the parameters of get_user_pages_fast. This is correct :)
> 
> > +		ro = 1;
> > +	}
> >  	if (err < 0)
> >  		return err;
> >  
> > @@ -316,6 +322,11 @@ again:
> >  	 * the object not the particular process.
> >  	 */
> >  	if (PageAnon(page_head)) {
> > +		if (ro) {
> > +			err = -EFAULT;
> > +			goto out;
> > +		}
> 
> This if block needs a comment as to why RO anonymous pages trigger a
> failure. In fact... I thought you said with this patch FUTEX_WAIT
> waits indefinitely on RO private mappings?  This test suggests that
> it shouldn't. Are you testing this via glibc pthread_mutexes? If so,
> and if I remember correctly, glibc loops forever on -EFAULT here,
> unfortunately.

No with this patch FUTEX_WAIT works with RO private mappings. Pre
7485d0d3758 FUTEX_WAIT on RO private mappings would wait indefinitely.
RW still waits indefinitely both pre 7485d0d3758 and with this patch.

However, I have a confession to make.  That if block was taken from
Peter's initial patch, and I originally thought it was preventing RO
private mappings.  Now I'm not sure what it is doing.  Will PageAnon()
ever return true on a RO private mapping?  Is the page only in
anonymous memory after a COW has taken place?  Sorry this isn't
exactly my area of expertise.

> > +
> >  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
> >  		key->private.mm = mm;
> >  		key->private.address = address;
> > @@ -327,9 +338,11 @@ again:
> >  
> >  	get_futex_key_refs(key);
> >  
> > +	err = 0;
> 
> Shouldn't this be 0 anyway? If it was non-zero, you would have jumped to
> out: earlier, right?

No, gup() should return the number of pages when successful.  Of
course it would be more obvious what was going on here if we cleared
this closer to the call site.

I should be able to send a reworked patch sometime tomorrow.

--
Shawn


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

