Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1DORiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:38:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37379 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab1DORiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:38:23 -0400
Subject: [RFC][PATCH 0/3] track pte pages and use in OOM score
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Fri, 15 Apr 2011 10:38:21 -0700
Message-Id: <20110415173821.62660715@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PTE pages are a relatively invisible memory user.  Neither users
nor the kernel have any way of telling how many of them any given
application is using.  Nefarious applications can also
potentially tie up lagre amounts of memory in them:

	foo = malloc(big);
	touch(foo);
	madvise(foo, big, MADV_DONTNEED);

That'll leave you with no RSS for "foo", but the pagetable pages
will still be there.  Do that enough times, and you can
potentially harm the system.  Even worse, the OOM killer will not
necessarily go after such an application since the kernel has no
record of the pages.

For the containers and OpenVZ folks, pte pages are one of the
main consumers of kernel memory.  They should be able to use this
code as well.
