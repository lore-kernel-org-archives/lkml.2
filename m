Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0F3LrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 07:47:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54991 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0F3LrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 07:47:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 13:46:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: viro@zeniv.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
       mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
       sjayaraman@suse.de, linux-ext4@vger.kernel.org
References: <201006301131.37241.arnd@arndb.de> <25470.1277888151@redhat.com> <29346.1277892068@redhat.com>
In-Reply-To: <29346.1277892068@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006301346.41902.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19L4Gtf5/NgZ+lphSEVS6G5EqjjgYUE/wUErHY
 /L4E44xY48bJY1j6Z9qonbCZhUZ9+xeWED5H50peWsqpnqkr4J
 v0vuEhpI7CmP2dyYsFv8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 June 2010, David Howells wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> > No, I think that would be worse than the current version. But if you remove
> > the structure version in favor of the flags, you only need six arguments
> > anyway.
> 
> I want to keep the structure version, just in case we need to expand fields in
> the stat struct in future.  Otherwise we may need to create yet another stat
> syscall.

How many versions do you expect we need in the next 10 years, not counting
those where you just add a new field to the structure?

Given a 64 bit flag word, you can start using bits for the version from
the top and bits from the bottom for fields:

#define XSTAT_DEV  0x00000001
#define XSTAT_INO  0x00000002
#define XSTAT_MODE 0x00000004
...
#define XSTAT_LAYOUT_VERSION_2 0x8000000000000000
#define XSTAT_LAYOUT_VERSION_1 0x0000000000000000

> > You can also go further and fold the structure length into flags, because
> > the length is just a function of the data you are passing.
> 
> The potential problem with passing the flags as a syscall argument is that
> we're then limited to a single 32-bit integer.  It might be enough, but if I
> do as at least one person has suggested and assign each field in the struct
> its own bit, that uses up half right there, plus I'd like to add at least one
> operational flag (to force synchronisation with the server).

I'd imagine that there would be some reasonable way to group some of the
fields so that 32 bits last long enough. Alternatively, you can also make
it a 64 bit argument everywhere, which has some other small disadvantages.

> > Having a system call with flags, size and version is like wearing a belt,
> > braces and suspenders. An unsigned long flags argument should be enough to
> > hold up your pants[1].
> 
> I would like the size argument for two reasons: firstly, to prevent buffer
> overruns and, secondly, because I can see some scope for variable-size fields
> (such as for volume IDs or security labels), though the latter might be better
> handled through getxattr() (which would mean extra overhead).

The idea of a syscall API with multiple fixed-length and variable-length
fields in the same structure scares me. If you want to go this far,
it may be better to base the interface on netlink and allow querying
multiple files at once.

For a classic syscall interface, I'd just stay away from variable-length
data and use either fixed-length fields or spend the extra overhead for
the getxattr values.

When all members of struct xstat are fixed length, you can simply add
new members at the end and add the associated flags at the same time.
Any code built against a given header file can only ask for the fields
that are part of the struct definition it uses. The kernel should
obviously only write the fields that the user asked for, in case the
user was built against an older header file. You can also maintain
forward compatibility if the kernel sets a bitmask in the struct with
the fields it has returned.

	Arnd
