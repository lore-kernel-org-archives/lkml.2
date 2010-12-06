Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0LFWOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:14:00 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:37224 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753277Ab0LFWNz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:13:55 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
Date: Tue, 7 Dec 2010 11:13:51 +1300
User-Agent: KMail/1.9.10
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <201012061450.41675.manningc2@actrix.gen.nz> <201012061355.44032.arnd@arndb.de>
In-Reply-To: <201012061355.44032.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012071113.51408.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 December 2010 01:55:43 Arnd Bergmann wrote:
> On Monday 06 December 2010, Charles Manning wrote:
> > On Wednesday 01 December 2010 11:23:53 you wrote:
> > > On Tuesday 30 November 2010 22:57:29 Charles Manning wrote:
> > > It would be better to reorder the functions in each file so that
> > > you don't need forward declarations. This generally makes reading
> > > the code easier because it is what people expect to see. It
> > > also makes it clearer where you have possible recursions in the code.
> >
> > Hmmm..
> > I too prefer minimal use of forward declaration.
> > Some of them are because I copied the layout of existing kernel code
> > which uses fwd declarations a lot. eg. fs/jffs2/dir.c  and many of the
> > examples in Rubini & Corbet.
>
> There is not much point in changing the legacy code that's already in
> the kernel, but let's try to keep it clean for new code. We have a lot
> of bad examples for coding style that we wouldn't merge these days.
>
> In this case, it should be an obvious change with no real downsides.

Arnd thanks for your input, I appreciate it immensely.

Is this objection to forward declarations just your personal taste or is this 
a real issue?

I can't find any references to forward declarations in any of the coding style 
docs. I would therefore expect it to be an issue of little consequence. 
Perhaps I did not look in the right places.

It is perhaps also worth considering that yaffs has been in use for 8 years 
and is more widely used than many of the file systems already in the kernel  
and thus, by some measures, does constitute legacy code.

>
> > > > +	T(YAFFS_TRACE_BUFFERS,
> > > > +	  (TSTR("Out of temp buffers at line %d, other held by lines:"),
> > > > +	   line_no));
> > > > +	for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> > > > +		T(YAFFS_TRACE_BUFFERS,
> > > > +		  (TSTR(" %d "), dev->temp_buffer[i].line));
> > > > +
> > > > +	T(YAFFS_TRACE_BUFFERS, (TSTR(" " TENDSTR)));
> > >
> > > The tracing functions are rather obscure. I would recommend dropping
> > > them all for now, in order to get the code included.
> >
> > Yup that was a very ugly bunch of hackery to make WinCE unicode work.
> >
> > I think I can pull the var-arg-foo to replace these with
> >
> > yaffs_trace(YAFFS_TRACE_BUFFERS,
> > 	"Out of temp buffers at line %d, other held by lines:",line_no);
> > for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> > 	yaffs_trace(YAFFS_TRACE_BUFFERS," %d ", dev->temp_buffer[i].line);
> > yaffs_trace(YAFFS_TRACE_BUFFERS, "\n");
> >
> > Would that be OK?
> >
> > I am loath to have to pull out useful code then plug it back in again.
>
> I don't think the yaffs_trace() function would be much better than the T()
> macro, I was talking more about the fact that you have your own nonstandard
> tracing infrastructure than the ugliness of the interface.
>
> The point of pulling it out now would be force you to rethink the
> tracing. If you think that you'd arrive at the same conclusion, just
> save the diff between the code with and without tracing so you can
> submit that patch again later.
>
> Having some sort of tracing is clearly useful, but it's also not essential
> for the basic yaffs2 operation. We want to keep a consistent way of
> presenting trace points across the kernel, so as long as you do it
> differently, your code is going to be viewed with some suspicion.
>
> Please have a look at how ext4, gfs2 and xfs do tracing.

Looking in Linus' tree, all of those contain custom tracing of the form I 
propose.

>
> > > At a later
> > > stage, you can add standard trace points.
> > >
> > > > +	return YMALLOC(dev->data_bytes_per_chunk);
> >
> > I'm getting rid of those..
> >
> > The reason for thew wrapping was to make portable code.
> >
> > I'm replacing these with kmalloc() and then providing kmalloc() which is
> > just a wrapped malloc() for non-Linux use.
>
> Ok, excellent!
>
> > I am hoping to reduce this to YCHAR, _Y() and maybe one or two others.
>
> Ok. Maybe rename YCHAR to ychar to make it stick out less, and add a
> comment to the definition why you need it then.

Can do.

Thanks.

-- Charles
