Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605Ab2KODmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:42:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39525 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2KODmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:42:51 -0500
Date: Wed, 14 Nov 2012 19:39:33 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: Re: [RFC v3 0/3] vmpressure_fd: Linux VM pressure notifications
Message-ID: <20121115033932.GA15546@lizard.sbx05977.paloaca.wayport.net>
References: <20121107105348.GA25549@lizard>
 <20121107112136.GA31715@shutemov.name>
 <CAOJsxLHY+3ZzGuGX=4o1pLfhRqjkKaEMyhX0ejB5nVrDvOWXNA@mail.gmail.com>
 <20121107114321.GA32265@shutemov.name>
 <alpine.DEB.2.00.1211141910050.14414@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211141910050.14414@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Thanks for your comments!

On Wed, Nov 14, 2012 at 07:21:14PM -0800, David Rientjes wrote:
> > > Why should you be required to use cgroups to get VM pressure events to
> > > userspace?
> > 
> > Valid point. But in fact you have it on most systems anyway.
> > 
> > I personally don't like to have a syscall per small feature.
> > Isn't it better to have a file-based interface which can be used with
> > normal file syscalls: open()/read()/poll()?
> > 
> 
> I agree that eventfd is the way to go, but I'll also add that this feature 
> seems to be implemented at a far too coarse of level.  Memory, and hence 
> memory pressure, is constrained by several factors other than just the 
> amount of physical RAM which vmpressure_fd is addressing.  What about 
> memory pressure caused by cpusets or mempolicies?  (Memcg has its own 
> reclaim logic

Yes, sure, and my plan for per-cgroups vmpressure was to just add the same
hooks into cgroups reclaim logic (as far as I understand, we can use the
same scanned/reclaimed ratio + reclaimer priority to determine the
pressure).

> and its own memory thresholds implemented on top of eventfd 
> that people already use.)  These both cause high levels of reclaim within 
> the page allocator whereas there may be an abundance of free memory 
> available on the system.

Yes, surely global-level vmpressure should be separate for the per-cgroup
memory pressure.

But we still want the "global vmpressure" thing, so that we could use it
without cgroups too. How to do it -- syscall or sysfs+eventfd doesn't
matter much (in the sense that I can do eventfd thing if you folks like it
:).

> I don't think we want several implementations of memory pressure 
> notifications,

Even with a dedicated syscall, why would we need a several implementation
of memory pressure? Suppose an app in the root cgroup gets an FD via
vmpressure_fd() syscall and then polls it... Do you see any reason why we
can't make the underlaying FD switch from global to per-cgroup vmpressure
notifications completely transparently for the app? Actually, it must be
done transparently.

Oh, or do you mean that we want to monitor cgroups vmpressure outside of
the cgroup? I.e. parent cgroup might want to watch child's pressure? Well,
for this, the API will have to have a hard dependency for cgroup's sysfs
hierarchy -- so how would we use it without cgroups then? :) I see no
other option but to have two "APIs" then. (Well, in eventfd case it will
be indeed simpler -- we would only have different sysfs paths for cgroups
and non-cgroups case... do you see this acceptable?)

Thanks,
Anton.
