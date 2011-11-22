Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1KVFvM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 00:51:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1KVFvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 00:51:11 -0500
Message-ID: <4ECB3839.50908@redhat.com>
Date: Tue, 22 Nov 2011 13:50:49 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Hugh Dickins <hughd@google.com>, Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [V2 PATCH] tmpfs: add fallocate support
References: <1321612791-4764-1-git-send-email-amwang@redhat.com> <20111119100326.GA27967@infradead.org> <CAPXgP10q8Fba3vr0zf-XBBaRPwjP7MyJ=-QRL45_8WC-vtotOg@mail.gmail.com> <alpine.LSU.2.00.1111201322310.1264@sister.anvils> <20111121101059.GB17887@infradead.org>
In-Reply-To: <20111121101059.GB17887@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月21日 18:11, Christoph Hellwig 写道:
> On Sun, Nov 20, 2011 at 01:39:12PM -0800, Hugh Dickins wrote:
>>> To be able to safely use mmap(), regarding SIGBUS, on files on the
>>> /dev/shm filesystem. The glibc fallback loop for -ENOSYS on fallocate
>>> is just ugly.
>>
>> The fallback for -EOPNOTSUPP?
>
> Probably for both.  Note that the fallocate man page actually documents
> the errors incorrecly - it documents ENOSYS for filesystems not
> supporting fallocate, and EOPNOTSUPP for not recognizing the mode, but
> we actually return EOPNOTSUPP for either case.  ENOSYS is only returned
> by kernels not implementing fallocate at all.

We need to fix man page of fallocate(2)...

>
>> Being unfamiliar with glibc, I failed to find the internal_fallocate()
>> that it appears to use when the filesystem doesn't support the call;
>> so I don't know if I would agree with you that it's uglier than doing
>> the same(?) in the kernel.
>
> Last time I looked it basically did a pwrite loop writing zeroes.
> Unfortunately it did far too small I/O sizes and thus actually causes
> some major overhead e.g. on ext3.
>
>> But since the present situation is that tmpfs has one interface to
>> punching holes, madvise(MADV_REMOVE), that IBM were pushing 5 years ago;
>> but ext4 (and others) now a fallocate(FALLOC_FL_PUNCH_HOLE) interface
>> which IBM have been pushing this year: we do want to normalize that
>> situation and make them all behave the same way.
>
> FALLOC_FL_PUNCH_HOLE was added by Josef Bacik, who happens to work for
> Red Hat, but I doubt he was pushing any corporate agenda there, he was
> mostly making btrfs catch up with the 15 year old XFS hole punching
> ioctl.

I sent a patch to util-linux-ng too,

http://thread.gmane.org/gmane.linux.utilities.util-linux-ng/5045

>
>
>> And if tmpfs is going to support fallocate(FALLOC_FL_PUNCH_HOLE),
>> looking at Amerigo's much more attractive V2 patch, it would seem
>> to me perverse to permit the deallocation but fail the allocation.
>
> Agreed.
>

Thanks.
