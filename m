Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965245Ab2JCQWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 12:22:23 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43168 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964882Ab2JCQWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 12:22:19 -0400
To: Kent Overstreet <koverstreet@google.com>
Cc: NeilBrown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        martin.petersen@oracle.com
Subject: Re: [PATCH] block: makes bio_split support bio without data
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120924145639.3b65fd8b@notabene.brown>
	<20120928162343.GF22647@google.com>
	<20121002162201.2f5d0f91@notabene.brown>
	<20121002210923.GU26488@google.com>
	<20121003133045.272dd564@notabene.brown>
	<20121003034159.GA24174@moria.home.lan>
Date: Wed, 03 Oct 2012 12:22:07 -0400
In-Reply-To: <20121003034159.GA24174@moria.home.lan> (Kent Overstreet's
	message of "Tue, 2 Oct 2012 20:42:00 -0700")
Message-ID: <yq1zk43zftc.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kent" == Kent Overstreet <koverstreet@google.com> writes:

Kent> I think we should be able to split REQ_DISCARD bios that have a
Kent> payload or REQ_WRITE_SAME bios just fine though - for both of
Kent> those cases, the payload doesn't correspond to a particular
Kent> sector, so just copy the original bvec to the two splits and don't
Kent> do anything else to it.

DISCARD bios come down with a single bvec that is later used in the SCSI
disk driver to describe a memory page that can then be mapped into a
scatter-gather list. The reason for this is that both ATA TRIM and SCSI
UNMAP put the block range descriptors in the payload rather than in the
command itself. By the time MD calls bio_split there will be an empty
bvec in the bio.

For WRITE SAME the parent payload contains a bvec describing a single
logical block of data (i.e. typically 512 bytes). The same bvec is used
for both bios in the pair.

For neither DISCARD, nor WRITE SAME do we need to muck with bv_offset
and bv_len. As a result, my patch uses the bio_is_rw() conditional to
wrap the the bvec munging code.

-- 
Martin K. Petersen	Oracle Linux Engineering
