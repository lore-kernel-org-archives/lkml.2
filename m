Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab1FKMZk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 08:25:40 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:40544 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab1FKMZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 08:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=GrDGdFPaB9T0YUUtZ968eis14xc49ADQylX+xXWUHiX6ULx+6cAN9MYItK2wTg+NWD
         QJ1om+pXSvmpOCoEXck2OG1qZGD1wt/vRgnm29C4qEHg+pSAS6KatFRdqurwkHlJvdf+
         1jw6AiAiqrX1vCAxnqLps4uNuYKzGigDMYnjw=
MIME-Version: 1.0
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Sat, 11 Jun 2011 14:24:58 +0200
Message-ID: <BANLkTi=esg7i8PeCJ9LpVfcNKFGb_dAYCg@mail.gmail.com>
Subject: Summary Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: "Ted Ts'o" <tytso@mit.edu>, "D. Jansen" <d.g.jansen@googlemail.com>,
        david@lang.hm, Oliver Neukum <oneukum@suse.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, njs@pobox.com, bart@samwel.tk,
        Stewart Smith <stewart@flamingspork.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems unlikely that an automatic workaround for fsync will make it
into kernel for laptop mode, as none of the kernel maintainers seem to
think this is a good idea.

But it seems it makes sense to provide write barrier support for user
space. This would not be a write barrier as the kernel provides it for
kernel space atm
(https://docs.fedoraproject.org/en-US/Fedora/14/html/Storage_Administration_Guide/writebarr.html).

But it would be an interface that lets userspace tell the kernel that
certain writes must be committed before other writes, without the need
for flushing as fsync does. This could provide a benefit especially
for databases.

The idea is that writes, which are dependent on each other in the way
that one write may make a file unreadable or lead to data loss if it
is committed to disk in the wrong order, can be queued. This way the
heavy fsyncs with their corresponding flush can be avoided.

As Stewart wrote:

"Some of them [databases] in some situations could. For those used by
applications to
store data (such as how sqlite is commonly used) - it could be *great* -
especially for laptop mode. The kernel can then flush this all out any
time it wants - preserving barriers of course. If filesystem can do
atomic writes (btrfs?) then it could combine barriers into less overall
work (e.g. write block 1, barrier, repeat 10 times can turn into 1 block
write of block 1).

For database systems that tend to take over the whole system (such as
InnoDB (MySQL and Drizzle), MySQL Cluster, PostgreSQL, Oracle) - the
possibility of using such a barrier call is small. There are good
reasons why database systems manage all their own buffers and flushing -
we have a *LOT* more knowledge about the data than the kernel will ever
have and so we can make much better decisions about what to flush and
when."

On Thu, Jun 2, 2011 at 9:42 AM, D. Jansen <d.g.jansen@googlemail.com> wrote:
>
> On Tue, May 31, 2011 at 4:03 AM, Ted Ts'o <tytso@mit.edu> wrote:
> > The real fix is that applications need to be fixed to be less
> > write-happy.
>
> So do you agree to export barriers to user space? Because as you said
> yourself, that would be the only way for apps to avoid fsync without
> losing data safety. And since you want the problem fixed with the
> apps, we need to provide them with the means to do so, right?
