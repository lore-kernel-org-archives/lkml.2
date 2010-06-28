Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0F1RSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:18:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61268 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab0F1RSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:18:22 -0400
To: James Bottomley <James.Bottomley@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
       axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       martin.petersen@oracle.com, akpm@linux-foundation.org,
       linux-scsi@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request payload
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100622180029.GA15950@redhat.com>
	<1277582211-10725-1-git-send-email-snitzer@redhat.com>
	<1277652576.4366.19.camel@mulgrave.site>
Date: Mon, 28 Jun 2010 13:16:42 -0400
In-Reply-To: <1277652576.4366.19.camel@mulgrave.site> (James Bottomley's
	message of "Sun, 27 Jun 2010 10:29:36 -0500")
Message-ID: <yq1sk47dqmd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C28D90D.01C9:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

James> I really hate these growing contortions for discard.  They're a
James> clear signal that we haven't implemented it right.

James> So let's first work out how it should be done.  I really like
James> Tomo's idea of doing discard through the normal REQ_TYPE_FS
James> route, which means we can control the setup in prep and the tear
James> down in done, all confined to the ULD.

Yeah, this is what I was trying to do a couple of months ago.  Trying to
make discard and write same filesystem class requests so we can split,
merge, etc. like READs and WRITEs.  I still think this is how we should
do it but it's a lot of work.

There are several challenges involved.  I was doing the "payload"
allocation at request allocation time by permitting a buffer trailing
struct request (size defined by ULD depending on req type).  However, we
have a few places in the stack where we memcpy requests and assume them
to be the same size.  That needs to be fixed.  That's also the roadblock
I ran into wrt. 32-byte CDB allocation so for that I ended up allocating
the command in sd.

Also, another major headache of mine is WRITE SAME/UNMAP to DSM TRIM
conversion.  Because of the limitations of the TRIM command format a
single WRITE SAME can turn into effectively hundreds of TRIM commands to
be issued.  I tried to limit this by using UNMAP translation instead.
But we can still get into cases where we need to either loop or allocate
a bunch of TRIMs in the translation layer.  That leaves two options:
Either pass really conservative limits up the stack and loop up there.
Or deal with the allocation/translation stuff at the bottom of the pile.
None of my attempts in these departments turned out to be very nice.
I'm still dreaming of the day where libata moves out from under SCSI so
we don't have to translate square pegs into round holes...

-- 
Martin K. Petersen	Oracle Linux Engineering
