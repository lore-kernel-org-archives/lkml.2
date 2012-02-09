Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771Ab2BIRqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:46:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47693 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab2BIRqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:46:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com>
References: <CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com> <20120209154819.32070.93358.stgit@warthog.procyon.org.uk> <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reduce the number of expensive division instructions done by _parse_integer()
Date: Thu, 09 Feb 2012 17:46:07 +0000
Message-ID: <7095.1328809567@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Looking at the code generated, the "val >> 60" thing actually does
> generate a shift, and at least on x86-64, the attached patch generates
> better code.

On fixed-size instruction arches, the runtime shift is probably the better
option, as simply loading 64-bit large constant would take likely take at
least four instructions - and might involve a shift anyway.  On the other
hand, it seems the compiler can optimise your suggestion fairly well.  In both
cases, the 64-bit arithmetic can be reduced to 32-bit arithmetic on the MSW
only on 32-bit arches.

On x86_64 we have:

  400649:       48 89 d8                mov    %rbx,%rax
  40064c:       48 c1 e8 3c             shr    $0x3c,%rax
  400650:       48 85 c0                test   %rax,%rax
  400653:       75 52                   jne    4006a7 <_parse_integer+0xa7>

And on i386 we have:

 8048532:       8b 54 24 14             mov    0x14(%esp),%edx
 ...
 8048538:       89 c7                   mov    %eax,%edi
 804853a:       c1 ea 1c                shr    $0x1c,%edx
 804853d:       85 d2                   test   %edx,%edx
 804853f:       75 79                   jne    80485ba <_parse_integer+0xda>

With your code, we have on x86_64:

  40062d:       49 bf 00 00 00 00 00    movabs $0xf000000000000000,%r15
  400634:       00 00 f0 
  ...
  400659:       4c 85 fb                test   %r15,%rbx
  40065c:       75 59                   jne    4006b7 <_parse_integer+0xb7>

And on i386:

 804853c:       89 c7                   mov    %eax,%edi
 804853e:       f7 44 24 1c 00 00 00    testl  $0xf0000000,0x1c(%esp)
 8048545:       f0 
 8048546:       75 79                   jne    80485c1 <_parse_integer+0xe1>

But it will work too.  And I like the pointer indirection removal as well.

I'm not sure there's a lot to choose between them, though I prefer mine as I
think it produces slightly smaller code.

Want me to wrap these changes up with my patch description?

David
