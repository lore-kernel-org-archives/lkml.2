Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030855Ab2CNOnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 10:43:09 -0400
Received: from mail.southpole.se ([193.12.106.18]:54809 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2CNOnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 10:43:06 -0400
Message-ID: <1331736182.5104.74.camel@jerome.southpole.se>
Subject: Re: [ORLinux] [PATCH 17/35] Make asm-generic/cmpxchg.h #include
 asm-generic/cmpxchg-local.h [ver #2]
From: Jonas Bonn <jonas@southpole.se>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux@openrisc.net, linux-kernel@vger.kernel.org,
        paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org
Date: Wed, 14 Mar 2012 15:43:02 +0100
In-Reply-To: <11556.1331723400@redhat.com>
References: <CACM3HyHaFqVBaALMNB9dTE+7JrT1qD0jrYtV2PzwTskv8sW4Hg@mail.gmail.com>
	 <20120312233602.13888.27659.stgit@warthog.procyon.org.uk>
	 <20120312233858.13888.34822.stgit@warthog.procyon.org.uk>
	 <201203130900.41993.arnd@arndb.de> <11556.1331723400@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 36182-08480
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2012-03-14 at 11:10 +0000, David Howells wrote:
> Jonas Bonn <jonas.bonn@gmail.com> wrote:
> 
> > --- a/include/asm-generic/bitops/atomic.h
> > +++ b/include/asm-generic/bitops/atomic.h
> > @@ -2,7 +2,6 @@
> >  #define _ASM_GENERIC_BITOPS_ATOMIC_H_
> > 
> >  #include <asm/types.h>
> > -#include <asm/system.h>
> > 
> >  #ifdef CONFIG_SMP
> >  #include <asm/spinlock.h>
> 
> That's actually done in patch 33.  I wouldn't want to remove that if I can
> avoid it until after all the arches have been altered.

OK, fair enough.

Am I right in thinking that OpenRISC is the only architecture the
depends on the changes in asm-generic?  If yes, I could take this series
and hold off on the pull request until after the rest of your changes go
in.  Either way, it seems that OpenRISC will break for a bit...

The error I get while building (if asm/system.h is included) is a
circular dependency that I don't see that I can easily resolve:

  CC      arch/openrisc/kernel/asm-offsets.s
In file included from include/asm-generic/switch_to.h:17:0,
                 from arch/openrisc/include/generated/asm/switch_to.h:1,

from /home/jonas/openrisc/linux/arch/openrisc/include/asm/system.h:5,
                 from include/asm-generic/bitops/atomic.h:5,

from /home/jonas/openrisc/linux/arch/openrisc/include/asm/bitops.h:55,
                 from include/linux/bitops.h:22,
                 from include/linux/signal.h:38,
                 from arch/openrisc/kernel/asm-offsets.c:26:
include/linux/thread_info.h: In function ‘set_ti_thread_flag’:
include/linux/thread_info.h:64:2: error: implicit declaration of
function ‘set_bit’
include/linux/thread_info.h: In function ‘clear_ti_thread_flag’:
include/linux/thread_info.h:69:2: error: implicit declaration of
function ‘clear_bit’
include/linux/thread_info.h: In function ‘test_and_set_ti_thread_flag’:
include/linux/thread_info.h:74:2: error: implicit declaration of
function ‘test_and_set_bit’
include/linux/thread_info.h: In function
‘test_and_clear_ti_thread_flag’:
include/linux/thread_info.h:79:2: error: implicit declaration of
function ‘test_and_clear_bit’
include/linux/thread_info.h: In function ‘test_ti_thread_flag’:
include/linux/thread_info.h:84:2: error: implicit declaration of
function ‘test_bit’
In file included
from /home/jonas/openrisc/linux/arch/openrisc/include/asm/bitops.h:55:0,
                 from include/linux/bitops.h:22,
                 from include/linux/signal.h:38,
                 from arch/openrisc/kernel/asm-offsets.c:26:
include/asm-generic/bitops/atomic.h: At top level:
include/asm-generic/bitops/atomic.h:65:20: warning: conflicting types
for ‘set_bit’
include/asm-generic/bitops/atomic.h:65:20: error: static declaration of
‘set_bit’ follows non-static declaration
include/linux/thread_info.h:64:2: note: previous implicit declaration of
‘set_bit’ was here
include/asm-generic/bitops/atomic.h:86:20: warning: conflicting types
for ‘clear_bit’
include/asm-generic/bitops/atomic.h:86:20: error: static declaration of
‘clear_bit’ follows non-static declaration
include/linux/thread_info.h:69:2: note: previous implicit declaration of
‘clear_bit’ was here
include/asm-generic/bitops/atomic.h:127:19: error: static declaration of
‘test_and_set_bit’ follows non-static declaration
include/linux/thread_info.h:74:9: note: previous implicit declaration of
‘test_and_set_bit’ was here
include/asm-generic/bitops/atomic.h:151:19: error: static declaration of
‘test_and_clear_bit’ follows non-static declaration
include/linux/thread_info.h:79:9: note: previous implicit declaration of
‘test_and_clear_bit’ was here
In file included
from /home/jonas/openrisc/linux/arch/openrisc/include/asm/bitops.h:56:0,
                 from include/linux/bitops.h:22,
                 from include/linux/signal.h:38,
                 from arch/openrisc/kernel/asm-offsets.c:26:
include/asm-generic/bitops/non-atomic.h:103:19: error: static
declaration of ‘test_bit’ follows non-static declaration
include/linux/thread_info.h:84:9: note: previous implicit declaration of
‘test_bit’ was here
make[1]: *** [arch/openrisc/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2

/Jonas

