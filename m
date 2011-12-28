Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1L1QlC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:41:02 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:55630 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1L1QlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:41:01 -0500
Date: Wed, 28 Dec 2011 20:40:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
Message-ID: <20111228164055.GR27266@moon>
References: <20111223124741.711871189@openvz.org>
 <20111223124920.661126615@openvz.org>
 <20111228160655.GL17712@google.com>
 <20111228161809.GQ27266@moon>
 <20111228162653.GM17712@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111228162653.GM17712@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 08:26:53AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 28, 2011 at 08:18:09PM +0400, Cyrill Gorcunov wrote:
> > Hi Tejun, thanks for comment! Yes, XOR is useless here in security meaning,
> > but it simply breaks impression that these generating numbers "mean" somthing
> > (I remained them as Vasily asked).
> 
> But that comes at the cost of creating the impression that the XOR
> does something, which doesn't seem like a good situation.  e.g. Why do
> we need per-domain XOR random keys for then?  That code now doesn't
> mean anything.
> 

Strictly speaking, yes, we don't need per-domain keys, one would be enough,
I left them here just to add some more entropy in IDs. And comment in code
and in proc.txt mention pretty clearly (I hope) that one should interpret
the IDs as a string of bytes rather than a number to be on a safe side since
one day the generating algorithm might be changed (I dont think there will be
a need, but still better to warn users and give them a safe way).

> > I personally fine to simply leave plain pointers here and root-only access
> > since that is enough for us (and our tool will require root privileges
> > anyway :)
> > 
> > OTOH, we could add some sha2 here with pointer+cookie as an initial value but I fear
> > this will bring more code comlexity and computing sha2 hash is not that
> > fast operation, which should be taken into account (note on x86-32 since
> > pointers are 32bit values one could compute prehash for all space covered
> > and if an attacker will know somehow cookie value the hash will be easily
> > broken, not sure if it's really usefull for someone, since if you have root
> > access to the machine such IDs will be the last thing attacker should be
> > interested in :)
> 
> We have the whole crypto subsystem dealing with this.  It sure would
> be more complex than ^ operator but it's not like you have to open
> code the whole thing.  Is it really that complex to use?

No, Tejun, the use of crypto engine is not hard but it means more memory
consumption (one need to carry resulting hashes and print them out into
/proc) and more cpu consuption while we really need some fast and cheap
solution. Unlike other usage of crypto engine (such as encoding for net
layer, iirc ipsec uses it) I'm not really convinced we should use that
heavy artillery here ;)

> 
> > And it seems noone except us need this interface yet, so maybe sticking with
> > "pointer exported under root-only" would be enough?
> 
> Maybe, dunno.  But even if it's gonna be raw pointer or XOR'd value
> for now, I would suggest exporting it in the form which can be
> replaced by proper hash in the future.  ie. Don't let userland assume
> it's 32bit or 64bit value.
> 

I see, I could use some other form of output, it's not a problem. The main
problem which interface community prefer, should I really switch to crypto
usage or we can leave with root-only+plain-pointer approach?

	Cyrill
