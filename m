Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0GLS2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 14:28:38 -0400
Received: from mail.perches.com ([173.55.12.10]:1705 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756375Ab0GLS2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 14:28:36 -0400
Subject: Re: Possible false positive from checkpatch.pl
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C3B5660.8020405@lwfinger.net>
References: <4C3B5660.8020405@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Jul 2010 11:28:35 -0700
Message-ID: <1278959315.1501.261.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-07-12 at 12:52 -0500, Larry Finger wrote:
> Andy,
> 
> In preparing a vendor driver for submission to staging, I am getting the 
> following from checkpatch.pl:
> 
> ERROR: Macros with multiple statements should be enclosed in a do - while loop
> #377: FILE: staging/rtl8712/rtl871x_mp_ioctl.h:377:
> +#define GEN_MP_IOCTL_HANDLER(sz, hdl, oid) {sz, hdl, oid},

I think you should leave off the trailing comma from the macros
and C99 might be better.  Maybe something like:

(whatever the field names really are)

#define GEN_MP_IOCTL_HANDLER(sz, hdl, oid)	\
	{.field1 = sz, .field2 = hdl, .field3 = oid}

> ERROR: Macros with multiple statements should be enclosed in a do - while loop
> #378: FILE: staging/rtl8712/rtl871x_mp_ioctl.h:378:
> +#define EXT_MP_IOCTL_HANDLER(sz, subcode, oid) {sz, &mp_ioctl_ \
> +       ## subcode ## _hdl, oid},

The line continuation is rather ugly too.  Perhaps it's better as:

#define EXT_MP_IOCTL_HANDLER(sz, subcode, oid)	\
	{.field1 = sz, .field2 = &mp_ioctl_##subcode##_hdl, .field3 = oid}

They pass checkpatch without error.

$ cat foo.h
#define GEN_MP_IOCTL_HANDLER(sz, hdl, oid)	\
	{.field1 = sz, .field2 = hdl, .field3 = oid}
#define EXT_MP_IOCTL_HANDLER(sz, subcode, oid)	\
	{.field1 = sz, .field2 = &mp_ioctl_##subcode##_hdl, .field3 = oid}
$ ./scripts/checkpatch.pl -f foo.h
total: 0 errors, 0 warnings, 4 lines checked

foo.h has no obvious style problems and is ready for submission.

