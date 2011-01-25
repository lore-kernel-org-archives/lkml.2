Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1AYWLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:11:13 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62756 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1AYWLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:11:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=e2WPDKn9Ejq499OZNdYfkkUPutsSHXYn3fPS7lEQ4iS+00nPdRZTEIr1cp5yKFO81N
         3HP7HZnQh4sX1F65l/Zh0SU2XElq9Vlfu1Inyg20+f+sVNVgPLd2Vauqe9y/85HaU3Ah
         BXinzOwMM1dqvjHzIfFBfiMrHsKO35oIDN1LQ=
MIME-Version: 1.0
Reply-To: linasvepstas@gmail.com
In-Reply-To: <4D3F4156.7010900@redhat.com>
References: <AANLkTikhKHnR+7DskxYqWXduX4=tpfgsfL4sNYq+4QDq@mail.gmail.com>
 <20110125174515.C1DC2183C19@magilla.sf.frob.com> <201101251921.15184.arnd@arndb.de>
 <201101251352.03079.vapier@gentoo.org> <4D3F2AD9.8060000@redhat.com>
 <4D3F3308.1050305@redhat.com> <4D3F4156.7010900@redhat.com>
From: Linas Vepstas <linasvepstas@gmail.com>
Date: Tue, 25 Jan 2011 16:10:48 -0600
Message-ID: <AANLkTi=_sRM6k+fiKiOkbano7LCmys6Hy2Em_W3GaYx=@mail.gmail.com>
Subject: Re: [BUG] Generic syscalls -- chmod vs. fchmodat
To: Eric Blake <eblake@redhat.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Arnd Bergmann <arnd@arndb.de>,
        Paul Eggert <eggert@cs.ucla.edu>, Roland McGrath <roland@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        GLIBC Devel <libc-alpha@sourceware.org>, linux-kernel@vger.kernel.org,
        libc-ports@sourceware.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 25 January 2011 15:32, Eric Blake <eblake@redhat.com> wrote:
>
> 7. fchmodat(AT_FDCWD, "") must fail with ENOENT.  Apparently, the kernel
> currently modifies ".", although point 1 says it might make more sense
> to fail with ENOENT so that glibc doesn't have to do as much work in
> chmod and fchmodat (if the kernel call does not change, then the burden
> is on glibc).

Interesting discussion, but I'm very embarrassed to say I started it
due to a mis-diagnosis of a bug :-(

In fact, the current kernels *do* check for an empty string, and do so
in order to maintain POSIX compliance, per Eric's points 5 and 7.
See fs/namei.c in do_getname, circa line 114,  where we read:

 * POSIX.1 2.4: an empty pathname is invalid (ENOENT).

This is backed up with code, circa line 129 ff:

   retval = strncpy_from_user(page, filename, len);
...
else if (!retval)
      retval = -ENOENT;
   return retval;

So an empty string will have length zero, and the ENOENT is indeed
set.

This handles cases 5 & 7.  I've no idea how any of the other cases
work out.

Note that getname() is used in a variety of places; its not just chmod,
but also in symlinks and many others.

--linas
