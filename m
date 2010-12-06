Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab0LFBup (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:50:45 -0500
Received: from smtp.scorch.co.nz ([27.110.127.199]:34037 "HELO scorch.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752020Ab0LFBuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:50:44 -0500
X-Virus-Checked: Checked by ClamAV on scorch.co.nz
From: Charles Manning <manningc2@actrix.gen.nz>
To: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Add yaffs2 file system: guts code
Date: Mon, 6 Dec 2010 14:50:41 +1300
User-Agent: KMail/1.9.10
References: <1291154254-22533-1-git-send-email-cdhmanning@gmail.com> <1291154254-22533-4-git-send-email-cdhmanning@gmail.com> <201011302323.53313.arnd@arndb.de>
In-Reply-To: <201011302323.53313.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012061450.41675.manningc2@actrix.gen.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 December 2010 11:23:53 you wrote:
> On Tuesday 30 November 2010 22:57:29 Charles Manning wrote:
>
> I think I made these comments before, not sure what happened to them...
>
> > +
> > +/* Robustification (if it ever comes about...) */
> > +static void yaffs_retire_block(struct yaffs_dev *dev, int flash_block);
> > +static void yaffs_handle_chunk_wr_error(struct yaffs_dev *dev, int
> > nand_chunk, +					int erased_ok);
> > +static void yaffs_handle_chunk_wr_ok(struct yaffs_dev *dev, int
> > nand_chunk, +				     const u8 * data,
> > +				     const struct yaffs_ext_tags *tags);
> > +static void yaffs_handle_chunk_update(struct yaffs_dev *dev, int
> > nand_chunk, +				      const struct yaffs_ext_tags *tags);
>
> It would be better to reorder the functions in each file so that
> you don't need forward declarations. This generally makes reading
> the code easier because it is what people expect to see. It
> also makes it clearer where you have possible recursions in the code.

Hmmm.. 
I too prefer minimal use of forward declaration.
Some of them are because I copied the layout of existing kernel code which 
uses fwd declarations a lot. eg. fs/jffs2/dir.c  and many of the examples in 
Rubini & Corbet.

>
> > +
> > +	T(YAFFS_TRACE_BUFFERS,
> > +	  (TSTR("Out of temp buffers at line %d, other held by lines:"),
> > +	   line_no));
> > +	for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
> > +		T(YAFFS_TRACE_BUFFERS,
> > +		  (TSTR(" %d "), dev->temp_buffer[i].line));
> > +
> > +	T(YAFFS_TRACE_BUFFERS, (TSTR(" " TENDSTR)));

> The tracing functions are rather obscure. I would recommend dropping
> them all for now, in order to get the code included.

Yup that was a very ugly bunch of hackery to make WinCE unicode work.

I think I can pull the var-arg-foo to replace these with

yaffs_trace(YAFFS_TRACE_BUFFERS,
	"Out of temp buffers at line %d, other held by lines:",line_no);
for (i = 0; i < YAFFS_N_TEMP_BUFFERS; i++)
	yaffs_trace(YAFFS_TRACE_BUFFERS," %d ", dev->temp_buffer[i].line);
yaffs_trace(YAFFS_TRACE_BUFFERS, "\n");

Would that be OK?

I am loath to have to pull out useful code then plug it back in again.

> At a later 
> stage, you can add standard trace points.
>
> > +	return YMALLOC(dev->data_bytes_per_chunk);

I'm getting rid of those..

The reason for thew wrapping was to make portable code.

I'm replacing these with kmalloc() and then providing kmalloc() which is just 
a wrapped malloc() for non-Linux use.

I am hoping to reduce this to YCHAR, _Y() and maybe one or two others.

 -- Charles

