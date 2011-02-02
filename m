Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1BBRqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 12:46:17 -0500
Received: from mail.codesourcery.com ([38.113.113.100]:35439 "EHLO
	mail.codesourcery.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1BBRqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 12:46:16 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Feb 2011 12:46:15 EST
Date: Wed, 2 Feb 2011 17:39:32 +0000 (UTC)
From: "Joseph S. Myers" <joseph@codesourcery.com>
X-X-Sender: jsm28@digraph.polyomino.org.uk
To: Richard Guenther <richard.guenther@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        linux-kernel@vger.kernel.org, gcc@gcc.gnu.org,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: ARM unaligned MMIO access with attribute((packed))
In-Reply-To: <AANLkTin6qEeN7XZuwePNWqS8i_aDY586V+sOqgD5pPQA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1102021728350.18796@digraph.polyomino.org.uk>
References: <201102021700.20683.arnd@arndb.de>
 <AANLkTin6qEeN7XZuwePNWqS8i_aDY586V+sOqgD5pPQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Feb 2011, Richard Guenther wrote:

> The pointer conversions already invoke undefined behavior as specified by the
> C standard (6.3.2.3/7).

I would say: the conversions are undefined if the pointer is 
insufficiently aligned for any of the pointer types involved (source, 
destination or intermediate), where the appropriate alignment for a packed 
type is 1.  Thus, the conversion from packed to non-packed is OK iff the 
pointer target is sufficiently aligned for the non-packed type.

In general from a sequence of casts the compiler is permitted to deduce 
that the pointer is sufficiently aligned for whatever type in the sequence 
has the greatest alignment requirement (the middle-end may not have that 
information at present, but the front end could insert some form of 
alignment assertion if useful for optimization).  *But* that is what is 
permitted in standards terms; it is not necessarily safe in practice.  In 
particular, on non-strict-alignment targets such as x86 people do in 
practice assume that unaligned accesses are OK at the C level, not just 
the assembly level (glibc does so, for example), so it might be a bad idea 
to assume alignment in a way that would cause that to break.

-- 
Joseph S. Myers
joseph@codesourcery.com
