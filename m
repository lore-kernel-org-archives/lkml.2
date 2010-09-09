Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0IIRaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 13:30:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41288 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0IIRaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 13:30:19 -0400
Subject: Re: 2.6.36-rc3: EIP is at scsi_init_io+...
From: James Bottomley <James.Bottomley@suse.de>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4C88D841.3070100@fusionio.com>
References: <20100830184620.GA4818@core2.telecom.by>
	 <AANLkTikyv10vkg1g+G3LW+nu=0omBpc40KehOUH=YXk2@mail.gmail.com>
	 <1284036441.20480.2.camel@mulgrave.site>  <4C88D841.3070100@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 12:30:09 -0500
Message-ID: <1284053409.20480.62.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 14:51 +0200, Jens Axboe wrote:
> On 2010-09-09 14:47, James Bottomley wrote:
> > On Wed, 2010-09-08 at 17:12 -0700, Linus Torvalds wrote:
> >> Hmm. No noise about this one.
> >>
> >> Jens, Fujita, James, any comments?
> >>
> >> On Mon, Aug 30, 2010 at 11:46 AM, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >>> Not much of a calltrace, it scrolled away because of hardlockup detector.
> >>> On the bright side, radeon KMS worked correctly and actually showed it.
> >>>
> >>> $ addr2line -e vmlinux ffffffff812d207b
> >>> drivers/scsi/scsi_lib.c:1015
> >>>
> >>>  1012  err_exit:
> >>>  1013          scsi_release_buffers(cmd);
> >>>  1014          scsi_put_command(cmd);
> >>>  1015  ===>    cmd->request->special = NULL; <===
> >>>  1016          return error;
> >>>  1017  }
> >>>  1018  EXPORT_SYMBOL(scsi_init_io);
> >>
> >> I do have to say that it looks rather wrong that it accesses "cmd"
> >> after it has done the "scsi_put_command(cmd)" on it.
> >>
> >> I also note that that was introduced pretty recently by commit
> >> 610a63498f7 ("scsi: fix discard page leak"), merged during this merge
> >> window. That does look suspicious to me.
> > 
> > It's a use after free:  The put actually frees the cmnd and then we use
> > it to get to the request.  Most of the time nothing notices, but if you
> > have poison on free enabled, we may see the problem.  The fix is just to
> > reverse the put and the set.
> 
> You are right, I misspoke in my original reply. It's clearing the
> request field, not the command field (which would be bogus of course).

Embarrassingly enough, Tejun spotted this a month ago, and I actually
created a patch and then forgot to apply it.  I've just pushed it out to
the rc-fixes branch:

http://marc.info/?l=linux-scsi&m=128197119525504

James



