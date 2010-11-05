Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0KEHq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 03:46:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60379 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0KEHq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 03:46:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AVKZo2Vdvb/5c/0dsYitJ3MHDVbujHkpGO4t1YuXOwfCRylcDWmLMVy8k7kK2hI0sl
         1xNZHj2OQw+hSj3DzKcNaCrr1V7n0o06TZSKcY64L7YOjzxuVV5OsFOARKQ7GPAhqzfJ
         CW077TUwFgYICyXlGAkeOIRLY3qkFNW0I2Xug=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=wi8DJaMMxjYTex8A_FiB0071Tk_dx1pudtUpD@mail.gmail.com>
References: <AANLkTi=wi8DJaMMxjYTex8A_FiB0071Tk_dx1pudtUpD@mail.gmail.com>
Date: Fri, 5 Nov 2010 15:46:26 +0800
Message-ID: <AANLkTi=yWUqROeAMQG7FKU1xcGHOxwXuh=X3Zm3DP8v7@mail.gmail.com>
Subject: Re: [PATCH] kdb: fix memory leak
From: Dongdong Deng <libfetion@gmail.com>
To: jovi zhang <bookjovi@gmail.com>
Cc: Jason Wessel <jason.wessel@windriver.com>, Martin Hicks <mort@sgi.com>,
        Dmitry Torokhov <dtor@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oA57kdrD001424

On Fri, Nov 5, 2010 at 1:44 PM, jovi zhang <bookjovi@gmail.com> wrote:
> fix memory leak in kdb_main.c
>
> Signed-off-by: jovi zhang <bookjovi@gmail.com>
> kernel/debug/kdb/kdb_main.c | Â  13 +++++++------
> 1 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
> index 37755d6..3ab3fee 100644
> --- a/kernel/debug/kdb/kdb_main.c
> +++ b/kernel/debug/kdb/kdb_main.c
> @@ -2361,7 +2361,7 @@ static int kdb_pid(int argc, const char **argv)
> Â */
> static int kdb_ll(int argc, const char **argv)
> {
> - Â  Â  Â  int diag;
> + Â  Â  Â  int diag = 0;
> Â  Â  Â  Â unsigned long addr;
> Â  Â  Â  Â long offset = 0;
> Â  Â  Â  Â unsigned long va;
> @@ -2400,20 +2400,21 @@ static int kdb_ll(int argc, const char **argv)
> Â  Â  Â  Â  Â  Â  Â  Â char buf[80];
>
> Â  Â  Â  Â  Â  Â  Â  Â if (KDB_FLAG(CMD_INTERRUPT))
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return 0;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto out;
>
> Â  Â  Â  Â  Â  Â  Â  Â sprintf(buf, "%s " kdb_machreg_fmt "\n", command, va);
> Â  Â  Â  Â  Â  Â  Â  Â diag = kdb_parse(buf);
> Â  Â  Â  Â  Â  Â  Â  Â if (diag)
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return diag;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto out;
>
> Â  Â  Â  Â  Â  Â  Â  Â addr = va + linkoffset;
> Â  Â  Â  Â  Â  Â  Â  Â if (kdb_getword(&va, addr, sizeof(va)))
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return 0;
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  goto out;
> Â  Â  Â  Â }
> - Â  Â  Â  kfree(command);
>
> - Â  Â  Â  return 0;
> +out:
> + Â  Â  Â  kfree(command);
> + Â  Â  Â  return diag;
> }
>
> static int kdb_kgdb(int argc, const char **argv)
>


It is ok for me. :-)

Dongdong
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
