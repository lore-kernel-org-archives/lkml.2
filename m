Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1FOWoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 18:44:23 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50949 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1FOWoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 18:44:21 -0400
Message-ID: <4DF935C1.4020000@codemonkey.ws>
Date: Wed, 15 Jun 2011 17:44:17 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Prasad Joshi <prasadjoshi124@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
References: <1308153214.7566.6.camel@jaguar>	<4DF8DE26.1070301@redhat.com>	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com> <BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com> <4DF92C80.3030106@codemonkey.ws> <7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de> <4DF93010.1040006@codemonkey.ws>
In-Reply-To: <4DF93010.1040006@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2011 05:20 PM, Anthony Liguori wrote:
> On 06/15/2011 05:07 PM, Alexander Graf wrote:
>>
>> On 16.06.2011, at 00:04, Anthony Liguori wrote:
>>
>>> On 06/15/2011 03:13 PM, Prasad Joshi wrote:
>>>> On Wed, Jun 15, 2011 at 6:10 PM, Pekka Enberg<penberg@kernel.org>
>>>> wrote:
>>>>> On Wed, Jun 15, 2011 at 7:30 PM, Avi Kivity<avi@redhat.com> wrote:
>>>>>> On 06/15/2011 06:53 PM, Pekka Enberg wrote:
>>>>>>>
>>>>>>> - Fast QCOW2 image read-write support beating Qemu in fio
>>>>>>> benchmarks. See
>>>>>>> the
>>>>>>> following URL for test result details:
>>>>>>> https://gist.github.com/1026888
>>>>>>
>>>>>> This is surprising. How is qemu invoked?
>>>>>
>>>>> Prasad will have the details. Please note that the above are with Qemu
>>>>> defaults which doesn't use virtio. The results with virtio are little
>>>>> better but still in favor of tools/kvm.
>>>>>
>>>>
>>>> The qcow2 image used for testing was copied on to /dev/shm to avoid
>>>> the disk delays in performance measurement.
>>>>
>>>> QEMU was invoked with following parameters
>>>>
>>>> $ qemu-system-x86_64 -hda<disk image on hard disk> -hdb
>>>> /dev/shm/test.qcow2 -m 1024M
>>>
>>> Looking more closely at native KVM tools, you would need to use the
>>> following invocation to have an apples-to-apples comparison:
>>>
>>> qemu-system-x86_64 -drive
>>> file=/dev/shm/test.qcow2,cache=writeback,if=virtio
>>
>> Wouldn't this still be using threaded AIO mode? I thought KVM tools
>> used native AIO?
>
> Nope. The relevant code is:
>
>> /* blk device ?*/
>> disk = blkdev__probe(filename, &st);
>> if (disk)
>> return disk;
>>
>> fd = open(filename, readonly ? O_RDONLY : O_RDWR);
>> if (fd < 0)
>> return NULL;
>>
>> /* qcow image ?*/
>> disk = qcow_probe(fd, readonly);
>> if (disk)
>> return disk;
>>
>> /* raw image ?*/
>> disk = raw_image__probe(fd, &st, readonly);
>> if (disk)
>> return disk;
>
> It uses a synchronous I/O model similar to qcow2 in QEMU with what I
> assume is a global lock that's outside of the actual implementation.
>
> I think it lacks some of the caching that Kevin's added recently though
> so I assume that if QEMU was run with cache=writeback, it would probably
> do quite a bit better than native KVM tool.
>
> It also turns out that while they have the infrastructure to deal with
> FLUSH, they don't implement it for qcow2 :-/
>
> So even if the guest does an fsync(), it native KVM tool will never
> actually sync the data to disk...
>
> That's probably why it's fast, it doesn't preserve data integrity :(

Actually, I misread the code.  It does unstable writes but it does do 
fsync() on FLUSH.

Regards,

Anthony Liguori
