Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387Ab0HQV3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:29:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55907 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750789Ab0HQV3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:29:47 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTik9qUf_F0NDoW2SBjWGHk2=ZdvkLrCORu3gGa2o@mail.gmail.com>
References: <20100816.211218.189709876.davem@davemloft.net>
 <AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
 <AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com>
 <AANLkTinO5yip7agVO3Lq3YLjDYmkB9MP14xjt3TusMfW@mail.gmail.com> <AANLkTik9qUf_F0NDoW2SBjWGHk2=ZdvkLrCORu3gGa2o@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 14:28:49 -0700
Message-ID: <AANLkTikcaVKnJxC18tUcJRTQwAukYhPdWMgGGrNaVjM_@mail.gmail.com>
Subject: Re: tasks getting stuck on mmap_sem?
To: Tony Luck <tony.luck@intel.com>
Cc: David Miller <davem@davemloft.net>, Michel Lespinasse <walken@google.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, and it strikes me when looking at the sparc rwsem-const.h that it
has some unsigned constants in it. I think

  #define RWSEM_WAITING_BIAS              0xffff0000

is actually unsigned, because it's a hex constant that doesn't fit in
a signed int. So it's of type 'unsigned int' if I recall the C type
rules right.

(That's one of the really _subtle_ C type rules: hex constants
actually act differently from decimal constants).

So now RWSEM_ACTIVE_WRITE_BIAS is unsigned too.

The x86 constants are all explicitly signed.

Btw, Michel sent out an email saying:

  FYI, I just verified that RWSEM_WAITING_BIAS is defined as signed on
  all architectures except for ia64. So, this would be consistent with
  the issue being observed only on ia64.

but I think he missed that subtlety of the C type system. Other architectures do

  #define RWSEM_WAITING_BIAS             (-0x00010000)

which is indeed signed, but Sparc is unsigned despite the lack of a "u".

Of course, maybe I only _think_ I know all the C typing rules. I might
be full of sh*t. It happens..I didn't actually look them up.

             Linus


                  Linus
