Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab0JZIGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:06:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43784 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab0JZIGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UCEAn5hvlmcVzLtNsrkQBNIJXxAESTqRMGqD3eugxrTRd+fz9wXlztzQQwuRJehliV
         BMXh96V6N6cM0HCnKsT/kcpdDlGy130L5pinAyL0fKHYkaSgt6dlCSag6w1FSJmKTuRi
         9UQG48Q27QIJU2wtjmbdpyKmN9cp34hi+TaMo=
Subject: Re: [PATCH UPDATED] fs/buffer.c: call __block_write_begin() if we
 have page
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101025161137.5f0b642d.akpm@linux-foundation.org>
References: <1287848786-13347-1-git-send-email-namhyung@gmail.com>
	 <1287850314-13663-1-git-send-email-namhyung@gmail.com>
	 <20101025161137.5f0b642d.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Oct 2010 17:06:34 +0900
Message-ID: <1288080394.1695.3.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-10-25 (월), 16:11 -0700, Andrew Morton:
> On Sun, 24 Oct 2010 01:11:54 +0900
> Namhyung Kim <namhyung@gmail.com> wrote:
> 
> > If we have the appropriate page already, call __block_write_begin()
> > directly instead of releasing and regrabbing it inside of
> > block_write_begin().
> > 
> > Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> > ---
> > Fix error path.
> > 
> >  fs/buffer.c |   12 +++++++-----
> >  1 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 7f0b9b0..f5755f7 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -2466,11 +2466,13 @@ int nobh_write_begin(struct address_space *mapping,
> >  	*fsdata = NULL;
> >  
> >  	if (page_has_buffers(page)) {
> > -		unlock_page(page);
> > -		page_cache_release(page);
> > -		*pagep = NULL;
> > -		return block_write_begin(mapping, pos, len, flags, pagep,
> > -					 get_block);
> > +		ret = __block_write_begin(page, pos, len, get_block);
> > +		if (unlikely(ret)) {
> > +			unlock_page(page);
> > +			page_cache_release(page);
> > +			*pagep = NULL;
> > +		}
> > +		return ret;
> >  	}
> >  
> >  	if (PageMappedToDisk(page))
> 
> It looks OK.  Was it tested?  (ext2 mounted with -o nobh)

I just did tar && untar with current kernel source several times on UML.
It worked find for me. Thanks.


-- 
Regards,
Namhyung Kim


