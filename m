Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab2LMHox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 02:44:53 -0500
Received: from mail.eperm.de ([89.247.134.16]:1710 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab2LMHow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 02:44:52 -0500
X-AuthUser: sm@eperm.de
Message-ID: <50C98764.6050104@chronox.de>
Date: Thu, 13 Dec 2012 08:44:36 +0100
From: Stephan Mueller <smueller@chronox.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Ted Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>,
        Jeff Liu <jeff.liu@oracle.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
References: <50C72800.20508@chronox.de> <20121212164321.a01c5641.akpm@linux-foundation.org>
In-Reply-To: <20121212164321.a01c5641.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2012 01:43:21, +0100, Andrew Morton
<akpm@linux-foundation.org> wrote:

Hi Andrew,
> On Tue, 11 Dec 2012 13:33:04 +0100
> Stephan Mueller <smueller@chronox.de> wrote:
>
>> Some time ago, I noticed the fact that for every newly
>> executed process, the function create_elf_tables requests 16 bytes of
>> randomness from get_random_bytes. This is easily visible when calling
>>
>> while [ 1 ]
>> do
>> 	cat /proc/sys/kernel/random/entropy_avail
>> 	sleep 1
>> done
> Please see
> http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
>
> That patch is about one week from a mainline merge, btw.

Initially I was also thinking about get_random_int. But stack protection
depends on non-predictable numbers to ensure it cannot be defeated. As
get_random_int depends on MD5 which is assumed to be broken now, I
discarded the idea of using get_random_int.

Moreover, please consider that get_cycles is an architecture-specific
function that on some architectures only returns 0 (For all
architectures where this is implemented, you have no guarantee that it
increments as a high-resolution timer). So, the quality of
get_random_int is questionable IMHO for the use as a stack protector.

Also note, that other in-kernel users of get_random_bytes may be
converted to using the proposed kernel pool to avoid more entropy drainage.

Please note that the suggested approach of fully seeding a deterministic
RNG never followed by a re-seeding is used elsewhere (e.g. the OpenSSL
RNG). Therefore, I think the suggested approach is viable.

Ciao
Stephan

