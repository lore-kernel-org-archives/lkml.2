Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524Ab2GSNt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:49:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab2GSNt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:49:26 -0400
Date: Thu, 19 Jul 2012 09:49:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: Re: [PATCH] kdump: Append newline to the last lien of vmcoreinfo note
Message-ID: <20120719134920.GA2761@redhat.com>
References: <20120717173655.GC11031@redhat.com>
 <20120718150439.48360f16.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120718150439.48360f16.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 03:04:39PM -0700, Andrew Morton wrote:
> On Tue, 17 Jul 2012 13:36:55 -0400
> Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > Last line of vmcoreinfo note does not end with \n. Parsing all the lines
> > in note becomes easier if all lines end with \n instead of trying to special
> > case the last line.
> > 
> > I know atleast one tool, vmcore-dmesg in kexec-tools tree which made the
> > assumption that all lines end with \n. I think it is a good idea to
> > fix it.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  kernel/kexec.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6/kernel/kexec.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/kexec.c	2012-07-17 19:26:38.844033784 -0400
> > +++ linux-2.6/kernel/kexec.c	2012-07-17 23:51:33.311701781 -0400
> > @@ -1424,7 +1424,7 @@ static void update_vmcoreinfo_note(void)
> >  
> >  void crash_save_vmcoreinfo(void)
> >  {
> > -	vmcoreinfo_append_str("CRASHTIME=%ld", get_seconds());
> > +	vmcoreinfo_append_str("CRASHTIME=%ld\n", get_seconds());
> >  	update_vmcoreinfo_note();
> >  }
> 
> huh, that was a screwup.  And now we have to make what must be
> viewed as a non-back-compatible ABI change.
> 
> Ho hum, presumably there isn't a lot of code out there which is
> dependent upon a non-newline-terminated CRASHTIME record.

I think so. AFAIK, makedumpfile (vmcore filtering utility) is only
user of CRASHTIME=.

> 
> Why did this work at all, anyway?  Is CRASHTIME always the last-emitted
> record?

Yes, CRASHTIME= is always the last emitted line in vmcoreinfo note.

I had a quick look at makedumpfile code and looks like they read the whole
note, dump it to a file and then do fgets() on the file in a loop. As it is
last line in the file, fgets encounters EOF and reads the CRASHTIME= line
successfully. So even after this change makedumpfile should remain
unaffected. 

CCing makedumpfile maintainer, Atsushi Kumagai.

Thanks
Vivek
