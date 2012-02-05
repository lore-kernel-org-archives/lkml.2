Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2BERMm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 12:12:42 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37992 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab2BERMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 12:12:41 -0500
Message-ID: <4F2EB8C8.9090102@gmail.com>
Date: Sun, 05 Feb 2012 18:13:44 +0100
From: Chase Douglas <chasedouglas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Input: Add EVIOC mechanism for MT slots
References: <1328036403-2827-1-git-send-email-rydberg@euromail.se> <4F2B24AC.1020408@gmail.com> <20120203072725.GA6914@polaris.bitmath.org> <4F2D7730.3090704@gmail.com> <20120205075906.GA7698@polaris.bitmath.org>
In-Reply-To: <20120205075906.GA7698@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 08:59 AM, Henrik Rydberg wrote:
>>> This is resolved on the preprocessor level, so C99 or not does not
>>> enter the problem. Compile-time constant, as you can see in the code
>>> example in the patch summary.
>>
>> You're right, I didn't catch that. It will be compatible with all C
>> compilers if you use a static number of slots.
> 
> Yes, but this statement is merely repeating something that has been
> true since the sixties.
> 
>> However, it will break if you use a non-C99 C compiler and the code
>> wants to do dynamic number of slots calculations.
> 
> Of course, which is why C99 cannot be used for portable code. And it
> still has nothing to do with this patch.
> 
>> I imagine most callers would do:
>>
>> EVIOCGABS call on ABS_MT_SLOT;
>> int num_slots = ABS_MT_SLOT.max - ABS_MT_SLOT.min
>> struct INPUT_MT_REQUEST(num_slots) req;
> 
> Besides leaving a possible giant stack crash in your code, it assumes
> memory is somehow magically allocated. Not good practise in low-level
> programming. You wouldn't use a template this way, would you?

No, which is why I think this interface is bad. I should be able to
dynamically set the size of the array, but it's not possible with this
interface.

>> This will break on non-C99 C compilers and other language compilers.
> 
> Of course, since you use the C99 dynamic stack construct, which,
> again, is not portable.
> 
>> It also will lead to head-scratcher bugs when someone compiles it
>> just fine in their C99 project, copies the code to another project
>> with a different compiler, and is confronted with the issue.
> 
> No, since people how know C do not do things like that.
> 
>> I think this issue should be enough to rethink the interface.
> 
> No, since your issues with C99 has nothing to do with this patch.

With this macro, one is forced to pick a number at compile time. If that
number isn't big enough you have no recourse. If you pick too big of a
number you are wasting stack space.

I think the implementation is fine in terms of how the plumbing works. I
just don't think this macro should be included. Make the user create the
struct themselves:

In linux/input.h:

struct input_mt_request {
	__u32 code;
	__s32 values[];
};

In code:

int num_slots;
int size;
struct input_mt_request *req;

EVIOCGABS call on ABS_MT_SLOT;

num_slots = ABS_MT_SLOT.max - ABS_MT_SLOT.min
size = sizeof(struct input_mt_request) + num_slots * sizeof(__s32);
req = malloc(size);
req->code = ABS_MT_POSITION_X;
if (ioctl(fd, EVIOCGMTSLOTS(size), req) < 0) {
	free(req);
	return -1;
}
for (i = 0; i < num_slots; i++)
	printf("slot %d: %d\n", i, req->values[i]);
free(req);

(I'm still not clear on how the values[] member of the request can work,
so this may not be quite right. I tried to copy the way the first
version of this patch worked. However, the dynamic request size is the
important part.)

It could be argued that we should leave the macro around for people who
want to statically define the size of the request, but I think that is
leading them down the wrong path. It's easier, but it will lead to
broken code if you pick the wrong size.

-- Chase
