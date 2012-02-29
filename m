Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030818Ab2B2KLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 05:11:34 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:38089 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965233Ab2B2KLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 05:11:04 -0500
Date: Wed, 29 Feb 2012 11:10:47 +0100
From: Borislav Petkov <bp@amd64.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
        Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] mce: Add a msg string to the MCE tracepoint
Message-ID: <20120229101047.GA21224@aftab>
References: <1330445487-15020-1-git-send-email-bp@amd64.org>
 <1330445487-15020-2-git-send-email-bp@amd64.org>
 <4F4D7BF9.9070104@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4D7BF9.9070104@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 10:14:33AM +0900, Hidetoshi Seto wrote:
> (2012/02/29 1:11), Borislav Petkov wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> > 
> > The idea here is to pass an additional decoded MCE message through
> > the tracepoint and into the ring buffer for userspace to consume. The
> > designated consumers are RAS daemons and other tools collecting RAS
> > information.
> 
> I could not catch the point... Why you need this msg field?
> 
> I think that all of information about the error is already packed in
> the record and that we can make a string from the bits in the record
> soon afterward.  From my point of view it seems that what you are
> doing here is just consuming the ring buffer by repeating same
> contents in another format with dynamic length which might be short
> but otherwise could be too long.

Right, to answer your immediate question: we've already decoded the MCE
so we carry that decoded info to userspace.

To address your indirect question: why aren't we using the MCE fields
to decode the MCE in userspace? Well, this has been a long discussion
already and one of the strong arguments for decoding hardware errors in
the kernel is that the kernel simply knows its hardware better. Imagine
a big server farm with heterogeneous hw configurations - if you get an
MCE there you have to also have collected the hardware platform details
so that you are able to decode it. If the kernel can do that for ya, you
don't have to do anything!

Or the case where you get an uncorrectable error and the machine panics
- it is much more convenient to see the decoded error on the screen
before the machine dies instead of some MCA register dumps which you
have to jot down and go and decode them by hand.

> And one more unacceptable point is that filling this msg field is
> expected to be done in machine check context where have many
> limitations in kernel's subsystems such as use of memory allocators.

Doh, I should've seen that, thanks to you and Tony for pointing that
out.

> Suggestion; How about having a kind of translator function for
> userland, e.g. an exported function named mce_record_to_msg()?
> Tool obtains raw data from the record in the tracepoint's ring buffer,
> and if it likes, optionally it can pass the record to the translator
> function to get some accomplished string.

Either that or I could simply allocate a large enough buffer from the
get-go, as Tony suggests. I'll experiment with my MCE generation script
and see how large a buffer can become.

> > Drop unneeded fields while at it, thus saving some room in the ring
> > buffer.
> 
> Really unneeded and should be killed?

Right, so this is me suggesting to remove those because I don't see
why we'd need them, I'm expecting other people to come and say either
"Boris, no no, this is needed in... " or "Yeah, go ahead and remove
them, no one uses those." So feel free to argue either way.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
