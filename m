Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab0E1RjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 13:39:08 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58336 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932874Ab0E1RjD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 13:39:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vlGwDvbKrpPSnmeWZCTz338nDTIxm2oxhvgzteSSM7yiZKeshyAB7hqWRAnPROFA1z
         XlfKQY5J/gTz7ldcwWiiGVJff+yiu/qZpP9ABTOMOuO9wrUb+rTAqIps9DKJ1VYiBFw0
         RBPdlajZXNd9fspHj9KKLi3zeFKwSFQii7Vns=
MIME-Version: 1.0
In-Reply-To: <20100528165659.1e6fd136.yoshikawa.takuya@oss.ntt.co.jp>
References: <20100528165659.1e6fd136.yoshikawa.takuya@oss.ntt.co.jp>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 28 May 2010 13:38:41 -0400
Message-ID: <AANLkTiltnomEArb1bPTYuNI_HpK6oN_gv-VAII9db3n8@mail.gmail.com>
Subject: Re: [PATCH] binfmt_elf_fdpic: fix clear_user() error handling
To: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       d.hatayama@jp.fujitsu.com, dhowells@redhat.com, lethal@linux-sh.org,
       takuya.yoshikawa@gmail.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 03:56, Takuya Yoshikawa wrote:
> Hi, I found some places in bin_elf_fdpic at which clear_user() is
> incorrectly handled, by chance, when I was trying to check how to
> use clear_user().
>
> IIUC, the following commit was not correct.
>
>  commit ab4ad55512e95b68ca3e25516068e18874f89252
>  bin_elf_fdpic: check the return value of clear_user
>
> Although I don't have an appropriate test box for this, I wrote a
> simple patch to fix this. So if this is worth fixing, please pick
> this up.

the intention was that these functions return 0 only on success, and
non-zero otherwise.  along those lines, the patch does what was
intended.  unfortunately, the logic calling these funcs only checks
for negative values.

> clear_user() returns the number of bytes, unsigned long, that could not
> be copied. So we should return -EFAULT rather than directly return the results.
>
> Without this patch, positive values may be passed to elf_fdpic_map_file() and
> the following error handlings do not function as expected.

on nommu systems, this is generally not an issue because clear_user()
is basically a memset().  but it's good to handle every case.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
