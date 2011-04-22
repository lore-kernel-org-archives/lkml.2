Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab1DVQ2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:28:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40879 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756107Ab1DVQ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:28:28 -0400
Message-ID: <4DB1AC9D.3010706@oracle.com>
Date: Fri, 22 Apr 2011 09:28:13 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Eric Blake <eblake@redhat.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com>
In-Reply-To: <4DB16B72.1050702@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DB1ACA4.00CD:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 04:50 AM, Eric Blake wrote:
> That blog also mentioned the useful idea of adding FIND_HOLE and
> FIND_DATA, not implemented in Solaris, but which could easily be
> provided as additional lseek constants in Linux to locate the start of
> the next chunk without repositioning and which could ease application
> programmer's life a bit.  After all, cp wants to know where data ends
> without repositioning (FIND_HOLE), read() that much data which
> repositions in the process, then skip to the next chunk of data
> (SEEK_DATA) - two lseek() calls per iteration if we have 4 constants,
> but 3 per iteration if we only have SEEK_HOLE and have to manually rewind.

while(1) {
     read(block);
     if (block_all_zeroes)
         lseek(SEEK_DATA);
}

What's wrong with the above? If this is the case, even SEEK_HOLE
is not needed but should be added as it is already in Solaris.

My problem with FIND_* is that we are messing with the well understood
semantics of lseek().

And if generic_file_llseek_unlocked() treats SEEK_DATA as SEEK_CUR and
SEEK_HOLE as SEEK_END (both with zero offset) then we don't even
have to bother with the finding the "correct" error code.

