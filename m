Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab0DLMqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:46:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151Ab0DLMqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:46:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100412122745.GC28208@flint.arm.linux.org.uk>
References: <20100412122745.GC28208@flint.arm.linux.org.uk> <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
To: Russell King <rmk@arm.linux.org.uk>
Cc: dhowells@redhat.com, David VomLehn <dvomlehn@cisco.com>,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
Date: Mon, 12 Apr 2010 13:45:27 +0100
Message-ID: <25356.1271076327@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk@arm.linux.org.uk> wrote:

> Can you explain why you want this?
> 
> I'm wondering about the value of saving the registers; normally when a panic
> occurs, it's because of a well defined reason, and not because something
> went wrong in some CPU register; to put it another way, a panic() is a
> more controlled exception than a BUG() or a bad pointer dereference.

+1.

I found in FS-Cache and CacheFiles that often the things I most wanted to know
when I had something of the form:

	if (A == B)
		BUG();

was a and b, so I made the following macro:

	#define ASSERTCMP(X, OP, Y)					\
	do {								\
		if (unlikely(!((X) OP (Y)))) {				\
			printk(KERN_ERR "\n");				\
			printk(KERN_ERR "AFS: Assertion failed\n");	\
			printk(KERN_ERR "%lu " #OP " %lu is false\n",	\
			       (unsigned long)(X), (unsigned long)(Y));	\
			printk(KERN_ERR "0x%lx " #OP " 0x%lx is false\n", \
			       (unsigned long)(X), (unsigned long)(Y));	\
			BUG();						\
		}							\
	} while(0)

which I could then call like this:

	ASSERTCMP(A, ==, B);

and if the assertion failed, it prints A and B explicitly.  This is much
easier than trying to pick the values out of a register dump, especially as
the compiler may be free to clobber A or B immediately after testing them.

David
