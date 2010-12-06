Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080Ab0LFXEC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:04:02 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:63542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0LFXEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 18:04:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Charles Manning <manningc2@actrix.gen.nz>
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
Date: Tue, 7 Dec 2010 00:03:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc1+; KDE/4.5.1; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <201012061355.44032.arnd@arndb.de> <201012071113.51408.manningc2@actrix.gen.nz>
In-Reply-To: <201012071113.51408.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012070003.42224.arnd@arndb.de>
X-Provags-ID: V02:K0:l+W4rLkdEUUa7YfV4dOslkRZ85EBtHIoUAXA5zD2t8T
 Tld6f+QwDBEU5sbcn/424sFh0iRGneSry22u8rxJeZN+FpdLZT
 CS7LW2mPJHuAfNxG/t/WzGSLis+9ysLVVGH6lqUxtEYxtNKjmu
 0ur20vrpmpkMBwf8oiGFWDHFSq3M86Ds834pKLVWJWsO8ZfUx7
 PGmBAKWF5W1sAgBQWRwPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010 23:13:51 Charles Manning wrote:
> On Tuesday 07 December 2010 01:55:43 Arnd Bergmann wrote:
> > On Monday 06 December 2010, Charles Manning wrote:
> > > On Wednesday 01 December 2010 11:23:53 you wrote:
> > > > On Tuesday 30 November 2010 22:57:29 Charles Manning wrote:
> > > > It would be better to reorder the functions in each file so that
> > > > you don't need forward declarations. This generally makes reading
> > > > the code easier because it is what people expect to see. It
> > > > also makes it clearer where you have possible recursions in the code.
> > >
> > > Hmmm..
> > > I too prefer minimal use of forward declaration.
> > > Some of them are because I copied the layout of existing kernel code
> > > which uses fwd declarations a lot. eg. fs/jffs2/dir.c  and many of the
> > > examples in Rubini & Corbet.
> >
> > There is not much point in changing the legacy code that's already in
> > the kernel, but let's try to keep it clean for new code. We have a lot
> > of bad examples for coding style that we wouldn't merge these days.
> >
> > In this case, it should be an obvious change with no real downsides.
> 
> Arnd thanks for your input, I appreciate it immensely.
> 
> Is this objection to forward declarations just your personal taste or is this 
> a real issue?
> 
> I can't find any references to forward declarations in any of the coding style 
> docs. I would therefore expect it to be an issue of little consequence. 
> Perhaps I did not look in the right places.

It's not very important and a lot of people don't care, though I have never
seen anyone argue in favour of adding forward declarations. I consider
it similar to the argument about function sizes: We don't have a hard
limit about how many lines a function is allowed to have, and there are
some cases where it makes sense to have a really long function, but
you can tell how much effort people put into making code readable when
you see a multi-page function that could easily be split into reasonable
smaller ones. Code readability is mostly subjective, just like taste, but
with some experience, you see when something is done wrong.

> It is perhaps also worth considering that yaffs has been in use for 8 years 
> and is more widely used than many of the file systems already in the kernel  
> and thus, by some measures, does constitute legacy code.

I see this argument a lot about code that gets upstream after a long time.
My counterargument to this is that often enough the reason for being outside
of mainline is that the code was written in obscure ways to start with ;-)

In general, the initial merge of new code is the only time we can really
influence code from other people. Once it gets merged, I'm going to have
a really hard time making the maintainers change it again in fundamental
ways.

> > > yaffs_trace(YAFFS_TRACE_BUFFERS,
> > > 	"Out of temp buffers at line %d, other held by lines:",line_no);
> > > for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> > > 	yaffs_trace(YAFFS_TRACE_BUFFERS," %d ", dev->temp_buffer[i].line);
> > > yaffs_trace(YAFFS_TRACE_BUFFERS, "\n");
> > >
> > > Would that be OK?
> > >
> > > I am loath to have to pull out useful code then plug it back in again.
> >
> > I don't think the yaffs_trace() function would be much better than the T()
> > macro, I was talking more about the fact that you have your own nonstandard
> > tracing infrastructure than the ugliness of the interface.
> >
> > The point of pulling it out now would be force you to rethink the
> > tracing. If you think that you'd arrive at the same conclusion, just
> > save the diff between the code with and without tracing so you can
> > submit that patch again later.
> >
> > Having some sort of tracing is clearly useful, but it's also not essential
> > for the basic yaffs2 operation. We want to keep a consistent way of
> > presenting trace points across the kernel, so as long as you do it
> > differently, your code is going to be viewed with some suspicion.
> >
> > Please have a look at how ext4, gfs2 and xfs do tracing.
> 
> Looking in Linus' tree, all of those contain custom tracing of the form I 
> propose.

Hmm, yes I guess that's right...

I was specifically talking about the include/trace/* based trace events
as something to look at, not the random printk based tracing stuff.
Maybe Steven or Frederic can give some more insight on that.

	Arnd
