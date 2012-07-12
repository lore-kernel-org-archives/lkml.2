Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934109Ab2GLQts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:49:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:62152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab2GLQtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:49:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120712163026.GG2430@ram-ThinkPad-T61>
References: <1341057657-7823-1-git-send-email-octavian.purdila@intel.com>
	<20120710143348.d977da44.akpm@linux-foundation.org>
	<20120711020902.GC13885@ram-ThinkPad-T61>
	<CAE1zotK=2nK_pRsg8C6MuGqOKZut96MgWy-ru2dkPOQQF--U3Q@mail.gmail.com>
	<20120711145412.GA2430@ram-ThinkPad-T61>
	<CAE1zotJuDn+oLcUVZ0HWeAck+UD0DiveOrOO=iYz6btdOQyD6Q@mail.gmail.com>
	<20120712020206.GC2430@ram-ThinkPad-T61>
	<20120712085631.GD2430@ram-ThinkPad-T61>
	<CAE1zot+iKwg5uijy7mWbxrQ3KUFYoKXuSYc0OnADmrWu7EtgLw@mail.gmail.com>
	<20120712163026.GG2430@ram-ThinkPad-T61>
Date: Thu, 12 Jul 2012 19:49:43 +0300
Message-ID: <CAE1zotJWEHMBVz2dGnZhMojOn2HLV3qoVWjL_J61a79Kt=Xpxw@mail.gmail.com>
Subject: Re: [PATCH] resource: make sure requested range intersects root range
From: "Purdila, Octavian" <octavian.purdila@intel.com>
To: Ram Pai <linuxram@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding back people on CC, I accidentally reply-to instead of reply-to-all.

On Thu, Jul 12, 2012 at 7:30 PM, Ram Pai <linuxram@us.ibm.com> wrote:
> On Thu, Jul 12, 2012 at 12:56:08PM +0300, Purdila, Octavian wrote:
>> On Thu, Jul 12, 2012 at 11:56 AM, Ram Pai <linuxram@us.ibm.com> wrote:
>
> ..snip..
>> > Offcourse; it does not warn when the request is partially out of root's range.
>> > But that should be ok, because its still a valid request.
>>
>> Since in 99% of cases requests should be completely inside the root
>> range (in fact no bug has been reported until now on this pretty old
>> piece of code) I think being verbose here is a good thing.
>>
>> This sorts of problems occur only in exotic setups (in my case it was
>> Xen on a machine with PAE enabled but 32bit address space) and
>> silently adjusting the request will make logical bugs in the upper
>> layers very hard to detect.
>>
>> That being said, I'll leave it to you and Andrew decide which version
>> (verbose or non-verbose) is better.
>>
>> This is the last verbose version which fixes a few issues from last
>> post as well as makes a few cosmetic changes:
>
> this version is correct. I am ok with it. Probably with one minor
> simplication as below.
>>
>> ---
>>  kernel/resource.c |   25 ++++++++++++++++++++++++-
>>  1 file changed, 24 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/resource.c b/kernel/resource.c
>> index e1d2b8e..c0e0fa2 100644
>> --- a/kernel/resource.c
>> +++ b/kernel/resource.c
>> @@ -7,6 +7,8 @@
>>   * Arbitrary resource management.
>>   */
>>
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +
>>  #include <linux/export.h>
>>  #include <linux/errno.h>
>>  #include <linux/ioport.h>
>
> these above lines must have crept in by mistake? :)
>

No, this is intentional. Since we now use pr_err I think it useful to
have the messages formatted like:

<3>resource: requested range [0x%llx-0x%llx] not in root %pr


>> @@ -788,8 +790,29 @@ void __init reserve_region_with_split(struct
>> resource *root,
>>               resource_size_t start, resource_size_t end,
>>               const char *name)
>>  {
>> +     int abort = 0;
>> +
>>       write_lock(&resource_lock);
>> -     __reserve_region_with_split(root, start, end, name);
>> +     if (!(root->start <= start && root->end >= end)) {
>
> This can be simplified to
>         if (root->start > start || root->end < end) {
>

Sure, I will do that. Thanks for reviewing, I will follow up with a v2
patch to Andrew.
