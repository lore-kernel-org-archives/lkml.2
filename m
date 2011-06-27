Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab1F0Q5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:57:05 -0400
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:43050 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964Ab1F0QzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:55:05 -0400
X-Greylist: delayed 390 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 Jun 2011 12:55:03 EDT
Date: Mon, 27 Jun 2011 11:48:25 -0500
From: Shawn Bohrer <sbohrer@rgmadvisors.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Change in functionality of futex() system call.
Message-ID: <20110627164825.GB2095@BohrerMBP.rgmadvisors.com>
References: <1307373819.3098.40.camel@edumazet-laptop>
 <1307376672.2322.167.camel@twins>
 <1307376989.2322.171.camel@twins>
 <1307377349.3098.65.camel@edumazet-laptop>
 <1307377782.2322.183.camel@twins>
 <1307378564.3098.67.camel@edumazet-laptop>
 <1307379926.2322.219.camel@twins>
 <1307380297.3098.74.camel@edumazet-laptop>
 <1307384634.2497.736.camel@laptop>
 <1307384871.3098.98.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307384871.3098.98.camel@edumazet-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Eric,

I have one question below.

On Mon, Jun 06, 2011 at 08:27:51PM +0200, Eric Dumazet wrote:
> Le lundi 06 juin 2011 à 20:23 +0200, Peter Zijlstra a écrit :
> 
> > 
> > That's really not the point, what do we do when the COW happens during
> > the FUTEX_WAIT? At that point the process vaddr changes mapping and we
> > cannot continue the wait on the old page, since that would expose
> > invisible information, nor can we switch to the new page since we queued
> > on the old page.
> > 
> > Therefore we have to force the COW and queue on the private copy, it
> > really is the only semi sane semantic.
> 
> The point is we dont necessarly have to COW the page. If you attempt
> this COW, you shoot on user that did not expect to have a COW.
> 
> Take this program : COW is not allowed, still this worked on 2.6.18 (it
> waits until another process change the value in file and call
> futex_wait())
> 
> Using PROT_READ | PROT_WRITE instead of PROT_READ was OK too.

Did this actually work on 2.6.18?  I'm testing on RHEL 5 and both
PROT_READ, and PROT_READ|PROT_WRITE with MAP_PRIVATE wait forever.
I'm not sure if that is from Red Hat backports or not.

Peter's change on top of 3.0 actually make the PROT_READ MAP_PRIVATE
case work, those as you point out below PROT_READ|PROT_WRITE waits
forever.

> (If we use PROT_READ | PROT_WRITE, then after your patch, program doesnt
> work anymore since this process gets a private page after your hidden
> COW : It'll wait forever)
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


---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.

