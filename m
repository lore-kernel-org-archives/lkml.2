Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427Ab2GKWY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 18:24:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58441 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab2GKWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 18:24:24 -0400
Date: Wed, 11 Jul 2012 15:24:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Doug Ledford <dledford@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org, "Dmitry V. Levin" <ldv@altlinux.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [RFC, PATCH] CLONE_NEWIPC and exit_group()
Message-Id: <20120711152422.a1f07bd5.akpm@linux-foundation.org>
In-Reply-To: <20120710085034.GA24645@otc-wbsnb-06>
References: <20120626120425.GA10275@otc-wbsnb-06>
	<20120710085034.GA24645@otc-wbsnb-06>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012 11:50:34 +0300
"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com> wrote:

> On Tue, Jun 26, 2012 at 03:04:25PM +0300, Kirill A. Shutemov wrote:
> > Hi,
> > 
> > Patch to move kern_unmount() out of exit_group() code path is below.
> 
> Andrew, do you have any opinion about the patch?

I've forgotten what this is all about and the changelog didn't help.

<finds the thread, reads it>

It doesn't seem very compelling - moving the action into a kernel
thread seems a bit of a hack and by adding more async behaviour it
makes the kernel a more complex and fragile thing.

I'm curious about Dmitry's test:


: #define _GNU_SOURCE
: #include <unistd.h>
: #include <sched.h>
: #include <stdlib.h>
: #include <sys/wait.h>
: 
: int
: main(void)
: {
: 	int i;
: 	for (i = 0; i < 1024; i++) {
: 		if (fork()) {
: 			wait(NULL);
: 			continue;
: 		}
: 		unshare(CLONE_NEWIPC);
: 		exit(0);
: 	}
: 	return 0;
: }
: 
: On 3.4.4 with rcu_barrier patch:
: 0.09user 0.00system 0:32.77elapsed 0%CPU (0avgtext+0avgdata 1472maxresident)k
: 0inputs+0outputs (0major+38017minor)pagefaults 0swaps
: 
: On 3.4.4 with rcu_barrier patch and your new patch:
: 0.00user 0.06system 0:32.77elapsed 0%CPU (0avgtext+0avgdata 1472maxresident)k
: 0inputs+0outputs (0major+38017minor)pagefaults 0swaps

Am I reading that right?  1000 forks take 33 seconds, with basically
all of it just sitting there asleep?  This look quite terrible - what
causes this?

