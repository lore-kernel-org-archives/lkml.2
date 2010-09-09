Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab0IINUy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:20:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59089 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0IINUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:20:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sxytnFSSFCtIpL0tGM0Ry3lWgMVDJfDCJ4m8oW4EwIz15UdO09OIKYksgKuSYNpF5f
         jVSVvu1NpqYaPau6hDjWN4lKZ/YzpV09MiliwElugIlOG2GeeoijVv3PbvNDBVWOrnav
         e7nGdMX5/8JL3F4DG0R3AEAEj60nEVpK3J+Lo=
Date: Thu, 9 Sep 2010 15:21:00 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Harald Gustafsson <hgu1972@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf events over (net) console?
Message-ID: <20100909132057.GA5259@nowhere>
References: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com> <1284031141.402.1.camel@laptop> <20100909112940.GA5267@nowhere> <20100909114053.GA15140@elte.hu> <AANLkTikuqHFdOoiB4ejRygi3EV3p4HN2jgjJwM6Sw+31@mail.gmail.com> <1284036453.402.11.camel@laptop> <20100909130723.GA20470@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100909130723.GA20470@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 03:07:23PM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Thu, 2010-09-09 at 14:31 +0200, Harald Gustafsson wrote:
> > 
> > > Sorry for being daft...
> > 
> > No worries, I'm sure we all qualify at times ;-)
> > 
> > > >> >
> > > >> > You need a process context anyway to read the data and send it to
> > > >> > whatever place you want it.
> > > >> >
> > > >> > Putting that in-kernel serves no purpose what so ever.
> > > >>
> > > >> But if we bring the splice support, that can be done with minimal
> > > >> userspace noise. Plus that would work with the usual sockets but not
> > > >> limited to that.
> > > >
> > > > Yes. If we can transform the data over the network without it touching
> > > > disk, then that would be a sufficiently 'does not disturb other tasks'
> > > > measurement method.
> > > 
> > > Thanks for the pointers to more information, and yes my thoughts was 
> > > more about avoiding the data copy then avoiding any processing 
> > > context at all.
> > 
> > Right, currently you get a single copy with mmap() + write(), once we 
> > manage to fix splice() and actually provide perf-splice() you'd be 
> > able to do zero-copy.
> 
> I think it would also be very useful to have some sort of tooling help 
> for "low overhead/impact perf recording".
> 
> If there's a 'target box' and a different 'host box' (where most of 
> development is done, etc.), then there might not be any NFS connection 
> set up to make zero-copy file transfer easy. Doing it over ssh would add 
> overhead.
> 
> One possible workflow would be to run this on the target/remote box:
> 
>   perf remote
> 
> And as long as that command is running there, it could be used from the 
> development box (over a trusted local network), using something like:
> 
>   perf --remote <hostname> record sleep 60
>   perf --remote <hostname> stat -a sleep 1
> 
> these would all do the measurements on the remote box, and the resulting 
> perf.data would be created on the desktop box. Communication would be 
> done via some well-known port.
> 
> etc.
> 
> An alternative implementation would be to drive this on the assumption 
> that an ssh connection can be established with the target box - but 
> followup high-volume data transfer would be done over an ordinary TCP 
> connection.
> 
> I.e. the workflow would be even simpler, something like:
> 
>   perf --remote user@hostname record sleep 60
>   perf --remote user@hostname stat -a sleep 1
> 
> Internally it would work by executing those commands on the remote box 
> via ssh, and redirecting the output via a TCP connection. (some other 
> details might be needed as well for splice to be usable in such a setup)
> 
> Would anyone be interested in having (and implementing ;-) this?
> 
> 	Ingo



In the beginning this could wrap into perf record - | perf pipe | netcat
and so, until we get the splice support.

