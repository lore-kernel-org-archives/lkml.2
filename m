Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab2IJO2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 10:28:44 -0400
Received: from fieldses.org ([174.143.236.118]:42322 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab2IJO2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 10:28:43 -0400
Date: Mon, 10 Sep 2012 10:28:37 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: =?utf-8?Q?P=C3=A1draig?= Brady <P@draigBrady.com>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: don't need a PATH_MAX allocation to hold a
 string representation of an int
Message-ID: <20120910142837.GB30136@fieldses.org>
References: <1347021293-19052-1-git-send-email-jlayton@redhat.com>
 <20120907084814.07a59c98@corrin.poochiereds.net>
 <5049EF5B.3020607@draigBrady.com>
 <20120907194416.GB4633@fieldses.org>
 <20120910092328.0251144c@corrin.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120910092328.0251144c@corrin.poochiereds.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 09:23:28AM -0400, Jeff Layton wrote:
> On Fri, 7 Sep 2012 15:44:16 -0400
> "J. Bruce Fields" <bfields@fieldses.org> wrote:
> 
> > On Fri, Sep 07, 2012 at 01:58:03PM +0100, Pádraig Brady wrote:
> > > On 09/07/2012 01:48 PM, Jeff Layton wrote:
> > > >On Fri,  7 Sep 2012 08:34:53 -0400
> > > >Jeff Layton<jlayton@redhat.com>  wrote:
> > > >
> > > >>Signed-off-by: Jeff Layton<jlayton@redhat.com>
> > > >>---
> > > >>  fs/proc/base.c | 5 +++--
> > > >>  1 file changed, 3 insertions(+), 2 deletions(-)
> > > >>
> > > >>diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > >>index 1b6c84c..58e801b 100644
> > > >>--- a/fs/proc/base.c
> > > >>+++ b/fs/proc/base.c
> > > >>@@ -2758,7 +2758,8 @@ static void *proc_self_follow_link(struct dentry *dentry, struct nameidata *nd)
> > > >>  	pid_t tgid = task_tgid_nr_ns(current, ns);
> > > >>  	char *name = ERR_PTR(-ENOENT);
> > > >>  	if (tgid) {
> > > >>-		name = __getname();
> > > >>+		/* 10 for max length of an int in decimal + NULL terminator */
> > > >>+		name = kmalloc(11, GFP_KERNEL);
> > > >
> > > >		^^^^^
> > > >Bah...my mistake. This should be "12", since it's possible (though
> > > >unlikely) that this value could be negative. Is there a better way to
> > > >express "strlen of max representation of an int in decimal" ?
> > 
> > It'd be nice to have something--I've run across similar mistakes
> > recently.
> > 
> > > 
> > > See INT_BUFSIZE_BOUND() in:
> > > http://git.sv.gnu.org/gitweb/?p=gnulib.git;a=blob;f=lib/intprops.h;hb=HEAD
> > 
> > My lame attempt follows.  It's simpler than Pádraig's but possibly also
> > stupider.
> > 
> > --b.
> > 
> > commit 15e8c46104e0c1dd6a76d09b55563b6f83b61667
> > Author: J. Bruce Fields <bfields@redhat.com>
> > Date:   Wed Aug 15 17:41:47 2012 -0400
> > 
> >     strings: helper for maximum decimal encoding of an unsigned integer
> >     
> >     I've seen a couple examples recently where we've gotten this wrong.
> >     Maybe something like this would help?
> >     
> >     Suggested-by: Jim Rees <rees@umich.edu>
> >     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> > 
> > diff --git a/include/linux/string.h b/include/linux/string.h
> > index ffe0442..3674cf5 100644
> > --- a/include/linux/string.h
> > +++ b/include/linux/string.h
> > @@ -126,6 +126,12 @@ extern void argv_free(char **argv);
> >  extern bool sysfs_streq(const char *s1, const char *s2);
> >  extern int strtobool(const char *s, bool *res);
> >  
> > +/*
> > + * length of the decimal representation of an unsigned integer.  Just an
> > + * approximation, but it's right for types of size 1 to 26 bytes:
> > + */
> > +#define base10len(i) (sizeof(i) * 24 / 10 + 1)
> > +
> >  #ifdef CONFIG_BINARY_PRINTF
> >  int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
> >  int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
> > diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
> > index 2afd2a8..1dcd2b3 100644
> > --- a/net/sunrpc/cache.c
> > +++ b/net/sunrpc/cache.c
> > @@ -1409,7 +1409,7 @@ static ssize_t read_flush(struct file *file, char __user *buf,
> >  			  size_t count, loff_t *ppos,
> >  			  struct cache_detail *cd)
> >  {
> > -	char tbuf[20];
> > +	char tbuf[base10len(unsigned long) + 2];
> >  	unsigned long p = *ppos;
> >  	size_t len;
> >  
> 
> Thanks Bruce and Pádraig...
> 
> Bruce, are you planning to push that patch for 3.7? If so, I'll base
> mine on top of yours...

I assumed string.h is outside my baliwick--I'm not sure where it should
go.  Linus or Andrew?

--b.
