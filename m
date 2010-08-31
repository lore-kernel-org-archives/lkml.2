Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0HaVtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 17:49:49 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:47582 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753556Ab0HaVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 17:49:47 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: guenter.roeck@ericsson.com
Subject: Re: [PATCH] [RFC] [resend] isofs: work-around for Rock Ridge+Joliet CDs with empty ISO root directory
Date: Tue, 31 Aug 2010 23:49:38 +0200
User-Agent: KMail/1.9.10
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201008312010.10667.linux@rainbow-software.org> <1283287495.9850.17.camel@groeck-laptop>
In-Reply-To: <1283287495.9850.17.camel@groeck-laptop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008312349.40274.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 August 2010 22:44:55 Guenter Roeck wrote:
> On Tue, 2010-08-31 at 14:10 -0400, Ondrej Zary wrote:
> > If a CD has both Rock Ridge and Joliet extensions and the ISO root
> > directory is empty, no files are visible. Disable Rock Ridge extensions
> > in this case and use Joliet root directory instead.
> >
> > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> >
> > --- linux-2.6.35-rc2/fs/isofs/inode.c	2010-06-06 05:43:24.000000000 +0200
> > +++ linux-2.6.35-rc3/fs/isofs/inode.c	2010-08-24 22:43:26.000000000 +0200
> > @@ -549,6 +549,34 @@ static unsigned int isofs_get_last_sessi
> >  }
> >
> >  /*
> > + * Check if root directory is empty (has less than 3 files).
> > + *
> > + * Used to detect broken CDs where ISO root directory is empty but
> > Joliet root + * directory is OK. If such CD has Rock Ridge extensions,
> > they will be disabled + * (and Joliet used instead) or else no files
> > would be visible. + */
> > +static bool rootdir_empty(struct super_block *sb, unsigned long block)
> > +{
> > +	int offset, files, de_len;
> > +	struct iso_directory_record *de;
> > +	struct buffer_head *bh;
> > +
> > +	bh = sb_bread(sb, block);
> > +	if (!bh)
> > +		return true;
> > +	while (files < 3) {
>
> files is uninitialized.
>
> > +		de = (struct iso_directory_record *) (bh->b_data + offset);
>
> offset is uninitialized.
>
> Did you test this patch ?

Oops... I tested it and it seemed to work fine. Even gcc did not complain...

-- 
Ondrej Zary
