Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab1FFWsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:48:10 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:56276 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab1FFWsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:48:08 -0400
Message-ID: <4DED5926.80504@msgid.tls.msk.ru>
Date: Tue, 07 Jun 2011 02:48:06 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, lacombar@gmail.com
Subject: Re: [PATCH -v2] vfs: make unlink() return ENOENT in preference to
 EROFS
References: <BANLkTimX_R8-mT4PqAhqwvCPm_-bcDFqVQ@mail.gmail.com> <1307393893-28672-1-git-send-email-tytso@mit.edu> <20110606223030.GN11521@ZenIV.linux.org.uk>
In-Reply-To: <20110606223030.GN11521@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

07.06.2011 02:30, Al Viro wrote:
> On Mon, Jun 06, 2011 at 04:58:13PM -0400, Theodore Ts'o wrote:
>> If user space attempts to unlink a non-existent file, and the file
>> system is mounted read-only, return ENOENT instead of EROFS.  Either
>> error code is arguably valid/correct, but ENOENT is a more specific
>> error message.
> 
> Umm...  I can live with that.  What about rmdir(2)?  We have similar situation
> there as well.  If we care about one, why not the other?

I think both should be fixed.

> Mind you, I'm not at all convinced that it matters enough to bother, but
> yes, ENOENT is a bit more specific (and likelier to be handled by luserland
> code).

The problem which triggered the initial thread and Ted's patch was me
trying to commit some changes from read-only /etc into git tree.  This
works for everything but deletes, since `git rm' barfs when unlink for
a non-existing file returns EROFS.  rm(1) has been patched especially
for this case at about kernel 2.6.32 time, as shown in comments at
 http://git.savannah.gnu.org/cgit/coreutils.git/tree/src/remove.c#n450 ,
but git has not (yet), and I suspect git isn't the only leftover, there
are other applications to patch still, if the kernel will continue to
return EROFS.

Besides, POSIX says (http://pubs.opengroup.org/onlinepubs/009695399/functions/unlink.html):

  [EROFS]
    The directory entry to be unlinked
    is part of a read-only file system

so it clearly states that the entry should exists for EROFS, ie, to
be _part_ of the filesystem.

Thanks!

/mjt
