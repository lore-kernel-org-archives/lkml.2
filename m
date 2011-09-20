Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1ITDHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 23:07:54 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40653 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753730Ab1ITDHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 23:07:53 -0400
X-Sasl-enc: 31A1D3WilPG8D05ccGrQrFNwT6aLt5494AlHbLeiDmNy 1316488072
Subject: Re: [PATCH] Force same size of struct autofs_v5_packet on x86 and
 x86_64
From: Ian Kent <raven@themaw.net>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com
In-Reply-To: <CACCE520-D261-4B97-B208-1C44574886BF@m3y3r.de>
References: <1316167604.6545.84.camel@localhost.localdomain>
	 <20110916101903.GI2203@ZenIV.linux.org.uk>
	 <1316169496.8502.6.camel@perseus.themaw.net>
	 <1316332908.5814.22.camel@localhost.localdomain>
	 <1316404368.3206.21.camel@perseus.themaw.net>
	 <20110919061059.GJ2203@ZenIV.linux.org.uk>
	 <CACCE520-D261-4B97-B208-1C44574886BF@m3y3r.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Sep 2011 11:07:47 +0800
Message-ID: <1316488068.3110.15.camel@perseus.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 11:30 +0200, Thomas Meyer wrote:
> Am 19.09.2011 um 08:10 schrieb Al Viro:
> 
> > On Mon, Sep 19, 2011 at 11:52:48AM +0800, Ian Kent wrote:
> > 
> >>> btw. where are the padding bytes are added? how to tell gcc to display
> >>> this?
> >> 
> >> It's also been a long time since I looked into this so I don't remember
> >> the processor alignment details.
> >> 
> >> Not sure if there is a compiler option that would report this, sorry,
> >> anyone else?
> > 
> > Padding is added in the very end.  The thing is, it's not a misaligned
> > field per se; they all have a natural alignment in there.  It's that
> > __u64 ino has alignment 8 on amd64 and alignment 4 on i386.  So the alignment
> > requirements for the entire structure are different - on amd64 the address
> > of the entire thing must be a multiple of 8 and on i386 it can be any multiple
> > of 4.  IOW, on i386 you can just put them one after another in e.g. an array
> > (the size without any padding is 300 bytes) and on amd64 you need 4 bytes
> > of padding added between them.  I.e. sizeof needs to go up by 4, with the
> > padding added in the end.
> 
> okay. that's what I thought.
> 
> @Ian: Is the read() from the pipe fd the only way to consume this structure from userspace?

No, a pipe has been the way it has been done since before I started
maintaining the autofs code. I did try to start moving toward using
netlink but found that it wouldn't work without a major re-write of the
daemon which I decided not to do. At that time netlink wouldn't have
included the mount callback but, if it had worked, would have eventually
done so. So, until I decide to do such a huge re-write we are stuck with
this.

> 
> if so: why not align the size of this structure for x86 and x86_64 to the same size?
> 
> the systemd compiled for x86_64 will probably work with this change,
> but does maybe report something like a short read or so, as it
> currently expects 304 bytes to read.
> i didn't test this yet.

What do you mean?

This problem is only evident where the compiled binary arch is different
from the kernel compiled arch. Like when you run i386 (or i686) binaries
on an x86_64 arch with an x86_64 install or ppc binaries on a ppc64
install. The common case of using like binaries on like arch works fine
as far as I know.

> 
> @al: what other autofs4 users are out there besides systemd?

autofs and autodir as far as I know but then systemd started using the
direct mount feature of the kernel autofs module and no-one asked me for
advice so I didn't know about it for a long time. Maybe if someone did
we could have had this conversation at a more appropriate time.

Ian


