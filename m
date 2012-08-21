Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2HUNwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 09:52:03 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58510 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab2HUNwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 09:52:00 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.1208211204420.1100@frira.zrqbmnf.qr>
References: <1343845147-21394-1-git-send-email-anatol.pomozov@gmail.com>
	<alpine.LNX.2.01.1208211204420.1100@frira.zrqbmnf.qr>
Date: Tue, 21 Aug 2012 06:51:58 -0700
Message-ID: <CAOMFOmW1XZrgHHp+b6s9xjn1iYNqA1ej1KpiyO=KMeCsRgRTzg@mail.gmail.com>
Subject: Re: [PATCH] fs: Preserve error code in get_empty_filp()
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Jan Engelhardt <jengelh@inai.de>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        Anatol Pomazau <anatol@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Tue, Aug 21, 2012 at 3:06 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>
>
> On Wednesday 2012-08-01 20:19, anatol.pomozov@gmail.com wrote:
> >Allocating a file structure in function get_empty_filp() might fail
> > because
> >of several reasons:
> > - not enough memory for file structures
> > - operation is not allowed
> > - user is over its limit
> >
> >Currently the function returns NULL in all cases and we loose the exact
> >reason of the error. All callers of get_empty_filp() assume that the
> > function
> >can fail with ENFILE only.
> >
> >Return error through pointer. Change all callers to preserve this error
> > code.
>
> >       percpu_counter_inc(&nr_files);
> >       f->f_cred = get_cred(cred);
> >-      if (security_file_alloc(f))
> >+      if (security_file_alloc(f)) {
> >+              error = -EPERM;
> >               goto fail_sec;
> >+      }
>
> You are not preserving the error code from security_file_alloc here.
>
> In particular, apparmoar/lsm.c: file_alloc_security can return -ENOMEM,
> for example.

Yep, this was a bug in the first version of the patch. It the latest
version (from Aug 2) it is fixed, please review this version instead.
