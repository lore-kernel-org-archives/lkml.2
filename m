Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab1J1CxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 22:53:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37187 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1J1CxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 22:53:09 -0400
Message-ID: <1319770376.23112.58.camel@edumazet-laptop>
Subject: Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Oct 2011 04:52:56 +0200
In-Reply-To: <1319766293.6759.17.camel@deadeye>
References: <1319764761.23112.14.camel@edumazet-laptop>
	 <20111028012521.GF25795@one.firstfloor.org>
	 <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
	 <1319766293.6759.17.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 28 octobre 2011 à 02:44 +0100, Ben Hutchings a écrit :

> Whether or not it needs to provide any ordering guarantee, atomic_read()
> must never read more than once, and I think that requires the volatile
> qualification.  It might be clearer to use the ACCESS_ONCE macro,
> however.
> 

Where this requirement comes from ?

Maybe then introduce atomic_read_once() for users really needing it :)

ACCESS_ONCE will force the read/move instruction I try to avoid :(

By the way, removing volatile on my x86_64 defconfig saves a bit of
space :

# size vmlinux vmlinux.old
   text	   data	    bss	    dec	    hex	filename
10907585	2890992	1540096	15338673	 ea0cb1	vmlinux
10912342	2891056	1540096	15343494	 ea1f86	vmlinux.old

booted and everything seems fine, but obviously lightly tested...

Note : There is still one useless access to page-flags,
'fixing' atomic_read() is not enough.


    0,04 :        ffffffff815e4675:       je     ffffffff815e4870 <tcp_sendmsg+0xc80>
    0,08 :        ffffffff815e467b:       mov    (%r9),%rax   // useless
    2,08 :        ffffffff815e467e:       lock incl 0x1c(%r9)
    3,58 :        ffffffff815e4683:       mov    (%r9),%rax
    0,04 :        ffffffff815e4686:       test   $0x80,%ah
    0,00 :        ffffffff815e4689:       jne    ffffffff815e48ee <tcp_sendmsg+0xcfe>



