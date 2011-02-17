Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1BQAXp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:23:45 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41359 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781Ab1BQAXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=GtxkpsPehSoSKJVu9XtoRD+nKxzUaCcO39Oyr8HAbvtHgrk2fr+DTwU4Cv1perIgAO
         ino9iUayvV6DHMwHy29k8Tu0dHE23r88BuerXvAtQqrQms8Q9cSTOK0bIEB2xBET78gF
         u8nThyEDaIy78n40qxB2WdqMM3AK4TmdbTcYM=
Date: Thu, 17 Feb 2011 01:23:35 +0100
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>
Subject: Re: [Patch v2] block: revert block_dev read-only check
Message-ID: <20110217002335.GI29600@atj.dyndns.org>
References: <20110216181153.5b8f81d5@katamari>
 <20110216232816.GH29600@atj.dyndns.org>
 <AANLkTikuMNjk=nBvaARXJ0LBp_8OS+-iMv20t-rf34ph@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikuMNjk=nBvaARXJ0LBp_8OS+-iMv20t-rf34ph@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helo,

On Wed, Feb 16, 2011 at 03:56:10PM -0800, Linus Torvalds wrote:
> > The commit was part of effort to enforce the ro flag.  It at least
> > makes sure that a device can't be opened RW if marked RO.  loop and dm
> > showed some problems but fixing the in-kernel part isn't difficult
> > (fixes pending).
> 
> Well, if the thing breaks things, then it needs to be reverted, or
> those fixes need to not be "pending".

They should be mergeable once Jens comes back.

> > IIUC, the problematic part is dm userland, which reportedly opens
> > member devices RW even when building a RO device.  The problem is when
> > a user is trying to build RO dm device from RO member devices.  dm
> > userland tries to open the member devices RW, which block layer
> > rejects now thus failing dm assembly.
> 
> .. this makes me all the more suspicious. Sounds unfixable in a single
> release (or even a few years). So it smells like we should (a) do the
> revert and (b) add a warning for the case where somebody opens a
> device RW where the low-level device itself is RO.

Yeap, I'm not against reverting.  That is likely the right thing to do
in this cycle anyway.

> That said, if the user has permission to open the device RW (and the
> normal device node permission checks have obviously always done that
> check), I do think it's perfectly ok to do that. And if the user never
> writes to it, then the fact that the device isn't writable is
> irrelevant.

It has been a while so the details might be a bit off but read/write
permissions on block devices are rather weird.

* RO block devices can be opened RW.

* Block devices can get writes whether the device is opened RO or RW.

* Filesystem journal replay and probably some of stacking block driver
  metadata updates issue writes to RO block devices.

So, IIUC, there already are paths where writes are issued and
processed where they shouldn't be.  Everything is RO but the block
device ends up being modified.

Thanks.

--
tejun
