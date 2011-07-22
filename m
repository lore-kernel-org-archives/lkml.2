Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1GVTeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:34:36 -0400
Received: from waste.org ([173.11.57.241]:58562 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755166Ab1GVTef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:34:35 -0400
Subject: Re: Nanosecond fs timestamp support: sad
From: Matt Mackall <mpm@selenic.com>
To: NeilBrown <neilb@suse.de>
Cc: Andi Kleen <andi@firstfloor.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20110722163335.2df4f6ca@notabene.brown>
References: <1311271641.14555.114.camel@calx>
	 <m2pql2c0qz.fsf@firstfloor.org>  <20110722163335.2df4f6ca@notabene.brown>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 14:34:29 -0500
Message-ID: <1311363269.14555.261.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 16:33 +1000, NeilBrown wrote:
> On Thu, 21 Jul 2011 23:01:24 -0700 Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Matt Mackall <mpm@selenic.com> writes:
> > 
> > 
> > > This means I can touch a file something like 70k times per second and
> > > get only 300 distinct timestamps on my laptop. And only 100 distinct
> > > timestamps on a typical distro server kernel.
> > 
> > You should use the inode generation number if you really want
> > to see every update.
> 
> I assume you mean i_version which gets incremented (under a spinlock) if the
> filesystem asks for it.

Indeed. Only usefully exists on ext4 and requires extra system calls.

> This doesn't let you compare the ages of two files.  I wonder if that is
> important.  Is it important to you Matt?

Sort of. We track a 'latest seen timestamp' so we can consider files
before that time unchanged and we need only concern ourselves with the
looking for invisible changes that occur inside that quantum.

> I imagine a scheme where 'stat' would set a flag if it wasn't set, and
> file_update_time would:
>   - if the flag is set, use gettimeofday and clear the flag
>   - if the flag is not set, use jiffies
> 
> so if you are looking, you will see i_mtime changing precisely but if not,
> you don't pay the price.

Hmm, interesting.

> This wouldn't allow precise ordering of distinct files either of course.

Yeah, I don't think we want to introduce observable non-causality in
filesystem time. There might be something clever we can do here, but it
would require some Deep Thought. But if successful, we could mitigate
some of the repeated inode dirtying caused by jiffies-resolution
timestamping.

-- 
Mathematics is the supreme nostalgia of our time.


