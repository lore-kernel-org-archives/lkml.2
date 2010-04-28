Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab0D1MEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:04:40 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:46856 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab0D1MEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ycj39ISYRgqHiN8IpXMUmW09lqZR6mWG9ZuAvZs3UYtWv7jjcIHeX8yT4BltAj5k19
         FDWkOvMgOUOgoGhmR2oYHeD7L8E98A3BefoKv0DOX4YmWcKHsOovs+lzyr2LqB5ILH/T
         eMH1OP3GqjIPiUTfj05vdQHnJDYjULjhAthPE=
MIME-Version: 1.0
In-Reply-To: <20100426145928.7855.70221.stgit@warthog.procyon.org.uk>
References: <20100426145928.7855.70221.stgit@warthog.procyon.org.uk>
Date: Wed, 28 Apr 2010 14:04:37 +0200
Message-ID: <i2s19f34abd1004280504n5b0eec52h1452a29726841e53@mail.gmail.com>
Subject: Re: [PATCH] KEYS: The request_key() syscall should link an existing 
	key to the dest keyring
From: Vegard Nossum <vegard.nossum@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, keyrings@linux-nfs.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2010 16:59, David Howells <dhowells@redhat.com> wrote:
> The request_key() system call and request_key_and_link() should make a link
> from an existing key to the destination keyring (if supplied), not just from a
> new key to the destination keyring.
>
> This can be tested by:
>
>        ring=`keyctl newring fred @s`
>        keyctl request2 user debug:a a
>        keyctl request user debug:a $ring
>        keyctl list $ring
>
> If it says:
>
>        keyring is empty
>
> then it didn't work.  If it shows something like:
>
>        1 key in keyring:
>        1070462727: --alswrv     0     0 user: debug:a
>
> then it did.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  security/keys/request_key.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/security/keys/request_key.c b/security/keys/request_key.c
> index ea97c31..d737cea 100644
> --- a/security/keys/request_key.c
> +++ b/security/keys/request_key.c
> @@ -339,8 +339,10 @@ static int construct_alloc_key(struct key_type *type,
>
>  key_already_present:
>        mutex_unlock(&key_construction_mutex);
> -       if (dest_keyring)
> +       if (dest_keyring) {
> +               __key_link(dest_keyring, key_ref_to_ptr(key_ref));
>                up_write(&dest_keyring->sem);
> +       }
>        mutex_unlock(&user->cons_lock);
>        key_put(key);
>        *_key = key = key_ref_to_ptr(key_ref);

Hi,

Just a few questions (if you don't mind).

1. Is it correct to return -EINPROGRESS in this case?

2. (Why) Shouldn't the return value of __key_link() be checked?

3. In __key_link(), shouldn't rcu_dereference() be used when accessing
keyring->payload.subscriptions?

Thanks,


Vegard
