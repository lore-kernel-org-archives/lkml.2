Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab1DVQ5r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 12:57:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41554 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab1DVQ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 12:57:45 -0400
Message-ID: <4DB1B37C.9070406@oracle.com>
Date: Fri, 22 Apr 2011 09:57:32 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Eric Blake <eblake@redhat.com>
CC: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <loom.20110422T001650-760@post.gmane.org> <BANLkTiknb+hzFAjpwESwMcqMVtkFc0HFQQ@mail.gmail.com> <20110422045054.GB17795@infradead.org> <20110422112852.GB1627@x4.trippels.de> <4DB16B72.1050702@redhat.com> <4DB1AC9D.3010706@oracle.com> <4DB1AF6F.4040706@redhat.com>
In-Reply-To: <4DB1AF6F.4040706@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DB1B381.0124:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 09:40 AM, Eric Blake wrote:
> On 04/22/2011 10:28 AM, Sunil Mushran wrote:
>> while(1) {
>>      read(block);
>>      if (block_all_zeroes)
>>          lseek(SEEK_DATA);
>> }
>>
>> What's wrong with the above? If this is the case, even SEEK_HOLE
>> is not needed but should be added as it is already in Solaris.
> Because you don't know if the block is the same size as the minimum
> hole, and because some systems require rather large holes (my Solaris
> testing on a zfs system didn't have holes until 128k), that's a rather
> large amount of reading just to prove that the block has all zeros to
> know that it is even worth trying the lseek(SEEK_DATA).  My gut feel is
> that doing the lseek(SEEK_HOLE) up front coupled with seeking back to
> the same position is more efficient than manually checking for a run of
> zeros (less cache pollution, works with 4k read buffers without having
> to know filesystem hole size).

Holes are an implementation detail.

cp can read whatever blocksize it chooses. If that block contains
zero, it would signal cp that maybe it should SEEK_DATA and skip
reading all those blocks. That's all. We are not trying to achieve
perfection. We are just trying to reduce cpu waste.

If the fs supports SEEK_*, then great. If it does not, then it is no
worse than before.
