Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030416Ab2GLKOD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 06:14:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33496 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030343Ab2GLKN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 06:13:57 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Cc: hanwen@xs4all.nl, Han-Wen Nienhuys <hanwenn@gmail.com>,
        Liu Yuan <namei.unix@gmail.com>, fuse-devel@lists.sourceforge.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [fuse-devel] [RFC PATCH 0/5] fuse: make maximum read/write request size tunable
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
	<4FF67D6A.8060707@gmail.com>
	<CAOw_e7ZGdSVrNfPe8iE8BtmNWU+BrvbaMFVsUP+g+3MR0Pegqw@mail.gmail.com>
	<4FFE6785.80201@hitachi.com>
Date: Thu, 12 Jul 2012 12:13:53 +0200
In-Reply-To: <4FFE6785.80201@hitachi.com> (HAYASAKA Mitsuo's message of "Thu,
	12 Jul 2012 14:58:29 +0900")
Message-ID: <878vep478e.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com> writes:

> Hi Yuan and Han-Wen,
>
> Thank you for your comments.
>
> (2012/07/06 22:58), Han-Wen Nienhuys wrote:
>> On Fri, Jul 6, 2012 at 2:53 AM, Liu Yuan<namei.unix@gmail.com>  wrote:
>>> On 07/05/2012 06:50 PM, Mitsuo Hayasaka wrote:
>>>> One of the ways to solve this is to make them tunable.
>>>> In this series, the new sysfs parameter max_pages_per_req is introduced.
>>>> It limits the maximum read/write size in fuse request and it can be
>>>> changed from 32 to 256 pages in current implementations. When the
>>>> max_read/max_write mount option is specified, FUSE request size is set
>>>> per mount. (The size is rounded-up to page size and limited up to
>>>> max_pages_per_req.)
>>>
>>> Why maxim 256 pages? If we are here, we can go further: most of object
>>> storage system has object size of multiple to dozens of megabytes. So I
>>> think probably 1M is too small. Our distribution storage system has 4M
>>> per object, so I think at least maxim size could be bigger than 4M.
>>
>> The maximum pipe size on my system is 1M, so if you go beyond that,
>> splicing from the FD won't work.
>>
>> Also, the userspace client must reserve a buffer this size so it can
>> receive a write, which is a waste since most requests are much
>> smaller.
>>
>
> I checked the maximum pipe size can be changed using fcntl(2) or
> /proc/sys/fs/pipe-max-size. It is clear that it is not a fixed value.
>
> Also, it seems that there is a request for setting the maximum number
> of pages per fuse request to 4M (1024 pages). One of the reasons to
> introduce the sysfs max_pages_per_req parameter is to set a threshold
> of the maximum number of pages dynamically according to the
> administrator's demand, and root can only change it.
>
> So, when the maximum value is required to be set to not more than the
> pipe-max-size, the max_pages_per_req should be changed considering it.
> It seems that the upper limit of this parameter does not have to be
> not more than it.
>
> I'm planning to limit max_pages_per_req up to 1024 pages and add the
> document to /Documentation/filesystems/fuse.txt, as follows.
>
> "the sysfs max_pages_per_req parameter can be changed from 32 to 1024.
> The default is 32 pages. Generally, the pipe-max-size is 1M (256 pages)
> and it is better to set it to not more than the pipe-max-size."

Can't we just use pipe-max-size for the limit?

Then we'll use the minimum of pipe-max-size and max_read/max_write for
sizing the requests.

Another comment: do we really need to allocate each and every request
with space for the pages?  I don't think that makes sense.  Let's leave
some small number of pages inline in the request and allocate a separate
array if the number of pages is too large.  There may even be some utilities
in the kernel to handle dynamically sized page arrays (I haven't looked
but I suspect there is).

Thanks,
Miklos
