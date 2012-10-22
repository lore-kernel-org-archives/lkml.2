Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab2JVCJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 22:09:36 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56024 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932791Ab2JVCJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 22:09:34 -0400
MIME-Version: 1.0
In-Reply-To: <20121022123553.240d9ddf05cd5e2c8fee0ab3@canb.auug.org.au>
References: <20121022123553.240d9ddf05cd5e2c8fee0ab3@canb.auug.org.au>
Date: Sun, 21 Oct 2012 19:09:32 -0700
X-Google-Sender-Auth: frpFR4X94bG1GqgA3dacZJBE4k4
Message-ID: <CAGXu5j+geKBjof6peRWgyWra3wfhnLUNDfb5nzEppGGzLKwtOg@mail.gmail.com>
Subject: Re: linux-next: manual merge of the modules tree with the tree
From: Kees Cook <keescook@chromium.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 6:35 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Rusty,
>
> Today's linux-next merge of the modules tree got a conflict in
> kernel/module.c between commit caabe240574a ("MODSIGN: Move the magic
> string to the end of a module and eliminate the search") from Linus' tree
> and commit 0250abdeec54 ("module: add syscall to load module from fd")
> from the modules tree.
>
> I fixed it up (I think - see below) and can carry the fix as necessary
> (no action is required).
>
> I do wonder why the above change in Linus' tree seems to have bypassed
> the modules maintainer.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc kernel/module.c
> index 6085f5e,261bf82..0000000
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@@ -2420,18 -2422,27 +2422,18 @@@ static inline void kmemleak_load_module
>   #endif
>
>   #ifdef CONFIG_MODULE_SIG
> - static int module_sig_check(struct load_info *info,
> -                           const void *mod, unsigned long *_len)
> + static int module_sig_check(struct load_info *info)
>   {
>         int err = -ENOKEY;
> -       unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
> -       unsigned long len = *_len;
> +       const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
> +       const void *mod = info->hdr;

I got rid of "mod" when I did my merge of these changes against
Linus's tree, but I had to cast it in the memcmp, so probably best to
just keep "mod".

>  -      const void *p = mod, *end = mod + info->len;
> ++      unsigned long len = info->len;
>
>  -      /* Poor man's memmem. */
>  -      while ((p = memchr(p, MODULE_SIG_STRING[0], end - p))) {
>  -              if (p + markerlen > end)
>  -                      break;
>  -
>  -              if (memcmp(p, MODULE_SIG_STRING, markerlen) == 0) {
>  -                      const void *sig = p + markerlen;
>  -                      /* Truncate module up to signature. */
>  -                      info->len = p - mod;
>  -                      err = mod_verify_sig(mod, info->len,
>  -                                           sig, end - sig);
>  -                      break;
>  -              }
>  -              p++;
>  +      if (len > markerlen &&
>  +          memcmp(mod + len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
>  +              /* We truncate the module to discard the signature */
> -               *_len -= markerlen;
> -               err = mod_verify_sig(mod, _len);
> ++              info->len -= markerlen;
> ++              err = mod_verify_sig(mod, &info->len);
>         }
>
>         if (!err) {

-Kees

-- 
Kees Cook
Chrome OS Security
