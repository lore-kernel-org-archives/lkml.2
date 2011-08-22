Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab1HVOwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:52:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1HVOwY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:52:24 -0400
Date: Mon, 22 Aug 2011 16:52:10 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf, tool, record: Fix the header generation for pipe
Message-ID: <20110822145210.GA8694@jolsa.brq.redhat.com>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
 <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 04:38:33PM +0200, Eric Dumazet wrote:
> Le lundi 22 août 2011 à 16:23 +0200, Jiri Olsa a écrit :
> > The generation of the perf data file fails when using pipe
> > as the output file descriptor.
> > 
> > When record command generates the data header, several files are put
> > inside and the file size is stored ahead of the file contents itself.
> > 
> > The problem is that debugfs files cannot be stat-ed for size so we
> > need to read the whole file, count the size and update the file size
> > via seek&write (pwrite call).
> > This cannot be done for pipes, since it's not allowed to seek on it.
> > 
> > The attached patch changes current behaviour for pipes to get the
> > file size first and write correct data within the first pass.
> > For other than pipe files, the current behaviour stands.
> > 
> > This issue was caught when running the script command:
> > 
> > 	# perf script  syscall-counts ls
> > 
> > since it connects record and report via pipe.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> > ---
> >  tools/perf/util/trace-event-info.c |   81 +++++++++++++++++++++++++++++++-----
> >  1 files changed, 70 insertions(+), 11 deletions(-)
> > 
> > diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> > index 3403f81..62ab9a2 100644
> > --- a/tools/perf/util/trace-event-info.c
> > +++ b/tools/perf/util/trace-event-info.c
> > @@ -59,6 +59,7 @@ unsigned int page_size;
> >  
> >  static const char *output_file = "trace.info";
> >  static int output_fd;
> > +static int output_is_pipe;
> >  
> >  struct event_list {
> >  	struct event_list *next;
> > @@ -183,20 +184,59 @@ int bigendian(void)
> >  	return *ptr == 0x01020304;
> >  }
> >  
> > +static off_t get_file_size(int fd)
> > +{
> > +	off_t size = 0;
> > +	char buf[BUFSIZ];
> > +	int r;
> > +
> > +	do {
> > +		r = read(fd, buf, BUFSIZ);
> > +		if (r > 0)
> > +			size += r;
> > +	} while (r > 0);
> > +
> > +	if (lseek(fd, 0, SEEK_SET))
> > +		die("seek failed");
> > +
> > +	return size;
> > +}
> 
> This part makes no sense :
> 
> If fd is a pipe, you'll call die("seek failed")
> 
> If it's not a pipe, you can try lseek(fd, 0, SEEK_END)+lseek(fd, 0,
> SEEK_SET) or fstat(fd, &st) instead of the read() loop.

- fd is always file.. the descriptor, which might be pipe, is in output_fd variable
  but, maybe the die call is not necessary.. this should not fail

- the record_file function is called only on debugfs or procfs files:
	events/header_page
	events/header_event
	events/**/format
	printk_formats
	/proc/kallsyms

so I think I need to read the whole file as in current code.

thanks,
jirka
