Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093Ab2JGBPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 21:15:35 -0400
Received: from plane.gmane.org ([80.91.229.3]:50315 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab2JGBPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 21:15:34 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: el_es <el.es.cr@gmail.com>
Subject: Re: Minimal jitter = good desktop.
Date: Sun, 7 Oct 2012 01:15:18 +0000 (UTC)
Message-ID: <loom.20121007T022629-736@post.gmane.org>
References: <op.wlqe9kw36426ze@localhost.localdomain> <alpine.DEB.2.02.1210051803180.13407@asgard.lang.hm> <op.wlrdzkqh6426ze@localhost.localdomain> <loom.20121006T164640-362@post.gmane.org> <op.wlrq12q96426ze@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 81.31.113.250 (Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20100101 Firefox/15.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uwaysi Bin Kareem <uwaysi.bin.kareem <at> paradoxuncreated.com> writes:

> 
> This is really simple, and I don`t care about top posting, down posting,  
> in the middle comments or whatever. Do whatehver you like, and have no  
> other rule that what is in your soul. That is what drives ultimately  
> society. Look up Aristotle natural-law. Which actually is based in divine  
> nature.

The natural law on most mailing lists is : avoid top-posting and actively
discourage it. That includes LKML.

> 
> Now jitter, is really easy. Jitter-sensitive OpenGL applications will show  
> visible jitter.
Question isn't of how you 'see' or 'feel' it, question is: how do you give
representative hard numbers of it.

> Doom 3 is extremely sensitive. I have tried to make it run  
> well many times, but it wasn`t until I became aware of more unintuitive  
> behaviour not according to theory with some settings, and I started trying  
> reversing them. And then I found 90hz to be optimal, and giving a  
> perfectly running doom 3. 

> Someone actually suggested I try 10000hz BFS  
> patch, because "it would reduce latency." Which I did. But then I also  
> tried 20hz, and there was little difference on BFS. Ultimately I arrived  
> at 90hz with CFS, and tweaking it`s granularity a bit, and it worked well.  
> (Better than BFS). So in that case, JITTER is solved. Also a lot of  
> low-jitter configs use low hz. So that seems to back it up. And everything  
> on my computer seems to be running better. Smoother, more responsive. Even  
> the ads in my browser ;(

Can you guarantee the same will apply in all hardware combinations? 
What if it doesn't work for e.g. someone with 4 core i5 and ATI gpu?

> 
> I also appreciate those who can measure small jitter in the uS range, and  
> mitigate it. But I would also like for those, to check if a simple  
> hold-logic would be better. For the 10ms filter I mentioned. Say hold for  
> 1ms at 0, and then to regular peak values. It seems that would be a better  
> filter. This just me being a perfectionist ofcourse.

I know how filters work, thank you very much.
But with same outcome one could argue, that someone could put a 
regulator there instead, to auto-tune to a chosen benchmark;
Maybe my personal favorite, GPC? 
But since you cannot measure jitter, you can't minimize that automatically...
or can you ?
Since we're in Control Theory, what we have accessible as 'measurements' 
is either a derivative of jitter or jitter derives from it, with bias unknown.
IOW nice for looking at, but worthless.
So the goal, according to what I derive from looking at LKML, is not
to minimize the latency, but rather to make it as precise as possible, 

> So yes, according to the general definition of "os-jitter" it seems highly  
> reduced.
> 
> I don`t know at all why you are mentioning opengl calls. Obviously games,  
> do run quite well. Atleast now. It is also going to be great to test new  
> games coming, and keep iterating knowledge and tuning. 


My thought experiment is as follows:
Imagine all the layers of the opengl aware application.
A thread or a few, to calculate the scene (spatial, physical, network
threads). Also one to govern them all. This is scheduled in the 
application itself, kernel only sees one process.
The scene composition thread, produces new frames as fast as it 
can run (or if synchronized to vsync, produces just one and then
waits).
An application competes for execution time with other applications.
A thread (or a few) receiving data from app itself, recognizing what
calls it should make, calling glibc/gl/kernel functions. This is still
in userspace and competes with the application itself (say it's the X
server)
A thread or a few, in kernel space, receiving calls from userspace,
translating into calls into hardware. (kernel driver)
This competes for execution time with other kernel level threads,
scheduler, other kernel services.
Now the pipeline in the GPU receives the data and manipulates 
GPU memory; Say, we can generate 2 to 4 frames in between gpu's internal
vsync (exxageration here) so the data in gpu memory changes 2 to 4 
times before the video buffer swap occurs and the output(s) start pushing
the buffer content into the monitor bitstream. 
Say we have comfortably enough time to push 2 scene updates, but 
the third is dubious: not all calls to gpu arrive before vsync HAS TO 
happen. The pipeline will not be reset; and if in the mean time, os scheduler
decides something else should be ran instead of the application or
xserver, it will be alerted of this fact only when its next slice comes.
But then, it will try to finish the remaining calls, which will only add
to injury. Because it will push the remaining calls for the scene
which is delayed because of the caller was preempted during vsync,
instead of recalculating the whole scene with most recent timing.

If we could predict that all the required calls will NOT make it into
GPU in time for 3rd frame update, we just wouldn't run it; but we can't
predict that. This is what I would call 'graphic buffer underrun'.

> 
> Peace Be With You.

Hope it's with you too.

Lukasz

