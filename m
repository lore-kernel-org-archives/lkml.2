Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab0LFMzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 07:55:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0LFMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:55:49 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Charles Manning <manningc2@actrix.gen.nz>
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
Date: Mon, 6 Dec 2010 13:55:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <201011302323.53313.arnd@arndb.de> <201012061450.41675.manningc2@actrix.gen.nz>
In-Reply-To: <201012061450.41675.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012061355.44032.arnd@arndb.de>
X-Provags-ID: V02:K0:hdpBu5KUVqWep48jzzmyZJbXffRJU7id8Me+ktDiBLJ
 Chfqhcur7w7KiLYkxW0aZELGEkJaMFRTCb16+G42TP1RehGDNR
 J/j6YS6METQAm4RrBXDgtKmgUahJAoWdm2M3DZJfD4Wh0noOVj
 MZRVa3Cstwy3pN/7D2OrZPdWF+3ObCld35yfgrbLVpKbE4dDUp
 z8yUKfnqKFjZqDdJdu38g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 December 2010, Charles Manning wrote:
> On Wednesday 01 December 2010 11:23:53 you wrote:
> > On Tuesday 30 November 2010 22:57:29 Charles Manning wrote:
> > It would be better to reorder the functions in each file so that
> > you don't need forward declarations. This generally makes reading
> > the code easier because it is what people expect to see. It
> > also makes it clearer where you have possible recursions in the code.
> 
> Hmmm.. 
> I too prefer minimal use of forward declaration.
> Some of them are because I copied the layout of existing kernel code which 
> uses fwd declarations a lot. eg. fs/jffs2/dir.c  and many of the examples in 
> Rubini & Corbet.

There is not much point in changing the legacy code that's already in
the kernel, but let's try to keep it clean for new code. We have a lot
of bad examples for coding style that we wouldn't merge these days.

In this case, it should be an obvious change with no real downsides.

> > > +	T(YAFFS_TRACE_BUFFERS,
> > > +	  (TSTR("Out of temp buffers at line %d, other held by lines:"),
> > > +	   line_no));
> > > +	for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> > > +		T(YAFFS_TRACE_BUFFERS,
> > > +		  (TSTR(" %d "), dev->temp_buffer[i].line));
> > > +
> > > +	T(YAFFS_TRACE_BUFFERS, (TSTR(" " TENDSTR)));
> 
> > The tracing functions are rather obscure. I would recommend dropping
> > them all for now, in order to get the code included.
> 
> Yup that was a very ugly bunch of hackery to make WinCE unicode work.
> 
> I think I can pull the var-arg-foo to replace these with
> 
> yaffs_trace(YAFFS_TRACE_BUFFERS,
> 	"Out of temp buffers at line %d, other held by lines:",line_no);
> for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> 	yaffs_trace(YAFFS_TRACE_BUFFERS," %d ", dev->temp_buffer[i].line);
> yaffs_trace(YAFFS_TRACE_BUFFERS, "\n");
> 
> Would that be OK?
> 
> I am loath to have to pull out useful code then plug it back in again.

I don't think the yaffs_trace() function would be much better than the T()
macro, I was talking more about the fact that you have your own nonstandard
tracing infrastructure than the ugliness of the interface.

The point of pulling it out now would be force you to rethink the
tracing. If you think that you'd arrive at the same conclusion, just
save the diff between the code with and without tracing so you can
submit that patch again later.

Having some sort of tracing is clearly useful, but it's also not essential
for the basic yaffs2 operation. We want to keep a consistent way of
presenting trace points across the kernel, so as long as you do it
differently, your code is going to be viewed with some suspicion.

Please have a look at how ext4, gfs2 and xfs do tracing.

> > At a later 
> > stage, you can add standard trace points.
> >
> > > +	return YMALLOC(dev->data_bytes_per_chunk);
> 
> I'm getting rid of those..
> 
> The reason for thew wrapping was to make portable code.
> 
> I'm replacing these with kmalloc() and then providing kmalloc() which is just 
> a wrapped malloc() for non-Linux use.

Ok, excellent!
 
> I am hoping to reduce this to YCHAR, _Y() and maybe one or two others.

Ok. Maybe rename YCHAR to ychar to make it stick out less, and add a comment
to the definition why you need it then.

	Arnd
