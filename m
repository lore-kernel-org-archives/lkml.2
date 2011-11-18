Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299Ab1KRMU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 07:20:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757152Ab1KRMUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 07:20:21 -0500
Date: Fri, 18 Nov 2011 07:19:50 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Dave Jones <davej@redhat.com>, Johannes Weiner <jweiner@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>, linux-kernel@vger.kernel.org,
        linux-mm@vger.kernel.org, kernel-team@fedoraproject.org
Subject: Re: long sleep_on_page delays writing to slow storage
Message-ID: <20111118121950.GD4096@zod.bos.redhat.com>
References: <20111107045928.GK8927@hexapodia.org>
 <20111109170027.GB7495@quack.suse.cz>
 <20111109175201.GB3083@suse.de>
 <20111109180646.GM5075@redhat.com>
 <20111110093442.GG3153@redhat.com>
 <20111114184717.GA7006@redhat.com>
 <20111115101313.GA28350@suse.de>
 <20111117194719.GA23213@redhat.com>
 <20111118111140.GA20840@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118111140.GA20840@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 11:11:40AM +0000, Mel Gorman wrote:
> On Thu, Nov 17, 2011 at 02:47:20PM -0500, Dave Jones wrote:
> > On Tue, Nov 15, 2011 at 10:13:13AM +0000, Mel Gorman wrote:
> >  
> >  > If they are still experiencing major stalls, I have an experimental
> >  > script that may be able to capture stack traces of processes stalled
> >  > for more than 1 second. I've had some success with it locally so
> >  > maybe they could try it out to identify if it's THP or something else.
> >  
> > I'm not sure if it's the same problem, but I'd be interested in trying
> > that script.
> > 
> 
> Monitor script is attached as watch-dstate.pl. Run it as
> 
> watch-dstate.pl -o logfile
> 
> I'm also attaching a post-processing script stap-dstate-frequency.
> 
> cat logfile | stap-dstate-frequency
> 
> will report on unique stack traces, what got stuck in them and
> for how long. Unfortunately, this does require a working systemtap
> installation because it had to work on systems without ftrace. Usually
> systemtap is a case of installing debugging symbols and its package
> but milage varies.
> 
> I ran this for a few days on my own desktop but found that the worst
> stalls for firefox and evolution were in futex_wait with the second
> worst in
> 
> [<ffffffffa018e3c5>] ext4_sync_file+0x225/0x290 [ext4]
> [<ffffffff81178250>] do_fsync+0x50/0x80
> [<ffffffff8117852e>] sys_fdatasync+0xe/0x20
> [<ffffffff81448592>] system_call_fastpath+0x16/0x1b
> 
> The stall timing is approximate at best. If you find the stall figures
> are way too high or unrealistic, try running with --accurate-stall. The
> stall figures will be much more accurate but depending on your
> kernel version, the stack traces may be one line long ending with
> kretprobe_trampoline.
> 
> > When I build a kernel on my laptop, when it gets to the final link stage,
> > and there's a ton of IO, my entire X session wedges for a few seconds.
> > This may be unrelated, because this is on an SSD, which shouldn't suffer
> > from the slow IO of the USB devices mentioned in this thread.
> > 
> 
> I have a vague suspicion that there are some interactivity issues
> around SSDs but I don't know why that is. I'm basing this on some
> complaints of audio skipping with heavy kernel compiles on machines
> very similar to my own other than mine uses rotary storage. It's on
> the Christmas list to by myself a SSD to take a closer look.

I see similar pauses on my laptop that doesn't have an SSD, so I don't
think it's drive related.  Certainly could be I/O scheduling or ext4
sync related, but probably not a specific drive technology.

I also wonder if the dirty_background_ratio and dirty_ratio might be too
high on this machine, and the flush of the page cache is causing
excessive I/O.

> > (This is even with that patch applied btw, perhaps adding further fuel to
> > the idea that it's unrelated).
> > 
> 
> I suspect it's not compaction related in that case but the script may be
> able to tell for sure. If it does not catch anything, alter this line to
> have a smaller threshold
> 
> global stall_threshold = 1000

I'll give this a try as well.
