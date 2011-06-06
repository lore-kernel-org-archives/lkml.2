Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383Ab1FFRN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:13:28 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:42920 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab1FFRNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:13:25 -0400
Message-ID: <4DED0AB3.6060708@msgid.tls.msk.ru>
Date: Mon, 06 Jun 2011 21:13:23 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: unlink(nonexistent): EROFS or ENOENT?
References: <4DE26F97.9050607@msgid.tls.msk.ru> <20110606033949.GE7180@thunk.org>
In-Reply-To: <20110606033949.GE7180@thunk.org>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the answer.  I thought noone will reply... ;)

06.06.2011 07:39, Ted Ts'o wrote:
> On Sun, May 29, 2011 at 08:08:55PM +0400, Michael Tokarev wrote:
>> Hello.
>>
>> Just noticed that at least on ext4, unlinking a
>> non-existing file from a read-only filesystem
>> results in EROFS instead of ENOENT.  I'd expect
>> it return ENOENT - it is more logical, at least
>> in my opinion.
>>
>> For one, (readonly) NFS mount returns ENOENT in
>> this case.
> 
> Um, it doesn't for me.   Testing on v3.0-rc1:
> 
> # ls /test/foo; rm /test/foo
> ls: cannot access /test/foo: No such file or directory
> rm: cannot remove `/test/foo': No such file or directory

This is a hack in coreutils rm to work around this
kernel change.  The comment at
 http://git.savannah.gnu.org/cgit/coreutils.git/tree/src/remove.c#n450
says:

  /* The unlinkat from kernels like linux-2.6.32 reports EROFS even for
     nonexistent files.  When the file is indeed missing, map that to ENOENT,
     so that rm -f ignores it, as required.  Even without -f, this is useful
     because it makes rm print the more precise diagnostic.  */

so that rm(1) calls stat(2) to see if the file actually
exist if unlinkat() returned EROFS, and turns this errno
into ENOENT.

That is, rm(1) output is not a good indicator.  Use

  strace rm -f /test/foo 2>&1 | grep unlink

to see the actual errno reported by the kernel.

Here's the POSIX description of unlink (and unlinkat) again:
http://pubs.opengroup.org/onlinepubs/009695399/functions/unlink.html

Thanks!

/mjt
