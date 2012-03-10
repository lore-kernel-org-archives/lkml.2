Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab2CJWv6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 17:51:58 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57508 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab2CJWv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 17:51:57 -0500
Message-ID: <4F5BDB09.3020407@suse.cz>
Date: Sat, 10 Mar 2012 23:51:53 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120229 Thunderbird/11.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        gregkh@linuxfoundation.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
References: <4F5BD51B.7030907@nod.at>
In-Reply-To: <4F5BD51B.7030907@nod.at>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/10/2012 11:26 PM, Richard Weinberger wrote:
> Hi!
> 
> While moving UML's console driver to tty_port some strange things
> happened. So, I have a few questions. :-)
> 
> The original driver did not implement tty_operations->hangup(). If
> I implement it and call tty_port_hangup(), as Alan suggested, the
> login fails on all TTYs except tty0. It fails because the opened
> TTY returns EIO upon read()/write() after /bin/login called
> vhangup().
> 
> The call chain is: vhangup() -> tty_vhangup_self() -> tty_vhangup()
> -> __tty_hangup()
> 
> Within __tty_hangup() something happens that I don't fully
> understand:
> 
> if (cons_filp) { if (tty->ops->close) for (n = 0; n < closecount;
> n++) tty->ops->close(tty, cons_filp); } else if (tty->ops->hangup) 
> (tty->ops->hangup)(tty);
> 
> Login on tty0 works because cons_filp is not NULL and
> tty->ops->close() is called. On the other hand login fails on every
> other TTY because cons_filp remains NULL and the TTY hangs up.
> 
> Is there something missing in my hangup function?
> 
> If I omit tty_operations->hangup() and leave it, like the old
> driver, NULL non-tty0 TTYs cannot be opened. (getty terminates
> immediately because it cannot open any TTY.) open() retuns -EIO
> because the TTY_CLOSING is set in tty->flags.
> 
> How can this be?

Hmm, it looks like some process is sitting on a TTY which was hung.
And the system offers this hung TTY to others on further opens. Could
you check that there is no process with open TTY after the vhangup?

regards,
- -- 
js
suse labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPW9sIAAoJEL0lsQQGtHBJlgMP/1Raic2yKfoGxQto7i4wcs6q
B++AgVPfYktAdODL5hem4n6Unf5n2QoLqs7ITGaH9UkN6dWWo9el0RO8zIUl3wpg
OFkyD2CwBpa3HZ2VmIDTtEatL64Xh+lE3PZyJv+ACLN8qJYCOy+9JpuqPltYg64j
fihMX9bvOkwhnRHS/G78S3M4RnqjGcR8V7vIdm8/FfnbHlIzRFUERk9sa0d1V7my
782nTTPVFsczLHL3wWIA1txKnF98LU6Dab0/EqTzen23Z1bD30hhPsahdGIj04YW
IoM1v5ps3aie1QTyAHbi3dR/ncFI3G6ux4YIJJEAnNprnjxy4FGSqfen5sgmtiZm
ugengHeajJlqBYWPzjc7XNENC9rJUCBAMyPWGA3LEc/jfWp3wdkL1/kQ6znYKD5V
hAEWs8KABCdFhOK2OPx47QMs4kEENVTMZniYL/U7PCiwYjmCXI7PUUHwi/qrtk+F
rU9e0bYpSFYOvDqQQiemZHpNCtPz8TQieEV/LvMJ4f/bKrxZQdVadoFf0yv7iDE5
9v3SnrRMm/BxjSJhim8UOgjNj+oX8LYh7vCqbbq+dxxlNV1zIzNPoCVnMHJpazio
Z6xJAu2w4GsIB99IzrUl8/q2EmHtPktRWL1JNqlr8R5+g2SeIMz8ha4o2ymDE6CE
NGGVl9p5SE7r0kkttiNi
=Mhvv
-----END PGP SIGNATURE-----
