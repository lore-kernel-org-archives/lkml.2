Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab1ASELz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 23:11:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57035
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752409Ab1ASELy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 23:11:54 -0500
Date: Tue, 18 Jan 2011 20:12:27 -0800 (PST)
Message-Id: <20110118.201227.116359736.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: R_SPARC_13
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110118.130027.28804895.davem@davemloft.net>
References: <4D3570D7.2090000@oldelvet.org.uk>
	<1295356994.20446.3.camel@duncow>
	<20110118.130027.28804895.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 18 Jan 2011 13:00:27 -0800 (PST)

> I'll look into fixing binutils so that it properly reports the
> correct R_SPARC_OLO10 relocation in dumps.  There really is no
> excuse for what it's currently doing.  In fact, I think this
> quirk has sent me on wild goose chases in the past.

Ok, after looking into it I got reminded why this is still behaving
the way that it is.

The problem is that R_SPARC_OLO10 relocations have 2 addends instead
of one.  But the BFD libraries generic "arelent" structure only has
room to store one of the addends.

So the 64-bit ELF Sparc backend emits R_SPARC_OLO10 as R_SPARC_LO10 +
R_SPARC_13 internally solely for the purpose of being able to store
the second addend away somewhere.

This all happens in the relocation table slurping code in
bfd/elf64-sparc.c, and this is what objdump uses to get it's info.
BTW, readelf prints the relocations of this type properly and
without this weird translation.

I considered several avenues to make this translation scheme
unnecessary.

Making arelent larger in order to store the second addend would be
frowned upon since only 64-bit sparc needs it but the space cost would
be eaten by everyone.

The other idea was to somehow make the existing addend field smaller
on 64-bit so we could add the second addend storage to arelent at
zero cost.  But after studying the binutils code I'm pretty sure
that the addend field really does need to be a full 64-bits.

This really needs to be fixed for another reason, which is that this
scheme requires allocating twice as much memory to store relocations
internally.  This is because we have to size the internal relocation
table in BFD before we scan the table and know if any R_SPARC_OLO10
compound relocs actually exist and if so how many.

An even worse case is MIPS 64-bit, where every relocation expands to
3 (?!?!) internal BFD relocation objects.

Anyways just a detailed brain dump on what the situation is with this,
I'll see if I can come up with other ideas.

