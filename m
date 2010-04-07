Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932818Ab0DGQfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:35:47 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:41173 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757966Ab0DGQfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:35:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oILXhSly7xbRUA6IBLxvNrHlTBiS9aEhRJPVlu+18EIGSmX4MxvLSbAO7ZOwXDGVF1
         3cB1bknFh7JV1u4Wnp5EL/Y3vIxGzPw2e+bY6ef/Q6R0l+GOpL5l+OjixxKdzOSwx/F0
         9oBjQ3VVsIh13i43i2qItyyQaDmmRX7ui+iIs=
Subject: Re: [PATCH 1/2] rcu: add rcu_access_pointer and
 rcu_dereference_protect
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <26698.1270657193@redhat.com>
References: <1270656035.8141.23.camel@edumazet-laptop>
	 <1270652210.8141.9.camel@edumazet-laptop>
	 <20100407135732.12414.16416.stgit@warthog.procyon.org.uk>
	 <25990.1270654809@redhat.com>  <26698.1270657193@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 18:35:38 +0200
Message-ID: <1270658138.8141.36.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 avril 2010 à 17:19 +0100, David Howells a écrit :

> what is the value of sk->sk_wmem_alloc to the lock context of sk->sk_filter?
> Why would lockdep be interested in sk_wmem_alloc?
> 
> Surely, the assertion that the value of sk->sk_filter is related to
> sk_wmem_alloc being 0 is independent of the need to dereference sk_filter for
> RCU purposes.  So why are these being combined?

Because when sk->sk_filter is eventually written by some thread, this
thread _must_ own a reference on the socket, that is sk_wmem_alloc > 0

So when reading sk->sk_filter, the general condition is : 
- We own the rcu lock 
- But on the particular case of __sk_free(),
  we owned the very last reference to sk (we are going to kfree it), so
nobody can possibly change sk->sk_filter under us.



