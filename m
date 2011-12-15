Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab1LOSzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 13:55:53 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64167 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751788Ab1LOSzw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 13:55:52 -0500
MIME-Version: 1.0
In-Reply-To: <20111207205459.031a0609@lxorguk.ukuu.org.uk>
References: <1323280461.10724.13.camel@lenny>
	<4EDFCDD4.2080603@zytor.com>
	<20111207205459.031a0609@lxorguk.ukuu.org.uk>
Date: Thu, 15 Dec 2011 10:55:50 -0800
X-Google-Sender-Auth: dViUD4VU7bISuwxByfHWH95RvRs
Message-ID: <CALQRfL6A+XUiLUVzsSOkz52rs7Pejtb_v8QZbpWxh5W8yYDYtg@mail.gmail.com>
Subject: Re: chroot(2) and bind mounts as non-root
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Colin Walters <walters@verbum.org>,
        LKML <linux-kernel@vger.kernel.org>, serue@us.ibm.com,
        dhowells@redhat.com, kzak@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm genuinely confused whether all these concerns are valid with file
capabilities.

Consider (let's say luser is some user that I want to be active inside
the chroot, but I don't want to allow regular login to my system):

morgan> sudo su luser
luser> mkdir /tmp/chroot/
luser> chmod go-rx /tmp/chroot/
luser> exit

morgan> cat > launcher.c <<EOT
#include <stdio.h>
#include <unistd.h>
int main(int argc, char **argv)
{
  int ret = chroot("/tmp/chroot");
  printf("chroot %s.\n", ret ? "failed" : "worked");
  ret = chdir("/");
  printf("chdir %s.\n", ret ? "failed" : "worked");
  // Insert exec code to invoke chroot'd shell or whatever.
  return ret;
}
EOT
morgan> make launcher
cc launcher.c -o launcher
morgan> mv launcher /tmp/
morgan> sudo -s
root> setcap cap_sys_chroot=ep /tmp/launcher
root> cp <files and directories needed in the chroot> /tmp/chroot/
root> su luser

luser> /tmp/launcher

The last line being something that involves luser only - ie. it gives
no user privilege away to any child it might launch. Its also the only
regular user able to chroot to this luser owned chroot (because that
directory is exclusive to that user).

Is there a need for privileged binaries within /tmp/chroot? If not,
how might they get there (without help from root, always presuming I
can prevent luser from logging in outside of this chroot'd
environment)?

Thanks

Andrew

On Wed, Dec 7, 2011 at 12:54 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 07 Dec 2011 12:34:28 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>> On 12/07/2011 09:54 AM, Colin Walters wrote:
>> >
>> > The historical reason one can't call chroot(2) as non-root is because of
>> > setuid binaries (hard link a setuid binary into chroot of your choice
>> > with trojaned libc.so).
>>
>> No.  The historical reason is that it lets anyone escape a chroot jail:
>
> Beg to differ
>
> Nobody ever considered chroot a jail except a certain brand of
> urban-legend-programming people. Indeed chroot has never been a jail
> except in the 'open prison' security sense of it.
>
> The big problem with chroot was abusing setuid binaries - particularly
> things like uucp and /bin/mail.
>
>
