Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2JMMhe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 08:37:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48301 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2JMMhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 08:37:32 -0400
Message-ID: <1350131840.1917.53.camel@kjgkr>
Subject: Re: [PATCH 00/16] f2fs: introduce flash-friendly file system
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        David Woodhouse <dwmw2@infradead.org>,
        Luk Czerner <lczerner@redhat.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, tytso@mit.edu,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com, linux-fsdevel@vger.kernel.org
Date: Sat, 13 Oct 2012 21:37:20 +0900
In-Reply-To: <CAKYAXd99LRV0VqpGRKxBnDd7MORkLJScZ7M5k14sZmxz-uS-Gw@mail.gmail.com>
References: <415E76CC-A53D-4643-88AB-3D7D7DC56F98@dubeyko.com>
	 <alpine.LFD.2.00.1210091020390.11244@dhcp-1-104.brq.redhat.com>
	 <1349865374.6072.78.camel@shinybook.infradead.org>
	 <2456603.OlK4shzgJ4@wuerfel>
	 <CAKYAXd99LRV0VqpGRKxBnDd7MORkLJScZ7M5k14sZmxz-uS-Gw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-13 (토), 13:26 +0900, Namjae Jeon:
> Is there high possibility that the storage device can be rapidly
> worn-out by cleaning process ? e.g. severe fragmentation situation by
> creating and removing small files.
> 

Yes, the cleaning process in F2FS induces additional writes so that
flash storage can be worn out quickly.
However, how about in traditonal file systems?
As all of us know that, FTL has an wear-leveling issue too due to the
garbage collection overhead that is fundamentally similar to the
cleaning overhead in LFS or F2FS.

So, what's the difference between them?
IMHO, the major factor to reduce the cleaning or garbage collection
overhead is how to efficiently separate hot and cold data.
So, which is a better layer between FTL and file system to achieve that?
I think the answer is the file system, since the file system has much
more information on such a hotness of all the data, but FTL doesn't know
or is hard to figure out that kind of information.

Therefore, I think the LFS approach is more beneficial to span the life
time of the storage rather than traditional one.
And, in order to do this perfectly, one thing is a criteria, the
alignment between FTL and F2FS.

> And you told us only advantages of f2fs. Would you tell us the disadvantages ?

I think there is a scenario like this.
1) One big file is created and written data sequentially.
2) Many random writes are done across the whole file range.
3) User discards cached data by doing "drop_caches" or "reboot".

At this point, I worry about the sequential read performance due to the
fragmentation.
I don't know how frequently this use-case happens, but it is one of cons
in the LFS approach.
Nevertheless, I'm thinking that the performance could be enhanced by
cooperating with a readahead mechanism in VFS.

Thanks,

> 
> Thanks.

-- 
Jaegeuk Kim
Samsung

