Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab2CVCd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 22:33:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17392 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab2CVCdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 22:33:11 -0400
To: Shaohua Li <shli@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, neilb@suse.de,
        martin.petersen@oracle.com
Subject: Re: [patch 1/2]block: handle merged discard request
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120316073213.656519005@fusionio.com>
	<20120316073512.485027511@fusionio.com>
	<20120320162157.GE17071@redhat.com>
	<CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
	<4F69C62C.7020604@kernel.org>
Date: Wed, 21 Mar 2012 22:32:54 -0400
In-Reply-To: <4F69C62C.7020604@kernel.org> (Shaohua Li's message of "Wed, 21
	Mar 2012 20:14:36 +0800")
Message-ID: <yq18vitwejt.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090202.4F6A8F5A.0073,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Shaohua" == Shaohua Li <shli@kernel.org> writes:

Shaohua> The SCSI discard implementation hacks the first bio of request
Shaohua> to add payload, which makes blk_update_request() can't
Shaohua> correctly mark bios finish.  The patch solves it. We set
Shaohua> discard bio size to 0 and finish it after the hacked payload
Shaohua> finishes.

Ick!

Also, you can't muck with bi_size because if we get an I/O error and
have to reissue the command we no longer know how much to write.

I have had to deal with the same issue for WRITE SAME. And the only sane
approach is to distinguish between the DMA transfer size and the blocks
"affected" by the command. That's what I'm working on right now for copy
offload...

If this is something you want in 3.4 I guess we could temporarily add a
separate length field to struct request. If you can wait I suggest we
talk at LSF.

-- 
Martin K. Petersen	Oracle Linux Engineering
