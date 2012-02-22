Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab2BVQLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 11:11:06 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50001 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2BVQLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 11:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <4F4484F0.9070501@zytor.com>
References: <CA+55aFzhS69QSoN1j+Z2md116u+3OfniAoE0QMo6xyBjDyjbEw@mail.gmail.com>
 <20120221.221609.218135609185671883.davem@davemloft.net> <CA+55aFwvmZGDzO_8wwYfH8HsLE=qCmLkJfeMyCe4PVvOYbDMHQ@mail.gmail.com>
 <CA+55aFzv3X3yW8WZGMZO+aKa=qWi2w8=zn2DP-Q3jRry8Ermyw@mail.gmail.com>
 <CA+55aFyh1NmBt0LwR3+iD6B-Xa8wAs-nGJ0MBouPhTzWUi8W5g@mail.gmail.com>
 <1329889428.2193.45.camel@perseus.themaw.net> <4F4484F0.9070501@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 22 Feb 2012 08:10:42 -0800
X-Google-Sender-Auth: jdWh_JNFB5oKqCZSOsJw-J24ACA
Message-ID: <CA+55aFwUvuaGdnpwVQLQLF=DdqROmKqz65v+_DXHbebNhPqkLg@mail.gmail.com>
Subject: Re: compat: autofs v5 packet size ambiguity - update
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ian Kent <raven@themaw.net>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        Thomas Meyer <thomas@m3y3r.de>, Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 10:02 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Note that it's really rather unfortunate that this transmits the entire
> packet no matter what, which also means that the "len" field is actually
> completely and totally pointless.

Yes.

> I have mentioned in the past that I consider it a design mistake on my
> part to have used a pipe in the first place: it was "so easy", but
> required an extra read for no good reason, or padding to fixed size
> resulting in this problem.  The right thing really should have been to
> use a Unix datagram socket; these days using SOCK_SEQPACKET - that way
> the kernel would give you the right semantics by design.

Well, the kernel gives the right semantics for pipes too - writes are
guaranteed to be "atomic", so even in the presence of multiple writers
you can trivially do packetized data.

You just have to (a) add the length to the packet and (b) do the
length+packet write as a single write (which is limited to PIPE_SIZE -
4kB - for the atomicity guarantee).

If you don't have multiple concurrent writers without locking, the (b)
part falls away entirely, of course.

Yes, for the reader side you need to be able to handle the fact that
you can get more than one packet in one read() call, but sorting that
out isn't hard either.

But yeah, writing fixed-size data and then having a reader that reads
fixed-size data is just not a very good approach. It's doubly bad when
the "fixed size" isn't an explicit size that is documented in the
protocol, but depends on data structures.

                               Linus
