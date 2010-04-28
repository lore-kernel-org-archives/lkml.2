Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab0D1O7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 10:59:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50640 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab0D1O7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 10:59:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <i2s19f34abd1004280504n5b0eec52h1452a29726841e53@mail.gmail.com>
References: <i2s19f34abd1004280504n5b0eec52h1452a29726841e53@mail.gmail.com> <20100426145928.7855.70221.stgit@warthog.procyon.org.uk>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: The request_key() syscall should link an existing key to the dest keyring
Date: Wed, 28 Apr 2010 15:58:49 +0100
Message-ID: <14312.1272466729@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum <vegard.nossum@gmail.com> wrote:

> 1. Is it correct to return -EINPROGRESS in this case?

Yes - it prevents construct_key_and_link() from going on to call
construct_key().  The key in question is returned in *_key.

However, I don't think I handle other errors coming back from
construct_alloc_key() correctly.

> 2. (Why) Shouldn't the return value of __key_link() be checked?

It should.  In fact, I should probably precheck and preallocate the keyring to
make sure I don't get errors after allocating the new key.

> 3. In __key_link(), shouldn't rcu_dereference() be used when accessing
> keyring->payload.subscriptions?

No.  We have to hold a write lock on the keyring semaphore if we're going to
call __key_link() to add something to it.

We should, however, call rcu_dereference_protected().

You should find a patch for this in your inbox.

David
