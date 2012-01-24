Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab2AXUVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 15:21:31 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:43071 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab2AXUVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 15:21:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Dave Hansen <haveblue@us.ibm.com>, sukadev@linux.vnet.ibm.com,
        Andy Whitcroft <apw@canonical.com>, Matt Helsley <matthltc@us.ibm.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC] fix devpts mount behavior
References: <20120124000517.GA28878@sergelap>
	<CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
	<20120124002555.GA29534@sergelap>
	<CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
	<20120124010758.GJ23916@ZenIV.linux.org.uk>
Date: Tue, 24 Jan 2012 12:24:01 -0800
In-Reply-To: <20120124010758.GJ23916@ZenIV.linux.org.uk> (Al Viro's message of
	"Tue, 24 Jan 2012 01:07:58 +0000")
Message-ID: <m1k44gj1cu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19CLR31mTD0ssPQE3fFHY/bB/TMhBVHc/I=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Mon, Jan 23, 2012 at 04:41:25PM -0800, Linus Torvalds wrote:
>
>> Right. I think the opportunity for problems should be pretty small.
>> 
>> And it's not like the pty itself wouldn't continue to work - it's just
>> that programs like /usr/bin/tty wouldn't be able to *find* it.
>> 
>> Although who knows - maybe there is some other subtle interaction.
>
> FWIW, the subtle and nasty part in all that is  that you can mknod /dev/ptmx
> and it *will* work, refering to the "initial" instance.  That's what
> concerns me about the chroot scenarios -
> 	mknod /jail/dev/ptmx c 5 2
> 	mkdir /jail/dev/pts
> 	mount -t devpts /jail/dev/pts
> 	chroot /jail
> works fine right now, but with that change behaviour will be all wrong -
> opening /dev/ptmx inside of jail will grab you a pts, all right, but
> it will *not* show up in (jail) /dev/pts/* as it does with the current
> kernel.
>
> Note that if you replace that mknod with symlink pts/ptmx /jail/dev/ptmx
> the things will keep working.  However, that will _only_ work for kernels
> with DEVPTS_MULTIPLE_INSTANCES - without it you won't get ptmx inside
> devpts (which is arguably wrong, BTW)

For testing I would recommend looking at the distro chroot build cases.

It looks like relatively recent udev still creates /dev/ptmx and does
not create the symlink.  So we might get into the awkward situation of
/dev/ptmx not matching /dev/pts/ptmx with something as simple as
initramfs mounting /dev/pts and then initscripts mounting /dev/pts.

Eric
