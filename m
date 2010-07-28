Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab0G1TXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:23:14 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50882 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0G1TXM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:23:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=glv+M2NnWK7qy7gGvAjryrQ9JiycW7bhzFN6TLof1otBAjOkNWL3rqWIiMt2Awz+5X
         x8vxxT6hiUveRmWL/sE6M+I4o045IStvoVHpkCnK7So4P3XYbX5epYk4SrQ0XIxKkdU8
         0NbnhtjVtQZQJpGuXnsnQODQ0YHYVhB5XIH1c=
MIME-Version: 1.0
In-Reply-To: <1279741966.25713.31.camel@dwillia2-linux>
References: <1279741966.25713.31.camel@dwillia2-linux>
Date: Wed, 28 Jul 2010 12:23:11 -0700
X-Google-Sender-Auth: g9KbRUXCEU3WsV1bTkCpKV-7goM
Message-ID: <AANLkTinNOo1_-KJ2CC_-ACBaDtmWjGX3+Vy60ND17guH@mail.gmail.com>
Subject: Re: md versus partition scanning (bd_invalidated)
From: Dan Williams <dan.j.williams@intel.com>
To: Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>,
        Ed Ciechanowski <ed.ciechanowski@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:52 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Hi,
>
> We (Intel software raid devs) are seeing a problem with the detection of
> partitions on md devices.  The trace below shows that the block device
> inode is dropped in-between when the array comes up and when it is first
> opened (timestamp 655.498875).  When this happens bdev->bd_invalidated
> is cleared by bdget() and we never detect partitions.  (Seen on a 2.6.32
> based kernel, but I presume it is still present)

The kernel in question was missing commit f3b99be1 "Restore partition
detection of newly created md arrays" [1].  With that in place the
problem goes away.  I haven't fully convinced myself that there isn't
a small race that could be triggered by changing the array size via
sysfs, to get the the gendisk size updated and then dropping all inode
references prior to the first open... but I'll put that investigation
on the back burner.

--
Dan

[1]: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=f3b99be1
