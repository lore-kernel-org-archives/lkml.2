Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591Ab1KXDXD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 22:23:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724Ab1KXDXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 22:23:01 -0500
Message-ID: <4ECDB87A.90106@redhat.com>
Date: Thu, 24 Nov 2011 11:22:34 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Pekka Enberg <penberg@kernel.org>, Christoph Hellwig <hch@lst.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-mm@kvack.org
Subject: Re: [V3 PATCH 1/2] tmpfs: add fallocate support
References: <1322038412-29013-1-git-send-email-amwang@redhat.com>	<20111124105245.b252c65f.kamezawa.hiroyu@jp.fujitsu.com>	<CAHGf_=oD0Coc=k5kAAQoP=GqK+nc0jd3qq3TmLZaitSjH-ZPmQ@mail.gmail.com> <20111124120126.9361b2c9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111124120126.9361b2c9.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2011年11月24日 11:01, KAMEZAWA Hiroyuki 写道:
> On Wed, 23 Nov 2011 21:46:39 -0500
> KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>  wrote:
>
>>>> +     while (index<  end) {
>>>> +             ret = shmem_getpage(inode, index,&page, SGP_WRITE, NULL);
>>>
>>> If the 'page' for index exists before this call, this will return the page without
>>> allocaton.
>>>
>>> Then, the page may not be zero-cleared. I think the page should be zero-cleared.
>>
>> No. fallocate shouldn't destroy existing data. It only ensure
>> subsequent file access don't make ENOSPC error.
>>
>        FALLOC_FL_KEEP_SIZE
>                This flag allocates and initializes to zero the disk  space
>                within the range specified by offset and len. ....
>
> just manual is unclear ? it seems that the range [offset, offset+len) is
> zero cleared after the call.

I think we should fix the man page, because at least ext4 doesn't clear
the original contents,

% echo hi > /tmp/foobar
% fallocate -n -l 1 -o 10 /tmp/foobar
% hexdump -Cv /tmp/foobar
00000000  68 69 0a                                          |hi.|
00000003
