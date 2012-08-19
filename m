Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2HSPM6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:12:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38288 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2HSPMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:12:53 -0400
Date: Sun, 19 Aug 2012 16:12:51 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dan Luedtke <mail@danrl.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: Introducing Lanyard Filesystem
Message-ID: <20120819151251.GC23464@ZenIV.linux.org.uk>
References: <1345333117-2826-1-git-send-email-mail@danrl.de>
 <CAFLxGvwwAX=85hmgxg6qGTpp4YCppuj2mpw7GkB1eV8qhta2bg@mail.gmail.com>
 <1345371135.4441.2.camel@tunafish>
 <5030BC7E.3030000@gmail.com>
 <1345383264.4441.56.camel@tunafish>
 <20120819120254.GA2369@pompeji.miese-zwerge.org>
 <1345390432.2716.34.camel@tunafish>
 <20120819142732.GB23464@ZenIV.linux.org.uk>
 <1345395217.2716.58.camel@tunafish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345395217.2716.58.camel@tunafish>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 19, 2012 at 06:53:37PM +0200, Dan Luedtke wrote:
> > 	* minor point, but endianness-flipping in place is *the* way to get
> > hard-to-catch endianness bugs.  foo = cpu_to_le64(foo) is a bloody bad idea;
> > either use object for host-endian all along, or use it only for (in your
> > case) little-endian.
> I am not sure I understood this right.
> At what point should I convert e.g. the file size (little endian 64bit
> value stored on disk) to host endianess? When filling the inode?
> Is inode->i_size = le64_to_cpu(size) bad, too?

Conversions *in* *place* are bad.  The above is fine if you have 'size'
variable used only for little-endian values (and declare it __le64, then).
The thing is, thinking of endianness conversions as architecture-conditional
byteswaps is wrong.  Treat them as you would treat dealing with some
encoding; that's the reason why we have separate le64_to_cpu() and
cpu_to_le64(), even though they are identical as functions - on all
architectures we support.  And don't use the same variable for both the
host- and fixed-endian values; it's far too easy to get confused on
code modifications and get the situation when two code paths lead to
the same point, one with host-endian value in that variable and another
with fixed-endian.  Real fun to debug, especially when one of the codepaths
is rarely taken...
