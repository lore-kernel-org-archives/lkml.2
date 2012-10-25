Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2JYWXn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 18:23:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab2JYWXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 18:23:39 -0400
Date: Thu, 25 Oct 2012 15:23:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Stefani Seibold <stefani@seibold.net>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: build warnings after merge of the akpm tree
Message-Id: <20121025152337.7f14919d.akpm@linux-foundation.org>
In-Reply-To: <508948de.01dc440a.58ed.ffffff17SMTPIN_ADDED@mx.google.com>
References: <20121025142854.1924363d6a607004f918ac63@canb.auug.org.au>
	<20121025143044.d21e2c29b16ee2005f93a371@canb.auug.org.au>
	<508948de.01dc440a.58ed.ffffff17SMTPIN_ADDED@mx.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012 22:12:32 +0800
Richard Yang <weiyang@linux.vnet.ibm.com> wrote:

> >drivers/scsi/libiscsi.c: In function 'iscsi_free_task':
> >drivers/scsi/libiscsi.c:507:2: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi.c: In function 'iscsi_pool_init':
> >drivers/scsi/libiscsi.c:2510:3: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi.c: In function 'iscsi_conn_setup':
> >drivers/scsi/libiscsi.c:2881:2: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi.c: In function 'iscsi_conn_teardown':
> >drivers/scsi/libiscsi.c:2944:2: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_cleanup_task':
> >drivers/scsi/libiscsi_tcp.c:462:3: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi_tcp.c:469:3: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_r2t_rsp':
> >drivers/scsi/libiscsi_tcp.c:570:3: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi_tcp.c:586:3: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi_tcp.c:596:2: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >drivers/scsi/libiscsi_tcp.c: In function 'iscsi_tcp_get_curr_r2t':
> >drivers/scsi/libiscsi_tcp.c:998:5: warning: comparison of distinct pointer types lacks a cast [enabled by default]
> >
> 
> ...
>
> I did a quick check. 
> 
> The root reason is, 
> 1. kfifo_in() second parameter should be type "const void *"
> 2. kfifo_out_locked() second parameter should be type "void *"
> 3. kfifo_in_locked() second parameter should be type "const void *"
> 
> And I am curious about why the original code couldn't detect this type
> mismatch.  

Well, just looking at __cxio_init_resource_fifo():

	u32 entry = 0;
	
	...
	
	kfifo_in(fifo, (unsigned char *) &entry, sizeof(u32));

This is silly - we shouldn't warn about this code.  There is no reason
for the kfifo library code to require that the *caller*'s storage be
const!

kfifo_in() is (or should be) simulating a C function with the interface:

unsigned int kfifo_in(struct kfifo *fifo, const void *buf, size_t n);

This states "this function does not modify the memory at *buf" and it's
perfectly OK for a caller to pass a non-const pointer into kfifo_in(). 
We shouldn't warn about this.

In fact, the __cxio_init_resource_fifo() shouldn't need to cast `buf'
to uchar* either.  The need to add that cast is a shortcoming in the
existing kfifo code.

We should be able to pass *any* pointer, of any type, const or
non-const into code which expects a const void *, without any warning.

And holy cow that code is hard to read :( Why was kfifo_in()
implemented as a macro, anyway?  AFAICT all its args have a known type,
so we could have used a proper C interface, which would have fixed all
this nicely.

Anyway,
include-linux-kfifoh-replace-open-coded-type-check-code-with-typecheck.patch
takes the kfifo typechecking from "too strict" to "far too strict", so
I'll drop that patch.

