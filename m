Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab2CEMDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:03:10 -0500
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:50158 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab2CEMDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:03:08 -0500
Date: Mon, 5 Mar 2012 13:02:41 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Tony Luck <tony.luck@intel.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Build broken on s390 and ia64 [was: Linux 2.6.32.58]
Message-ID: <20120305120241.GA3627@osiris.boeblingen.de.ibm.com>
References: <20120304180911.GA7336@kroah.com>
 <4F54A46A.6000305@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F54A46A.6000305@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12030512-4966-0000-0000-000001A6DBC2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 12:32:58PM +0100, Jiri Slaby wrote:
> On 03/04/2012 07:09 PM, Greg KH wrote:
> > I'm announcing the release of the 2.6.32.58 kernel.
> ...
> > Heiko Carstens (1): compat: fix compile breakage on s390
> 
> It's not that minimal it suggests. It removed asm/compat.h inclusion
> from arch/s390/kernel/setup.c. This causes build failures on
> !CONFIG_COMPAT:
> arch/s390/kernel/setup.c: In function 'setup_addressing_mode':
> arch/s390/kernel/setup.c:382: error: 'PSW32_ASC_SECONDARY' undeclared
> (first use in this function)
> arch/s390/kernel/setup.c:382: error: (Each undeclared identifier is
> reported only once
> arch/s390/kernel/setup.c:382: error: for each function it appears in.)
> arch/s390/kernel/setup.c:389: error: 'PSW32_ASC_PRIMARY' undeclared
> (first use in this function)

Ah, right. For kernels < 3.0 it is indeed necessary to include
asm/compat.h in arch/s390/kernel/setup.c.

The need for that got eliminated with
043d07084b5347a26eab0a07aa13a4a929ad9e71 "[S390] Remove data execution
protection".

> Perhaps asm/compat.h should be included from linux/compat.h
> unconditionally...

If you do that you need to add #ifdef wrappers around the is_compat_task()
definitions in each arch that supports CONFIG_COMPAT. If that's all that's
needed that would be great!

> > Linus Torvalds (2): Fix autofs compile without CONFIG_COMPAT
> 
> But who defines is_compat_task *with* CONFIG_COMPAT on ia64?
> 
> fs/autofs4/inode.c: In function 'autofs4_fill_super':
> fs/autofs4/inode.c:345: error: implicit declaration of function
> 'is_compat_task'

The ia64 compat code got entirely removed, since it was broken:

32974ad4907cdde6c9de612cd1b2ee0568fb9409 "[IA64] Remove COMPAT_IA32 support"

