Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639Ab0DGOtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 10:49:21 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45209 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932553Ab0DGOtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 10:49:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=suimGPhGnoIiK3Jw2MXupNxNMonR3bCWBvNQGnByWb+kFONQt5X0GWjAV88vgmMdQV
         kk7yxI/zjKlenoTdbhOnJCGhJR6Q7aj3a/pwmsl0oH0QStFuLbJqOGV8s7vbpvnds58S
         FxEBMgxXRlfeEM1zFhpVekW3ith4VLQqBlkr4=
Subject: Re: [PATCH] KEYS: Fix an RCU warning
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, keyrings@linux-nfs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100407141409.15200.53705.stgit@warthog.procyon.org.uk>
References: <20100407141409.15200.53705.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 07 Apr 2010 16:49:12 +0200
Message-ID: <1270651752.8141.6.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 07 avril 2010 à 15:14 +0100, David Howells a écrit :
> Fix the following RCU warning:

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  security/keys/request_key.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/security/keys/request_key.c b/security/keys/request_key.c
> index 03fe63e..544e932 100644
> --- a/security/keys/request_key.c
> +++ b/security/keys/request_key.c
> @@ -112,10 +112,13 @@ static int call_sbin_request_key(struct key_construction *cons,
>  	if (cred->tgcred->process_keyring)
>  		prkey = cred->tgcred->process_keyring->serial;
>  
> -	if (cred->tgcred->session_keyring)
> +	if (cred->tgcred->session_keyring) {
> +		rcu_read_lock();
>  		sskey = rcu_dereference(cred->tgcred->session_keyring)->serial;
> -	else
> +		rcu_read_unlock();
> +	} else {
>  		sskey = cred->user->session_keyring->serial;
> +	}
>  
>  	sprintf(keyring_str[2], "%d", sskey);
>  

This fix is really wrong David.



You should instead do :

rcu_read_lock();
skeyring = rcu_dereference(cred->tgcred->session_keyring);
if (skeyring)
	sskey = sskeyring->serial;
else
	sskey = cred->user->session_keyring->serial;
rcu_read_unlock();



