Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab1DKRnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:43:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31179 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab1DKRnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:43:17 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: djwong <djwong@us.ibm.com>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>, Joel Becker <jlbec@evilplan.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
In-reply-to: <20110411124229.47bc28f6@corrin.poochiereds.net>
References: <20110224182732.GV27190@tux1.beaverton.ibm.com> <1298897186-sup-9394@think> <20110304210724.GF27190@tux1.beaverton.ibm.com> <20110308045626.GD1956@dastard> <20110319000755.GD1110@tux1.beaverton.ibm.com> <20110321140451.GA7153@quack.suse.cz> <1300716666-sup-2087@think> <20110321164305.GC7153@quack.suse.cz> <20110406232938.GF1110@tux1.beaverton.ibm.com> <20110407165700.GB7363@quack.suse.cz> <20110408203135.GH1110@tux1.beaverton.ibm.com> <20110411124229.47bc28f6@corrin.poochiereds.net>
Date: Mon, 11 Apr 2011 13:41:16 -0400
Message-Id: <1302543595-sup-4352@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DA33D94.014A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Jeff Layton's message of 2011-04-11 12:42:29 -0400:
> > @@ -5839,6 +5844,15 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >      if (ret < 0)
> >          goto out_unlock;
> >      ret = 0;
> > +
> > +    /*
> > +     * write_begin/end might have created a dirty page and someone
> > +     * could wander in and start the IO.  Make sure that hasn't
> > +     * happened.
> > +     */
> > +    lock_page(page);
> > +    wait_on_page_writeback(page);
> > +    unlock_page(page);
> 
> nit:
> 
> The callers of page_mkwrite always lock the page afterward if you
> return from page_mkwrite with it unlocked. If you plan to take page
> lock anyway, it's probably slightly more efficient not to unlock it and
> instead return VM_FAULT_LOCKED.
> 

Actually this isn't a nit.  Keeping the page locked closes an important
hole where it can become writeback again.  It might fix the last
remaining problem.

-chris
