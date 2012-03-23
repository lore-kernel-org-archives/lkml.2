Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932160Ab2CWQij (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 12:38:39 -0400
Received: from static.78-46-68-141.clients.your-server.de ([78.46.68.141]:56580
	"HELO eristoteles.iwoars.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1753856Ab2CWQig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 12:38:36 -0400
Date: Fri, 23 Mar 2012 17:38:32 +0100 (CET)
From: Joel Reardon <joel@clambassador.com>
X-X-Sender: joel@eristoteles.iwoars.net
To: Artem Bityutskiy <dedekind1@gmail.com>
cc: linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] Add design document for UBIFS secure deletion
In-Reply-To: <1332517132.18717.102.camel@sauron.fi.intel.com>
Message-ID: <alpine.DEB.2.00.1203231705500.22944@eristoteles.iwoars.net>
References: <alpine.DEB.2.00.1202091615540.26924@eristoteles.iwoars.net>    <1329152067.22240.214.camel@sauron.fi.intel.com>    <alpine.DEB.2.00.1202231558400.13720@eristoteles.iwoars.net>    <alpine.DEB.2.00.1202231628360.13720@eristoteles.iwoars.net>  
 <1331277476.22872.2.camel@sauron.fi.intel.com>   <alpine.DEB.2.00.1203191752300.22256@eristoteles.iwoars.net>  <1332346218.14983.20.camel@sauron.fi.intel.com>  <alpine.DEB.2.00.1203231448520.22944@eristoteles.iwoars.net>
 <1332517132.18717.102.camel@sauron.fi.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll answer some quickly here now while they're fresh in mind and add them
to the doc later.

>
> > In particular, it does not behave like a
> > +log-structured file system: when a KSA LEB is updated, its contents are
> > +written to a new physical location on the flash memory, UBI's logical map is
> > +then updated to this new physical address and the previous version of the KSA
> > +LEB is then erased.
>
> Am I right that you basically wanted to say that when you update a KSA
> LEB, you make sure that the physical flash does not contain the old
> contents of this LEB? Would be nice to re-phrase.
>
> Side question - how do you do this?

Here I'm just spelling out atomic update, so nothing fancy except
leb_change() to replace the keys.

>
> > Thus, except while updating the KSA, only one copy of the
> > +data in the KSA is available on the storage medium.  When the file system is
> > +created, cryptographically-suitable random data is written from random_bytes()
> > +to each of the KSA's LEBs and all the keys are marked as unused. Purging
> > +writes new versions of the KSA LEBs using UBI's atomic update feature.
>
> Just a general question about: I guess you have to call ubi_sync() then
> to make sure the old version is actually erased, right?

There was an ioctl I think I was using, but I suspect ubi_sync is
more elegant. Is it already performed after UBIFS commit?

>
> Read this far, and have 2 big questions:
>
> 1. How keys are marked as deleted (I guess in some in-memory data
> structure)
> 2. When deleted keys are removed from the medium (probably on commit?)

1. Yeah, 2bit for key state
2. During commit, the KSA LEBs are rewritten.

>
> I guess I'll find the answers below.
>
> > +When a new data node is written to the storage medium, an unused key is
> > +selected from the KSA and its position is written to the data node's header.
>
> Questions arises - how the key is selected?

Assigns the next unused key and keeps track of where it was to search
onwards.

>
> > +The keys are in a protected area of the file system, so only users with root
> > +access to the storage medium are capable of reading the keys that encrypt
> > +data.
>
> Hmm, what is the protected area? What prevents anyone from reading them
> by finding them in /dev/ubiX_Y or /dev/mtdZ ?

Protected as in the kernel stops joe user from reading raw from /dev/mtd,
no? Of course anyone with physical access can get the keys, so the
security relys on these keys being securely deleted, but anyhow keeping
live keys out of the filesystem also helps.

>
> Hmm, why is it necessary to re-initialize unused keys?
>

This can be a mount option actually, it was a response to  attack that was
proposed to me about the design. The idea here is that, suppose the
attacker reads the drive at time X with sufficient privilages to read the
keys. Then the attacker will know for certain that those keys will
eventually be used to encrypt data. So they can compromise not only the
current data, but also future data. By replacing unused keys, the attacker
is limited only to compromizing current data.

>
> Is it 2 bits per key?
>

In development it was 32bits :). But its now properly 2bits per with
bitwise ops for accessing.
>
> I guess you do not enforce these rules, you just rely on the randomness?

Yep, so the conditions need only hold with cryptographically high
probability.

>
> You'd also need to teach mkfs.ubifs to write correct KSA.
>

Ah, yes! Any other tool?

>
> Hmm, interesting how you manage checkpoints. I guess the easiest would
> be to have a special inode (not visible for users) and store checkpoints
> there?
>

The first block of the KSA stores only checkpoints, so KSA size is 1 +
minrequired + some slack. So this may need the multiple LEB
approach for one of the other UBIFS areas when its size is too big, but I
havn't done that since its generally so highly compressable that it
wasn't ever a concern.

Cheers,
Joel Reardon
