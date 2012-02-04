Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2BDSUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 13:20:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36934 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab2BDSUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 13:20:36 -0500
Message-ID: <4F2D7730.3090704@gmail.com>
Date: Sat, 04 Feb 2012 19:21:36 +0100
From: Chase Douglas <chasedouglas@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Input: Add EVIOC mechanism for MT slots
References: <1328036403-2827-1-git-send-email-rydberg@euromail.se> <4F2B24AC.1020408@gmail.com> <20120203072725.GA6914@polaris.bitmath.org>
In-Reply-To: <20120203072725.GA6914@polaris.bitmath.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 08:27 AM, Henrik Rydberg wrote:
> Hi Chase,
> 
>>> +#define INPUT_MT_REQUEST(num_slots)					\
>>> +	{								\
>>> +		__u32 code;						\
>>> +		__s32 values[num_slots];				\
>>
>> I think this assumes a userspace C compiler that can handle variable
>> length arrays. This would require only compiling in C source code at the
>> C99 standard or later. It looks like C++ doesn't even allow variable
>> length arrays, though gcc handles it. According to:
>>
>> http://www.cplusplus.com/forum/beginner/1601/
>>
>> it looks like Borland c++ compilers may not be able to compile this :(.
> 
> This is resolved on the preprocessor level, so C99 or not does not
> enter the problem. Compile-time constant, as you can see in the code
> example in the patch summary.

You're right, I didn't catch that. It will be compatible with all C
compilers if you use a static number of slots.

However, it will break if you use a non-C99 C compiler and the code
wants to do dynamic number of slots calculations. I imagine most callers
would do:

EVIOCGABS call on ABS_MT_SLOT;
int num_slots = ABS_MT_SLOT.max - ABS_MT_SLOT.min
struct INPUT_MT_REQUEST(num_slots) req;

This will break on non-C99 C compilers and other language compilers. It
also will lead to head-scratcher bugs when someone compiles it just fine
in their C99 project, copies the code to another project with a
different compiler, and is confronted with the issue.

I think this issue should be enough to rethink the interface.

-- Chase
