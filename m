Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab2LAIEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 03:04:53 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:59423 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2LAIEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 03:04:52 -0500
Date: Sat, 1 Dec 2012 00:01:31 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Greg Thelen <gthelen@google.com>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, aquini@redhat.com,
        riel@redhat.com
Subject: Re: [RFC] Add mempressure cgroup
Message-ID: <20121201080131.GB21747@lizard.sbx14280.paloaca.wayport.net>
References: <20121128102908.GA15415@lizard>
 <20121128151432.3e29d830.akpm@linux-foundation.org>
 <20121129012751.GA20525@lizard>
 <20121130154725.0a81913c@doriath.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121130154725.0a81913c@doriath.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luiz,

Thanks for your email!

On Fri, Nov 30, 2012 at 03:47:25PM -0200, Luiz Capitulino wrote:
[...]
> > But there is one, rather major issue: we're crossing kernel-userspace
> > boundary. And with the scheme we'll have to cross the boundary four times:
> > query / reply-available / control / reply-shrunk / (and repeat if
> > necessary, every SHRINK_BATCH pages). Plus, it has to be done somewhat
> > synchronously (all the four stages), and/or we have to make a "userspace
> > shrinker" thread working in parallel with the normal shrinker, and here,
> > I'm afraid, we'll see more strange interactions. :)
> 
> Wouldn't this be just like kswapd?

Sure, this is similar, but only for indirect reclaim (obviously).

How we'd do this for the direct reclaim I have no idea, honestly, with
Andrew's idea it must be all synchronous, so playing ping-pong with
userland during the direct reclaim will be hard.

So, the best thing to do with the direct recaim, IMHO, is just send a
notification.

> > But there is a good news: for these kind of fine-grained control we have a
> > better interface, where we don't have to communicate [very often] w/ the
> > kernel. These are "volatile ranges", where userland itself marks chunks of
> > data as "I might need it, but I won't cry if you recycle it; but when I
> > access it next time, let me know if you actually recycled it". Yes,
> > userland no longer able to decide which exact page it permits to recycle,
> > but we don't have use-cases when we actually care that much. And if we do,
> > we'd rather introduce volatile LRUs with different priorities, or
> > something alike.
> 
> I'm new to this stuff so please take this with a grain of salt, but I'm
> not sure volatile ranges would be a good fit for our use case: we want to
> make (kvm) guests reduce their memory when the host is getting memory
> pressure.

Yes, for this kind of things you want a simple notification.

I wasn't saying that volatile ranges must be a substitute for
notifications, quite the opposite: I was saying that you can do volatile
ranges in userland by using "userland-shrinker".

It can be even wrapped into a library, with the same mmap() libc
interface. But it will be inefficient.

Thanks,
Anton.
