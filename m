Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2BRRGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 12:06:07 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62798 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2BRRFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 12:05:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of david.s.daney@gmail.com designates 10.68.195.73 as permitted sender) smtp.mail=david.s.daney@gmail.com; dkim=pass header.i=david.s.daney@gmail.com
Message-ID: <4F3FDA70.9060304@gmail.com>
Date: Sat, 18 Feb 2012 09:05:52 -0800
From: David Daney <david.s.daney@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Alan Cooper <alcooperx@gmail.com>
CC: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: Stack unwind across signal frame
References: <CAOGqxeWjtr=SOY83ZFEdwJXXatqLLEN6SHre9-0DfeJfcyBhKQ@mail.gmail.com>
In-Reply-To: <CAOGqxeWjtr=SOY83ZFEdwJXXatqLLEN6SHre9-0DfeJfcyBhKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2012 01:13 PM, Alan Cooper wrote:
> I'm seeing a problem on both 2.6.37 and 3.3 MIPS kernels where I can't
> unwind through a MIPS signal frame.
You don't tell us the version of the unwinder (likely from libgcc) you 
are using.  There was a lot of work in this area four or five years ago, 
I didn't take the time to do the required archaeology to determine the 
exact patch, but likely you are missing this.

>   It looks like this is caused by
> the VDSO code that was added 2/2010.
Some CPUs have errata necessitating a different signal frame layout, on 
these CPUs, you wouldn't be able to unwind either, even pre mips-vdso.

>   When the unwinder tries to find
> the frame info for the caller of the signal handler (the trampoline in
> VDSO), it can't find the eh_frame info because the address is in the
> VDSO area and stops unwinding. It looks like other platforms solve
> this by adding the eh_frame info for the VDSO area so the lookup
> works.

That's right.  However all 'modern' GCCs and GDBs can unwind through 
signal frames on all 2.4.x and later kernels.  I would recommend 
upgrading your GCC to 4.6.2, and see if you obtain better results.

> This problem ends up breaking pthread cleanup for C++ programs because
> the cleanup is done using a class with the expectation that the
> destructor will be called when the thread gets canceled by a cancel
> signal. This seems like a big problem for all current MIPS kernels so
> I was wondering if I'm missing something?

A modern libgcc I think.

>
> If this is correct, then it seems like the best solution would be to
> add the VDSO eh_frame info to MIPS.

Having a correct eh_frame in the vdso, would be nice, but is not the 
highest priority for me.


David Daney

