Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab1EWNGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:06:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60719 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1EWNGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:06:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Fpx3TM5pGfNuP4oZBlok/2fbhAHw3MJeMFd/2nAw/mkwkgCdI6Y2txjqjpHztsDLvI
         wClcHKcDe/iYvyJKi0+ucRpg/5GrXhrhk3WvCUjE6vgvqD73EfJloLUMsex3FVKhXA9r
         8GS/5tCFLoHzHDnPL3x4W0haVIl5pJOU8QEl4=
MIME-Version: 1.0
In-Reply-To: <201105231012.06928.oneukum@suse.de>
References: <BANLkTikGxbcMBD=3W_9_mpZBoVDc8HrX8A@mail.gmail.com>
 <BANLkTikVLFMX_U6brQ5OALbvJkOGuz6++Q@mail.gmail.com> <20110522004833.GY32466@dastard>
 <201105231012.06928.oneukum@suse.de>
From: "D. Jansen" <d.g.jansen@googlemail.com>
Date: Mon, 23 May 2011 15:05:50 +0200
Message-ID: <BANLkTiks7U28D1896318rK0j=W-tux1uJA@mail.gmail.com>
Subject: Re: [rfc] Ignore Fsync Calls in Laptop_Mode
To: Oliver Neukum <oneukum@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, tytso@mit.edu
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 10:12 AM, Oliver Neukum <oneukum@suse.de> wrote:
>> > 3. A lib doesn't fix the ordering guarantee problem.
>>
>> A properly implemented filesystem will not have ordering problems
>> just because fsyncs are not issued.
>
> But user space will have this problem. A single task's sequence of
> write(); fsync(); write(); does give an implicit guarantee of ordering
> to user space. To keep that guarantee, you need kernel support,
> because only the kernel can issue the necessary barrier/flush commands.
> A filesystem is not required to make sure your writes hit the disk
> in the order you issued them, unless you use fsync, which gives
> an even larger guarantee, but also implies ordering.

If this is correct, we do need some form of kernel support. To ensure
that one fsync means the write comes before another. Because how would
it be implemented in user space to ensure write ordering without
fsync? The library could only request the kernel to enforce write
ordering. Otherwise it would have to catch and buffer all writes
itself and then commit them with fsyncs in between. _That_ doesn't
sound like a good idea at all...

And the alternative would be that a write of
1. XXXXXXXXXXXXXXXX (file)
2. XXHHHHHXXXXXXX (write H)
3. XXHHHNNNNXXXX (write N)

would become
1. XXXXXXXXXXXXXXXX (file)
2. XXXXXXNNNNXXXX (write N)
3. XXHHHHHNNXXXX (write H)

And we have data that was never supposed to be on disk this way...
