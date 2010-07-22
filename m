Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab0GVXBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:01:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730Ab0GVXBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:01:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1007221507180.16657@asgard.lang.hm>
References: <20100609183449.110905403@vyatta.com> <alpine.LFD.2.00.1006091144120.4506@i5.linux-foundation.org> 
	<20100609115403.75ebb6cb@nehalam> <alpine.LFD.2.00.1006091203190.4506@i5.linux-foundation.org> 
	<20100611103223.799d3ce0@nehalam> <20100721195547.GA3448@amt.cnet> 
	<AANLkTinffggNzVWn0sZ78wF3nwbEehoEuiVdxUP8MoE4@mail.gmail.com> 
	<alpine.DEB.2.00.1007221507180.16657@asgard.lang.hm>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 22 Jul 2010 16:00:43 -0700
Message-ID: <AANLkTikBhsUirA5B-7FiUZPJ7dj4elZVcnVl3l3_TzXY@mail.gmail.com>
Subject: Re: [RFC] floppy: use single threaded workqueue
To: david@lang.hm
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 3:22 PM,  <david@lang.hm> wrote:
>
> I don't use floopies much anymore, but I've got a fair number of machines
> around that have floppy drives (purchased across about 6 years with from a
> couple vendors and a variety of motherboards)
>
> If someone can go to the effort of documenting what testing you want done I
> may be able to do it.

It doesn't really need to be all that extensive. The "interesting"
operations tend to be (apart from just reading and writing data, of
course):

 - formatting a floppy (it's special, and historically relatively
often broke without people noticing for a while)

 - the floppy format auto-detection

 - floppy disk change detection

so just formatting floppies to a couple of different formats (ie do
you possibly have DD and HD floppies?), mkfs them and write something
to them, and then moving them to another machine and checking that
reading the data off them through the auto-detected formats (/dev/fd0)
works and gives the right results (just sha1sum the files).

The disk change detect can be a bit hard to see. It's unreliable with
some media, so iirc we always flush caches after the last close (we
didn't use to do that, and the disk change detection needed to just be
reliable - and you could test that the disk change logic worked by
just timing a read of the media and seeing if it came out of the
cache). I think for floppies, the thing to see is if format detection
works correctly when you switch between formats. Perhaps also the
read-only marker (ie switch the floppy between read-only and
read-write, and see that the status of the floppy is correctly
noticed: you should get a nice error if you try to write a read-only
floppy, rather than getting IO errors).

I can't think of anything else relevant.

                      Linus
