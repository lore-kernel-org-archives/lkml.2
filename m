Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab0F1Bsw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 21:48:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:34004 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab0F1Bsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 21:48:51 -0400
Subject: kmem_cache_destroy() badness with SLUB
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-mm@kvack.org
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Jun 2010 11:31:41 +1000
Message-ID: <1277688701.4200.159.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

Internally, I'm hitting a little "nit"...

sysfs_slab_add() has this check:

	if (slab_state < SYSFS)
		/* Defer until later */
		return 0;

But sysfs_slab_remove() doesn't.

So if the slab is created -and- destroyed at, for example, arch_initcall
time, then we hit a WARN in the kobject code, trying to dispose of a
non-existing kobject.

Now, at first sight, just adding the same test to sysfs_slab_remove()
would do the job... but it all seems very racy to me.

I don't understand in fact how this slab_state deals with races at all. 

What prevents us from hitting slab_sysfs_init() at the same time as
another CPU deos sysfs_slab_add() ? How do that deal with collisions
trying to register the same kobject twice ? Similar race with remove...

Shouldn't we have a mutex around those guys ?

Cheers,
Ben.


