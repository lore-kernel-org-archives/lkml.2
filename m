Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab2AQS77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:59:59 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49048 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2AQS75 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:59:57 -0500
MIME-Version: 1.0
In-Reply-To: <1325878247-12030-2-git-send-email-jlayton@redhat.com>
References: <1325878247-12030-1-git-send-email-jlayton@redhat.com>
	<1325878247-12030-2-git-send-email-jlayton@redhat.com>
Date: Tue, 17 Jan 2012 12:59:56 -0600
Message-ID: <CAH2r5muKHFY1AEL1CM82xfZJAdzVhhD1+CkPo2Nz1Q4QmxtvWA@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] keys: add a "secret" key type
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, keyrings@linux-nfs.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks fine and plan to merge via the cifs git tree, unless
anyone has last minute objections.

On Fri, Jan 6, 2012 at 1:30 PM, Jeff Layton <jlayton@redhat.com> wrote:
> For CIFS, we want to be able to store NTLM credentials (aka username
> and password) in the keyring. We do not, however want to allow users
> to fetch those keys back out of the keyring since that would be a
> security risk.
>
> Unfortunately, due to the nuances of key permission bits, it's not
> possible to do this. We need to grant search permissions so the kernel
> can find these keys, but that also implies permissions to read the
> payload.
>
> Resolve this by adding a new key_type. This key type is essentially
> the same as key_type_user, but does not define a .read op. This
> prevents the payload from ever being visible from userspace.
>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  include/keys/user-type.h     |    3 ++-
>  security/keys/internal.h     |    1 +
>  security/keys/key.c          |    1 +
>  security/keys/user_defined.c |   17 +++++++++++++++++
>  4 files changed, 21 insertions(+), 1 deletions(-)
>
> diff --git a/include/keys/user-type.h b/include/keys/user-type.h
> index c37c342..41b5515 100644
> --- a/include/keys/user-type.h
> +++ b/include/keys/user-type.h
> @@ -17,7 +17,7 @@
>
>  /*****************************************************************************/
>  /*
> - * the payload for a key of type "user"
> + * the payload for a key of type "user" or "secret"
>  * - once filled in and attached to a key:
>  *   - the payload struct is invariant may not be changed, only replaced
>  *   - the payload must be read with RCU procedures or with the key semaphore
> @@ -33,6 +33,7 @@ struct user_key_payload {
>  };
>
>  extern struct key_type key_type_user;
> +extern struct key_type key_type_secret;
>
>  extern int user_instantiate(struct key *key, const void *data, size_t datalen);
>  extern int user_update(struct key *key, const void *data, size_t datalen);
> diff --git a/security/keys/internal.h b/security/keys/internal.h
> index c7a7cae..2784e07 100644
> --- a/security/keys/internal.h
> +++ b/security/keys/internal.h
> @@ -33,6 +33,7 @@
>
>  extern struct key_type key_type_dead;
>  extern struct key_type key_type_user;
> +extern struct key_type key_type_secret;
>
>  /*****************************************************************************/
>  /*
> diff --git a/security/keys/key.c b/security/keys/key.c
> index 4414abd..3d1d79d 100644
> --- a/security/keys/key.c
> +++ b/security/keys/key.c
> @@ -996,6 +996,7 @@ void __init key_init(void)
>        list_add_tail(&key_type_keyring.link, &key_types_list);
>        list_add_tail(&key_type_dead.link, &key_types_list);
>        list_add_tail(&key_type_user.link, &key_types_list);
> +       list_add_tail(&key_type_secret.link, &key_types_list);
>
>        /* record the root user tracking */
>        rb_link_node(&root_key_user.node,
> diff --git a/security/keys/user_defined.c b/security/keys/user_defined.c
> index 69ff52c..e25782f 100644
> --- a/security/keys/user_defined.c
> +++ b/security/keys/user_defined.c
> @@ -36,6 +36,23 @@ struct key_type key_type_user = {
>  EXPORT_SYMBOL_GPL(key_type_user);
>
>  /*
> + * This key type is essentially the same as key_type_user, but it does
> + * not define a .read op. This is suitable for storing information in
> + * the keyring that you do not want to be readable from userspace. For
> + * instance, passwords or secret encryption keys.
> + */
> +struct key_type key_type_secret = {
> +       .name           = "secret",
> +       .instantiate    = user_instantiate,
> +       .update         = user_update,
> +       .match          = user_match,
> +       .revoke         = user_revoke,
> +       .destroy        = user_destroy,
> +       .describe       = user_describe,
> +};
> +EXPORT_SYMBOL_GPL(key_type_secret);
> +
> +/*
>  * instantiate a user defined key
>  */
>  int user_instantiate(struct key *key, const void *data, size_t datalen)
> --
> 1.7.7.4
>



-- 
Thanks,

Steve
