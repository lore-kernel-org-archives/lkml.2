Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1G0PFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:05:08 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38815 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1G0PFE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:05:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110727145745.GA11872@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu> <20110727145745.GA11872@dumpdata.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Wed, 27 Jul 2011 11:04:44 -0400
X-Google-Sender-Auth: uIbRXxZo2Dh6igxDJojruczn0TA
Message-ID: <CAObL_7FT8QLg-wihasBahhAtS=pA7+KeU8E=E9x8NPZ0+QJ5iQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Collected vdso/vsyscall fixes for 3.1
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 10:57 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Tue, Jul 26, 2011 at 11:20:34PM -0400, Andy Lutomirski wrote:
>> This fixes various problems that cropped up with the vdso patches.
>>
>>  - Patch 1 fixes an information leak to userspace.
>>  - Patches 2 and 3 fix the kernel build on gold.
>>  - Patches 4 and 5 fix Xen (I hope).
>>
>> Konrad, could you could test these on Xen and run 'test_vsyscall test' [1]?
>
> They boot 64-bit guest succesfully.
>
> But I doesn't compile under 32-bit:
>
> home/konrad/ssd/linux/arch/x86/xen/enlighten.c:953: error: unknown field ‘extra_user_64bit_cs’ specified in initializer
> /home/konrad/ssd/linux/arch/x86/xen/enlighten.c:953: error: ‘FLAT_USER_CS64’ undeclared here (not in a function)
>
> Looks like it needs some #ifdef CONFIG_X86_64 magic.. and after
> applying that magic dust it compiles and it also boots as 32-bit
> (no surprise there).

Whoops!  I thought xen/enlighten.c was 64-bit only.

>
>> I don't have a usable Xen setup.
>
> It is pretty easy to setup. Google for PVops Wiki and you will find wealth
> of information. FYI: I am gone next week so won't be able to test these
> patches.
>
>>
>> Also, I'd appreciate a review of patches 4 and 5 from some Xen/paravirt
>> people.
>>
>> [1] https://gitorious.org/linux-test-utils/linux-clock-tests
>
> Grrrrr..
>
> g++ -o test_vsyscall -std=gnu++0x -lrt -ldl -O2 -Wall -mavx -g test_vsyscall.cc
> test_vsyscall.cc: In function ‘int bench(int, char**)’:
> test_vsyscall.cc:205: error: expected primary-expression before ‘[’ token

[...]

>
> Is there a specific version of GCC I should be using? I seem to be
> using: g++ (GCC) 4.4.4 20100503 (Red Hat 4.4.4-2)

Apparently it needs g++ 4.5 for lambdas.

>
> Anyhow, removed the benchmark code and ran it on 64-bit:
>
> sh-4.1# /test_vsyscall  test
> Testing gettimeofday...
> [  109.552261] test_vsyscall[2462] trap invalid opcode ip:400c8d sp:7fff84fab470 error:0 in test_vsyscall[400000+2000]
> Illegal instruction
> sh-4.1# /test_vsyscall  intcc
> About to execute int 0xcc from RIP = 400959
> [  114.137150] test_vsyscall[2463] illegal int 0xcc (exploit attempt?) ip:400959 cs:e033 sp:7fff8b328310 ax:2c si:0 di:7fff8b3280f0
> Caught SIGSEGV: Segmentation fault (Signal sent by the kernel [(nil)])RIP = 400959
>
> [This is on git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git #testing, which
> has todays linus/master and your patchset]
>

I'll set up Xen.  Something's clearly still buggy.

--Andy
