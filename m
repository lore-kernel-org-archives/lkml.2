Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab2BPUZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 15:25:55 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38380 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab2BPUZw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 15:25:52 -0500
MIME-Version: 1.0
In-Reply-To: <4F3D61CB.2000301@zytor.com>
References: <1329422549-16407-1-git-send-email-wad@chromium.org>
	<1329422549-16407-3-git-send-email-wad@chromium.org>
	<4F3D61CB.2000301@zytor.com>
Date: Thu, 16 Feb 2012 14:25:49 -0600
Message-ID: <CABqD9hb3WxKxLZ2GuUrbDM--koW+a3ser5TU8y6+e0sAhOT9dw@mail.gmail.com>
Subject: Re: [PATCH v8 3/8] seccomp: add system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        indan@nul.nu, pmoore@redhat.com, akpm@linux-foundation.org,
        corbet@lwn.net, eric.dumazet@gmail.com, markus@chromium.org,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 2:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 02/16/2012 12:02 PM, Will Drewry wrote:
>> +
>> +/* Format of the data the BPF program executes over. */
>> +struct seccomp_data {
>> +     int nr;
>> +     __u32 __reserved[3];
>> +     struct {
>> +             __u32   lo;
>> +             __u32   hi;
>> +     } instruction_pointer;
>> +     __u32 lo32[6];
>> +     __u32 hi32[6];
>> +};
>>
>
> This seems more than a bit odd, no?
>
>        -hpa

I agree :)  BPF being a 32-bit creature introduced some edge cases.  I
has started with a
    union { u32 args32[6]; u64 args64[6]; }

This was somewhat derailed by CONFIG_COMPAT behavior where
syscall_get_arguments always writes to argument of register width --
not bad, just irritating (since a copy isn't strictly necessary nor
actually done in the patch).  Also, Indan pointed out that while BPF
programs expect constants in the machine-local endian layout, any
consumers would need to change how they accessed the arguments across
big/little endian machines since a load of the low-order bits would
vary.

In a second pass, I attempted to resolve this like aio_abi.h:
   union {
     struct {
        u32 ENDIAN_SWAP(lo32, hi32);
      };
      u64 arg64;
    } args[6];
It wasn't clear that this actually made matters better (though it did
mean syscall_get_arguments() could write directly to arg64).  Using
offsetof() in the user program would be fine, but any offsets set
another way would be invalid.  At that point, I moved to Indan's
proposal to stabilize low order and high order offsets -- what is in
the patch series.  Now a BPF program can reliably index into the low
bits of an argument and into the high bits without endianness changing
the filter program structure.

I don't feel strongly about any given data layout, and this one seems
to balance the 32-bit-ness of BPF and the impact that has on
endianness.  I'm happy to hear alternatives that might be more
aesthetically pleasing :)

cheers!
will
