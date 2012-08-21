Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2HUSrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 14:47:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56227 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab2HUSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 14:47:03 -0400
MIME-Version: 1.0
In-Reply-To: <5033CE8A.5090705@wwwdotorg.org>
References: <502EC16C.4030007@wwwdotorg.org>
	<20120820182254.GQ24861@google.com>
	<50328258.9030800@wwwdotorg.org>
	<CABqD9hY-Z9uBcYyeCa=8f8eeXkGNjPKxbwpMPi3vs3776vF6iQ@mail.gmail.com>
	<5033CE8A.5090705@wwwdotorg.org>
Date: Tue, 21 Aug 2012 13:47:02 -0500
Message-ID: <CABqD9hZ=2M5Xf5AsbinAEB35mEwdbd7uOz852QCs_2sf_OUZvw@mail.gmail.com>
Subject: Re: root=PARTUUID for MBR/NT disk signatures?
From: Will Drewry <wad@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Kay Sievers <kay.sievers@vrfy.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 1:08 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/20/2012 10:47 PM, Will Drewry wrote:
>> On Mon, Aug 20, 2012 at 1:30 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>>> On 08/20/2012 12:22 PM, Tejun Heo wrote:
>>>> Hello,
>>>>
>>>> On Fri, Aug 17, 2012 at 04:10:52PM -0600, Stephen Warren wrote:
>>>>> I was considering extending the kernel command-line option
>>>>> root=PARTUUID= to also support MBR (NT disk signatures). I was thinking
>>>>> of a syntax along the lines of:
>>>>>
>>>>> root=PARTUUID=UUUUUUUU-PP[/PARTNROFF=%d]
>>>>>
>>>>> ... where UUUUUUUU is the hex representation of the NT disk signature,
>>>>> and PP is the hex representation of the partition number. Like GPT,
>>>>> /PARTNROFF could be used too if desired.
>>>>>
>>>>> Related, I was thinking of changing struct partition_meta_info's uuid
>>>>> field to be a string, so that it could simply be strcmp'd against the
>>>>> UUID value on the kernel command-line. That way, the type of the UUID is
>>>>> irrelevant.
>>>>>
>>>>> Does anyone have any objection to that?
>>>>
>>>> Wouldn't that be able to break setups which work currently?
>>>
>>> I don't believe so:
>>>
>>> Since the newly supported UUID syntax wouldn't ever match any EFI UUID
>>> (the lengths differ in all cases), I don't believe the new syntax would
>>> affect behavior for any existing usage.
>>>
>>> Obviously, part_efi.c would be modified to initialize struct
>>> partition_meta_info's uuid field to the appropriate string
>>> representation of the UUID so that the str(case)cmp would still succeed
>>> for existing command-lines. I ended up coding up that part of the change
>>> late Friday, and the feature was certainly still working OK.
>>
>> Functionally, I suspect this will work fine, but I am concerned that
>> it is a bad move from an efficiency perspective (not unfixable
>> though).  Right now, the user-supplied value is converted from
>> string-uuid to packed-uuid.  This is then memcmp'd across any and all
>> partitions - be it 2 or 200 - across all attached storage.  If we move
>> to a pure string, then we end up needing to unpack every packed UUID
>> at disk scan time (or search, depending on impl) rather than just the
>> one user supplied value.
>
> The EFI partition code actually does the following already:
>
> 1) Unpack the UUID from the binary on-disk representation to a temporary
> string.
> 2) Repack the temporary string into the internal UUID buffer.
>
> The comments imply this is in order to do endian conversions.
>
> Switching the internal representation to a string avoids step (2) above,
> plus avoids having to pack the string on the kernel command-line into a
> binary UUID before the comparison. I doubt the difference between memcmp
> vs. strcasecmp is worth considering. So, I think it's overall a win.

Sounds reasonable to me then.

Thanks!
will
