Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab1A1BgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 20:36:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:49074 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239Ab1A1Bf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 20:35:59 -0500
Date: Thu, 27 Jan 2011 17:35:53 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dsterba@suse.cz, mfasheh@suse.com, linux-kernel@vger.kernel.org,
        ocfs2-devel@oss.oracle.com
Subject: Re: [Ocfs2-devel] fs/ocfs2/dlm: Use GFP_ATOMIC under spin_lock
Message-ID: <20110128013552.GB8019@noexit>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	dsterba@suse.cz, mfasheh@suse.com, linux-kernel@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
References: <20101102223601.GA27513@ds.suse.cz>
 <20110127170948.9a0d8b60.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110127170948.9a0d8b60.akpm@linux-foundation.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 05:09:48PM -0800, Andrew Morton wrote:
> > -       local = kmalloc(sizeof(qr->qr_regions), GFP_KERNEL);
> > +       local = kmalloc(sizeof(qr->qr_regions), GFP_ATOMIC);
> >         if (!local) {
> >                 status = -ENOMEM;
> >                 goto bail;
> > 
> 
> Switching to GFP_ATOMIC is the worst of all possible ways of "fixing"
> this bug.  GFP_ATOMIC is *unreliable*.  We don't want to introduce
> unreliability deep down inside our filesytems.  And fs maintainers who
> don't want to make their filesystems less reliable shouldn't blindly
> apply patches that do so :(

	Fair enough.

> A reliable way of fixing this bug is below.  As an added bonus, it
> makes the fs faster.
> 
> --- a/fs/ocfs2/dlm/dlmdomain.c~a
> +++ a/fs/ocfs2/dlm/dlmdomain.c
> @@ -926,9 +926,9 @@ static int dlm_assert_joined_handler(str
>  }
>  
>  static int dlm_match_regions(struct dlm_ctxt *dlm,
> -			     struct dlm_query_region *qr)
> +			     struct dlm_query_region *qr, u8 *local)
>  {
> -	char *local = NULL, *remote = qr->qr_regions;
> +	char *remote = qr->qr_regions;

	Won't the stack-depth busybodies hate us for this?  I realize we
don't go much deeper from here, but it still is 1K of stack.

Joel

-- 

"When arrows don't penetrate, see...
 Cupid grabs the pistol."

			http://www.jlbec.org/
			jlbec@evilplan.org
