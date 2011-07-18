Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab1GROaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 10:30:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756053Ab1GROan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 10:30:43 -0400
Date: Mon, 18 Jul 2011 10:30:36 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Bart Van Assche <bvanassche@acm.org>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11 re-post] dynamic_debug: use a single printk() to
 emit msgs
Message-ID: <20110718143036.GB2457@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
 <1310744914.7582.36.camel@Joe-Laptop>
 <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
 <20110715160417.GB2493@redhat.com>
 <CAO+b5-qgrV=gfZAczxfPbGqVtv4ZD_zZHOn-BMVY9wnJytbrtw@mail.gmail.com>
 <1310746580.7582.50.camel@Joe-Laptop>
 <20110715195903.GA7470@redhat.com>
 <1310773591.10603.9.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310773591.10603.9.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 04:46:31PM -0700, Joe Perches wrote:
> On Fri, 2011-07-15 at 15:59 -0400, Jason Baron wrote:
> > here's Bart's suggestion as re-post. It looks much cleaner to
> > me...
> []
> > diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> []
> > @@ -422,52 +422,46 @@ static int ddebug_exec_query(char *query_string)
> >  	return 0;
> >  }
> >  
> > -static int dynamic_emit_prefix(const struct _ddebug *descriptor)
> > +#define PREFIX_SIZE 64
> > +#define LEFT(wrote) ((PREFIX_SIZE - wrote) > 0) ? (PREFIX_SIZE - wrote) : 0
> > +
> > +static char *dynamic_emit_prefix(const struct _ddebug *desc, char *buf)
> >  {
> > -	char tid[sizeof(int) + sizeof(int)/2 + 4];
> > -	char lineno[sizeof(int) + sizeof(int)/2];
> > +	int pos = 0;
> >  
> > -	if (descriptor->flags & _DPRINTK_FLAGS_INCL_TID) {
> > +	pos += snprintf(buf + pos, LEFT(pos), "%s", KERN_DEBUG);
> > +	if (desc->flags & _DPRINTK_FLAGS_INCL_TID) {
> >  		if (in_interrupt())
> > -			snprintf(tid, sizeof(tid), "%s", "<intr> ");
> > +			pos += snprintf(buf + pos, LEFT(pos), "%s ",
> > +						"<intr>");
> 
> scnprintf works without using LEFT.
> snprintf does as well.
> 
> http://lkml.org/lkml/2010/7/23/375
> 

So you're saying, just pass (PREFIX_SIZE - pos), as the second argument? I see
kernel code written both ways. I think it's fine as written, unless you feel
strongly about this.

thanks,

-Jason
