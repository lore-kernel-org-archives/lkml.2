Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0LTB2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 20:28:06 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:34097 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0LTB2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 20:28:03 -0500
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less w/
	interrupts disabled internally
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>
In-Reply-To: <1292807703.20840.29.camel@haakon2.linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>
	 <20101219233835.GJ1263@parisc-linux.org>
	 <1292807703.20840.29.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain
Date: Sun, 19 Dec 2010 17:22:06 -0800
Message-Id: <1292808126.20840.33.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 17:15 -0800, Nicholas A. Bellinger wrote:
> On Sun, 2010-12-19 at 16:38 -0700, Matthew Wilcox wrote:
> > On Sun, Dec 19, 2010 at 01:21:56PM -0800, Nicholas A. Bellinger wrote:
> > > This patch changes iscsi_queuecommand_lck() to a host_lock less
> > > iscsi_queuecommand() that will internally disable interrupts using
> > > session->lock and drop the now legacy host_lock unlock.
> > 
> > I think this patch is buggy.  Before, iscsi_queuecommand_lck is called with
> > interrupts disabled.  Now, it's called with interrupts disabled.  Elsewhere,
> > session->lock is acquired with bh's disabled:
> > 
> > void iscsi_put_task(struct iscsi_task *task)
> > {
> >         struct iscsi_session *session = task->conn->session;
> > 
> >         spin_lock_bh(&session->lock);
> > 
> > So I think you need to convert the
> >         spin_lock(&session->lock);
> > in iscsi_queuecommand_lck to at least a spin_lock_bh, and possibly
> > a spin_lock_irq -- it's not clear to me whether it needs to exclude
> > against interrupt context, or only BH context.  In some places, it's
> > taken with spin_lock_irqsave().
> > 
> > I'd play it safe and use _irq, but someone more confident with this code
> > might choose to only use _bh.
> > 
> 
> Hmmm, indeed..  I must have dropped this recently as the last patch for
> libiscsi posted below still has been converted to spin_lock_irq() for
> session->lock here:
> 
> http://marc.info/?l=linux-scsi&m=128952081412461&w=2
> 
> Converting back to spin_lock_irq() usage for the moment..  Thanks alot
> of noticing this..
> 
> MikeC and Hannes, do you think this is safe to use spin_lock_bh() as
> well..?
> 

Actually sorry, Mike Christie did already make a clarification on this
subject here:

http://marc.info/?l=linux-scsi&m=129010439421506&w=2

I had originally thought the same that session->lock should be using
some flavour of spin_lock_irq*() as well, but apparently this is not the
case for libiscsi.

Best Regards,

--nab


