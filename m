Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325Ab0EEA77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 20:59:59 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38621 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816Ab0EEA75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 20:59:57 -0400
Date: Tue, 4 May 2010 17:59:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, serue@us.ibm.com,
       keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KEYS: Fix RCU handling in key_gc_keyring()
Message-ID: <20100505005953.GM2639@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100504131610.2015.50934.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100504131610.2015.50934.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 02:16:10PM +0100, David Howells wrote:
> key_gc_keyring() needs to either hold the RCU read lock or hold the keyring
> semaphore if it's going to scan the keyring's list.  Given that it only needs
> to read the key list, and it's doing so under a spinlock, the RCU read lock is
> the thing to use.
> 
> Furthermore, the RCU check added in e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe is
> incorrect as holding the spinlock on key_serial_lock is not grounds for
> assuming a keyring's pointer list can be read safely.  Instead, a simple
> rcu_dereference() inside of the previously mentioned RCU read lock is what we
> want.

As the guilty party in e7b0a61b7929632d36cf052d9e2820ef0a9c1bfe...  ;-)

Acked-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

> Reported-by: Serge E. Hallyn <serue@us.ibm.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  security/keys/gc.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/security/keys/gc.c b/security/keys/gc.c
> index 1990231..a46e825 100644
> --- a/security/keys/gc.c
> +++ b/security/keys/gc.c
> @@ -77,10 +77,10 @@ static bool key_gc_keyring(struct key *keyring, time_t limit)
>  		goto dont_gc;
> 
>  	/* scan the keyring looking for dead keys */
> -	klist = rcu_dereference_check(keyring->payload.subscriptions,
> -				      lockdep_is_held(&key_serial_lock));
> +	rcu_read_lock();
> +	klist = rcu_dereference(keyring->payload.subscriptions);
>  	if (!klist)
> -		goto dont_gc;
> +		goto unlock_dont_gc;
> 
>  	for (loop = klist->nkeys - 1; loop >= 0; loop--) {
>  		key = klist->keys[loop];
> @@ -89,11 +89,14 @@ static bool key_gc_keyring(struct key *keyring, time_t limit)
>  			goto do_gc;
>  	}
> 
> +unlock_dont_gc:
> +	rcu_read_unlock();
>  dont_gc:
>  	kleave(" = false");
>  	return false;
> 
>  do_gc:
> +	rcu_read_unlock();
>  	key_gc_cursor = keyring->serial;
>  	key_get(keyring);
>  	spin_unlock(&key_serial_lock);
> 
