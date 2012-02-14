Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760314Ab2BNTor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:44:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43516 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab2BNToo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:44:44 -0500
Message-ID: <4F3AB99E.5040705@zytor.com>
Date: Tue, 14 Feb 2012 11:44:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Tony Luck <tony.luck@intel.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 21/21] posix_types: Remove fd_set macros
References: <CA+8MBb+rMJqJAyDnnkB=x794F3MAQJfwTi29=4oN4-6=g5uDFw@mail.gmail.com> <4F32A98F.7030400@zytor.com> <1328677745-20121-22-git-send-email-hpa@zytor.com> <1328677745-20121-1-git-send-email-hpa@zytor.com> <8328.1328703626@redhat.com> <16325.1328736262@redhat.com> <4F32E98F.2090909@zytor.com> <30935.1329247114@redhat.com>
In-Reply-To: <30935.1329247114@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2012 11:18 AM, David Howells wrote:
> Tony Luck <tony.luck@intel.com> wrote:
> 
>> Adding a #include <linux/string.h> to include/linux/time.h fixes them for me.
> 
> Which is one of the reasons I'd rather not see these things cropping up in
> linux/time.h.  Either put them in linux/select.h (mirroring userspace) or
> stick them in linux/poll.h with the rest of the polling paraphernalia.
> 
> __FD_SET() and co aren't exported to userspace anyway, as I understand it, so
> it shouldn't hurt to bung them in linux/poll.h, and if they are exported to
> userspace, they should stay in posix_types.h, shouldn't they?
> 
> To support this, at least three #includes will have to be added to
> linux/time.h: linux/posix_types.h (which is fair enough), linux/bitops.h and
> linux/string.h.

We can do that, but we'd almost certainly have to #include
<linux/select.h> in <linux/time.h>.  The following macros are defined in
<linux/time.h> and *exported to userspace*:

#define NFDBITS                 __NFDBITS

#define FD_SETSIZE              __FD_SETSIZE
#define FD_SET(fd,fdsetp)       __FD_SET(fd,fdsetp)
#define FD_CLR(fd,fdsetp)       __FD_CLR(fd,fdsetp)
#define FD_ISSET(fd,fdsetp)     __FD_ISSET(fd,fdsetp)
#define FD_ZERO(fdsetp)         __FD_ZERO(fdsetp)

Now, this largely mimics what has happened in userspace over time; to
quote POSIX:

The <sys/time.h> header shall define the fd_set type as described in
<sys/select.h>.

The <sys/time.h> header shall define the following as described in
<sys/select.h>:
FD_CLR( )
FD_ISSET( )
FD_SET( )
FD_ZERO( )
FD_SETSIZE

[...]

Inclusion of the <sys/time.h> header may make visible all symbols from
the <sys/select.h> header.

Cleaning up <linux/time.h> would indeed be a worthwhile goal -- it's not
clear to me that it can safely be used to build a POSIX-compliant
userspace.  In particular, it mixes the functions of <sys/time.h> and
<time.h>, but <time.h> symbols are not permitted to leak into
<sys/time.h> space as far as I read the specification.  However, this
feels like a slightly orthogonal task (in fact, it might belong more in
your uabi work.)

	-hpa
-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

