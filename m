Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1GaBCx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 21:02:53 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52462 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab1GaBCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 21:02:49 -0400
MIME-Version: 1.0
In-Reply-To: <20110730234630.7270.qmail@science.horizon.com>
References: <20110730234630.7270.qmail@science.horizon.com>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sat, 30 Jul 2011 21:02:07 -0400
Message-ID: <CAF_S4t8TFour-Yw1T+qdG9mCzy9+tGBR0hQG83+ra6PRzPhNHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] random: Add support for architectural random hooks
To: George Spelvin <linux@horizon.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        mpm@selenic.com, tytso@mit.edu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 19:46, George Spelvin <linux@horizon.com> wrote:
>> The fact is, even if you worry about some back door for the NSA, or
>> some theoretical lack of perfect 32-bit randomness, we can pretty much
>> depend on it. We still do our own hashing on top of whatever entropy
>> we get out of rdrand, and we would still have all our other stuff.
>> Plus the instruction is public and testable - if Intel did something
>> wrong, they'll be *very* embarrassed.
>>
>> In other words, there's absolutely no reason not to use it, and allow
>> us to get away from /dev/random running out of entropy. We absolutely
>> should use it for bootup randomness (where we currently are somewhat
>> weak), and I absolutely disagree that it should be made into more of a
>> driver abstraction.
>
> I agree with your second paragraph, but disagree violently with your
> first: Intel provide no way to test their RNG, and the AES-based whitener
> makes it completely private and UNtestable.
[snip paranoia]

That's fine, but it's also not for the kernel to judge. Certainly
there should be an option to allow the user to disable the use of
RDRAND, if they're so inclined. But those who trust Intel's HWRNG
should be able to use it as efficiently as possible.

That said, I'm not sure I like Linus's proposed API. As I understand
it, he proposes something like:

int arch_get_random_word(unsigned long *pRandom);

Where arch_get_random_word returns 0 if not supported.

If we have that interface, then the urandom code implementing it might
look something _vaguely_ like this (ignoring the possibility of nbytes
% sizeof(unsigned long) != 0):

void __user *bufend = buf + nbytes;
while (buf < bufend) {
  unsigned long tmp;
  if (arch_get_random_word(&tmp)) {
    if (copy_to_user(buf, &tmp, sizeof(tmp))) {
      ret = -EFAULT;
      break;
    }
  } else {
    return urandom_fallback(buf, bufend-buf);
  }
  buf += sizeof(tmp);
}

The problem, as you can see here, is we need to test for the existence
of an architecture-specific HWRNG once for _every word processed_. And
since we don't know the return value of arch_get_random_word until we
probe the CPU's capability set at runtime, this isn't going to be
eliminated statically.

The alternative is to simply have a single hook-based API, passing in
a buffer and length, as in the HWRNG API, as well as this patch
series. You can then test whether there is a hook once, and then go
straight into a tight loop to generate your random data. This does add
a _tiny_ amount of overhead to the case where the user wants a single
word of random data, due to the indirect function call. However, in
that case the overhead is nothing compared to the system call entry
overhead. For larger buffers, the savings from avoiding a branch every
loop is likely to be far larger than your function pointer invocation.

Now, of course, you could do something like this:

if (arch_has_get_random_word) {
  while (buf < bufend) {
    unsigned long tmp = arch_get_random_word();
    copy_to_user(buf, &tmp, sizeof(tmp));
    buf += sizeof(tmp);
  }
}

I think it should be obvious that this a pretty terrible API, but as
far as I can see if you're steadfast on avoiding the overhead of a
hook then it's the best you can do.

In short, I have to agree with George Spelvin's suggestion of using
the hwrng API - just add a hook to allow urandom to be directed to a
hwrng device, and appropriate initialization code to do this at
startup if RDRAND is available. Heck, you might not even have to do
that - just configure udev to point /dev/urandom at the hwrng device
node, and now the kernel doesn't have to make any policy decisions on
what RNG to use at all.
