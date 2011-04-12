Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab1DLBNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 21:13:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41228 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1DLBM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 21:12:59 -0400
Date: Mon, 11 Apr 2011 21:12:55 -0400
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: NeilBrown <neilb@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
Message-ID: <20110412011255.GA29236@infradead.org>
References: <20110411145022.710c30e9@notabene.brown>
 <4DA2C7BE.6060804@fusionio.com>
 <20110411205928.13915719@notabene.brown>
 <4DA2E03A.2080607@fusionio.com>
 <20110411212635.7959de70@notabene.brown>
 <4DA2E7F0.9010904@fusionio.com>
 <20110411220505.1028816e@notabene.brown>
 <4DA2F00E.6010907@fusionio.com>
 <20110411223623.4278fad1@notabene.brown>
 <4DA2F8AD.1060605@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA2F8AD.1060605@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 02:48:45PM +0200, Jens Axboe wrote:
> Great, once you do that and XFS kills the blk_flush_plug() calls too,
> then we can remove that export and make it internal only.

Linus pulled the tree, so they are gone now.  Btw, there's still some
bits in the area that confuse me:

 - what's the point of the queue_sync_plugs?  It has a lot of comment
   that seem to pre-data the onstack plugging, but except for that
   it's trivial wrapper around blk_flush_plug, with an argument
   that is not used.
 - is there a good reason for the existance of __blk_flush_plug?  You'd
   get one additional instruction in the inlined version of
   blk_flush_plug when opencoding, but avoid the need for chained
   function calls.
 - Why is having a plug in blk_flush_plug marked unlikely?  Note that
   unlikely is the static branch prediction hint to mark the case
   extremly unlikely and is even used for hot/cold partitioning.  But
   when we call it we usually check beforehand if we actually have
   plugs, so it's actually likely to happen.
 - what is the point of blk_finish_plug?  All callers have
   the plug on stack, and there's no good reason for adding the NULL
   check.  Note that blk_start_plug doesn't have the NULL check either.
 - Why does __blk_flush_plug call __blk_finish_plug which might clear
   tsk->plug, just to set it back after the call? When manually inlining
   __blk_finish_plug ino __blk_flush_plug it looks like:

void __blk_flush_plug(struct task_struct *tsk, struct blk_plug *plug)
{
	flush_plug_list(plug);
	if (plug == tsk->plug)
		tsk->plug = NULL;
	tsk->plug = plug;
}

   it would seem much smarted to just call flush_plug_list directly.
   In fact it seems like the tsk->plug is not nessecary at all and
   all remaining __blk_flush_plug callers could be replaced with
   flush_plug_list.

 - and of course the remaining issue of why io_schedule needs an
   expliciy blk_flush_plug when schedule() already does one in
   case it actually needs to schedule.

