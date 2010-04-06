Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0DFVNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:13:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab0DFVNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:13:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.1004061236290.3487@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1004061236290.3487@i5.linux-foundation.org> <20100406193134.26429.78585.stgit@warthog.procyon.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, akpm@linux-foundation.org, npiggin@suse.de,
       paulmck@linux.vnet.ibm.com, corbet@lwn.net,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] radix_tree_tag_get() is not as safe as the docs make out
Date: Tue, 06 Apr 2010 22:12:24 +0100
Message-ID: <27737.1270588344@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Looks like a reasonable patch, but the one thing you didn't say is whether 
> there is any code that relies on the incorrectly documented behavior?

Sorry, yes.  I've made an assumption in FS-Cache that I can rely on the result
of radix_tree_tag_get() simply by wrapping it in an rcu_read_lock()'d section.
This has proven not to be so, since the BUG_ON() at line 602 in
lib/radix-tree.c triggered.

I was protecting set/clear/delete from each other, but not protecting get from
set/clear/delete.

> How did you find this? Do we need to fix actual code too? The only user 
> seems to be your fscache/page.c thing, and I'm not seeing any locking 
> except for the rcu locking that is apparently not sufficient.

As mentioned above, someone reported a bug in fscache that led me to this:

	https://www.redhat.com/archives/linux-cachefs/2010-April/msg00013.html

I may need to fix fscache, but I wanted to see if anyone would suggest an
alternate patch that would continue to let me make a test without having to
grab the spinlock first.

I'll update the patch to reflect this, whatever the final patch ends up being.

David
