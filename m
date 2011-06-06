Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757312Ab1FFSLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 14:11:43 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46713 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987Ab1FFSLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 14:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QVyjBOtgPtKlZ0C9PZ8ms0YzlSeU0RQgoLcLrclzKZkODYCHefCPcxUjagu+ZfzMO4
         4Cjq+NWaaUhRMMNtlMp3yZIYg5iNH6vgpgWzak3GNyIG8PFZtfxmEKPcPuDj2OwCSXkE
         PXBJDIgyhWV8mVbxt4kz81E7tmt5XP2I1FZ2o=
Subject: Re: Change in functionality of futex() system call.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        David Oliver <david@rgmadvisors.com>, linux-kernel@vger.kernel.org,
        Shawn Bohrer <sbohrer@rgmadvisors.com>,
        Zachary Vonler <zvonler@rgmadvisors.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4DED1421.5000300@linux.intel.com>
References: <BANLkTinA9h=84gjYhus3EsNFL8tOUBe1jQ@mail.gmail.com>
	 <1307373819.3098.40.camel@edumazet-laptop>
	 <1307376672.2322.167.camel@twins>  <1307376989.2322.171.camel@twins>
	 <1307377349.3098.65.camel@edumazet-laptop>
	 <1307377782.2322.183.camel@twins>
	 <1307378564.3098.67.camel@edumazet-laptop>
	 <4DED1421.5000300@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Jun 2011 20:11:38 +0200
Message-ID: <1307383898.3098.90.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 06 juin 2011 à 10:53 -0700, Darren Hart a écrit :
> 

> If I understand the problem correctly, RO private mapping really doesn't
> make any sense and we should probably explicitly not support it, while
> special casing the RO shared mapping in support of David's scenario.
> 

We supported them in 2.6.18 kernels, apparently. This might sounds
stupid but who knows ?

> > 
> > In David Oliver case, this is needed : He wants to catch a change in a
> > file/memory region written by another process.
> 
> But with shared mapping and shared futexes. He just needs the ability to
> FUTEX_WAIT on a RO mapping. Or is that what you were saying?
> 

I am saying that in David Oliver case, he sure uses a MAP_SHARED ro
mapping.

Now, what if other software uses a MAP_PRIVATE ro mapping ?

It was working in previous kernels as well.

We can say its stupid, but IMHO its not.

In other words, this program should work, if process never touches
(writes) into first page.

This program on previous kernels gave :
rc=-1 errno=11
(allowing to wait for a value change and a futex_WAKE)

With new kernel :
rc=-1 errno=14  [ no sleep allowed ]

#include <errno.h>
#include <fcntl.h>
#include <stdint.h>
typedef uint32_t u32;   // for futex.h
#include <linux/futex.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>


int main() {
 	int fd, *futex, rc;

	fd = open("/tmp/futex_test", O_RDWR|O_CREAT, 0644);
	write(fd, "\1\1\1\1", 4);
	futex = (int *)mmap(0, sizeof(int), PROT_READ, MAP_PRIVATE, fd, 0);
	rc = syscall(SYS_futex, futex, FUTEX_WAIT, 42, 0, 0, 0);
	printf("rc=%d errno=%d\n", rc, errno);
}


