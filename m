Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab1EYPHK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:07:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33792 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933014Ab1EYPHI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:07:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110525144400.GA26206@mail.hallyn.com>
References: <BANLkTikfqV57AtCckh99jAT2O38mM6MzTA@mail.gmail.com>
	<BANLkTikey3L4doiHY=__=690TZNsXqRHUQ@mail.gmail.com>
	<alpine.DEB.2.00.1105231133580.29047@router.home>
	<BANLkTi=-xRRxi4CtxMLt0VgTJWSdiVQugw@mail.gmail.com>
	<BANLkTin1zhuA3z61cBWwJws+P1-xA5bGZA@mail.gmail.com>
	<BANLkTikp4VweUE+JrkXRSJ-8kEEcPKpw8g@mail.gmail.com>
	<BANLkTimB6pQyux4XEqqEUvuPGsZ2Bw0L8w@mail.gmail.com>
	<20110525144400.GA26206@mail.hallyn.com>
Date: Wed, 25 May 2011 17:07:05 +0200
Message-ID: <BANLkTi=Y_+UBWGb5Kj9ga_bC0Fm7DosGVw@mail.gmail.com>
Subject: Re: [Security] Fwd: Oops (bad memory deref) in slab_alloc() due to
 filp_cachep holding incorrect values
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Eugene Teo <eugeneteo@kernel.sg>, linux-kernel@vger.kernel.org,
        security@kernel.org, kees@ubuntu.com,
        Tavis Ormandy <taviso@cmpxchg8b.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Given that it doesn't seem to appear in 2.6.39-rc4, and judging by the
>> names of functions involved, this change looks suspiciously related to
>> this oops (even if it just made the keyctl problem visible)
>> http://git.itanic.dy.fi/?p=linux-stable;a=commitdiff;h=47a150edc2ae734c0f4bf50aa19499e23b9a46f8
>>
>> >> #include <sys/stat.h>
>> >> #include <sys/wait.h>
>> >> #include <unistd.h>
>> >> #include <sys/syscall.h>
>> >> #include <linux/keyctl.h>
>> >> #include <linux/sched.h>
>> >>
>> >> int TH1(void *dummy) {
>> >>        syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT);
>
> Thanks!
>
> Fooi, it looks like all users of cred_alloc_blank() may need to be
> audited wrt commit 47a150edc2ae734c0f4bf50aa19499e23b9a46f8.
>
> Does this fix the bug you're seeing?

Yup, the kernel survives both the testcase and a short syscall fuzzing
session. Thanks.

> From: Serge E. Hallyn <serge.hallyn@canonical.com>
> Date: Wed, 25 May 2011 15:41:23 +0100
> Subject: [PATCH 1/1] Set cred->user_ns in key_replace_session_keyring
>
> Since this cred was not created with copy_creds(), it needs to get
> initialized.
>
> Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> ---
>  security/keys/process_keys.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index 6c0480d..92a3a5d 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -847,6 +847,7 @@ void key_replace_session_keyring(void)
>        new-> sgid      = old-> sgid;
>        new->fsgid      = old->fsgid;
>        new->user       = get_uid(old->user);
> +       new->user_ns    = new->user->user_ns;
>        new->group_info = get_group_info(old->group_info);
>
>        new->securebits = old->securebits;
> --
> 1.7.0.4

-- 
Robert Święcki
