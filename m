Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab0DGQ33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:29:29 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47179 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab0DGQ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:29:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Hr8DHLNxtcCKILEHGAvcxnCjPWjf2arjq2bNBu3FrON+HmdxB1GkkSSO10yG7lw4gI
         Er2z7uNI5R8PGmub8S0nbxAip+qB/GQzpfkYI33EMZjaAzWCBPf7J9nx5PkPMUspD/m+
         E7NopS+2JCK5xEI3wfranSQa8PPlizwibVGHY=
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
Date: Wed, 07 Apr 2010 18:29:17 +0200
Message-ID: <1270657757.8141.30.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 avril 2010 à 17:19 +0100, David Howells a écrit :

> Why not:
> 
> 	ASSERT(atomic_read(&sk->sk_wmem_alloc) == 0);
> 	filter = rcu_dereference(sk->sk_filter);
> 
> This is much clearer, and you're not combining an unrelated assertion with the
> RCU dereference.

1) Because we want the check being done only when CONFIG_PROVE_RCU is
set.

2) Because rcu_dereference() default condition is : 'Am I owning
rcu_read_lock() or equivalent'. 
In this context, I am _not_ owning rcu lock, so we will trigger a
warning.


So this is best done as is :)

I personally find this very clear and clean, this is why I acked Paul
patch :)

If we were 100% sure testing sk_wmem_alloc is not necessary, we would
have put :

filter = rcu_dereference_check(sk->sk_filter, 1);



