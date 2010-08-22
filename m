Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983Ab0HVHwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 03:52:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36970 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab0HVHwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 03:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FatuQqPX4vZWszA+w8x5EQ+tVyfrspDVWqxfotKUR/cpHL8gNPlcw1IIvIjj8hOPwj
         1IogEAHktwHkLJykNHFYfzhFoB9uCQOfyVXj8RTuC1fbehMAKHaV2lDr+B9HVPE+BR7d
         oa82SkhdFB4biA/HQcI330zRgMQi3HlfWHGbo=
Message-ID: <4C70D72E.2040605@gmail.com>
Date: Sun, 22 Aug 2010 09:52:14 +0200
From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] RFC, v2: "New" /dev/crypto user-space interface
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <201008211908.03705.arnd@arndb.de>
In-Reply-To: <201008211908.03705.arnd@arndb.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2010 07:08 PM, Arnd Bergmann wrote:
> On Friday 20 August 2010 10:45:43 Miloslav Trmač wrote:
>>
>> Major changes since the previous post:
>> * "struct nlattr"-based extensible attributes used for extensibility
>>   of most operations, both for input and output attributes
> The API here looks overly complex resulting from the use of a combination
> of ioctl and netlink. If your interface cannot be easily expressed using
> simple (no indirect pointers or variable-length fields please) ioctl
> and read/write operations, why not go all the way and turn the interface
> into a netlink facility?

I believe that this is the result of the discussion in the version 1 of
the proposal. The original API was specified with ioctls only.

>> * Full compat_ioctl implementation
> New drivers should be written to *avoid* compat_ioctl calls, using only
> very simple fixed-length data structures as ioctl commands.

There are cases where this cannot be easily done, when say pointers are
involved. IMHO forcing pointers to be u64 or u32 is dirtier than using
the compat interface.

>> * Version number added to the data format used when wrapping keys for storage
> Again, wrong direction. If you think you need a version number, the interface
> is probably not ready for inclusion yet. Make sure it is simple enough that
> you don't run into the case where you have to make incompatible changes
> that require API versioning.

Note that the version number is not to the interface but to data that
are intended for storage. It is desirable to have such a version there.

>>   The libtom* patches will probably still be too large for the mailing list;
>>   the whole patch set is also available at
>>   http://people.redhat.com/mitr/cryptodev-ncr/v2/ .
> They actually seem to have made it to the list. However, the more signficant
> problem is the amount of code added to a security module. 20000 lines of
> code that is essentially a user-level library moved into kernel space
> can open up so many possible holes that you end up with a less secure
> (and slower) setup in the end than just doing everything in user space.

The same argument could apply to an other algorithm in the kernel such
as deflate, lzma, AES etc. There are cases that the benefits outweigh
the risks of adding them. I believe this is such a case.

>> These are the major differences compared to the BSD-like interface:
>> * The API supports key storage and management inside the kernel.
>>   An application can thus ask the kernel to generate a key; the key is
>>   then referenced via an integer identifier, and the application can be
>>   prevented from accessing the raw key data.  Such a key can, if so configured,
>>   still be wrapped for key transport to the recipient of the message, and
>>   unwrapped by the recipient.
> As Kyle mentioned, we already have a key management API in the kernel.
> I think you should make a better effort of interfacing with that and
> adding features you need to it, like a way to prevent the kernel from
> handing out keys as you mentioned in your reply.

Note that the NCR does not do key management. Integrating with the key
management API could be nice, but it is not something critical and is
not duplicating code or efforts in any way.

>>   An user-space library is not separated, options are a) root
>>   running daemon that does crypto, but this would be slow due to context
>>   switches, scheduler mismatching and all the IPC overhead and b) use crypto
>>   that is in the kernel.
> I think you will have to back that statement by measurements. There are
> reasonably fast ways to do IPC and the interface you suggest to put in the
> kernel does not exactly look tuned for performance.

This is an alternative design. There quite some reasons against that,
such as the auditing features. For me the main reason was  that there
was no way to make it as fast (zero-copy) as this design, for the
requirements we had (interface with existing crypto libraries through
pkcs11). Zero-copy is important since crypto operations might involve
large chunks of data.

>> * FIPS-140-3 calls out for cryptographic functions to be non-debuggable (ptrace)
>>   meaning that you cannot get to the key material. The solution is the same as
>>   above.
> 
> We have kgdb, kdb, qemu gdbserver, tracing and more things that would very
> much make your code debuggable.
> OTOH, disabling ptrace with a root-only prctl should be an easy thing to
> implement if there is a use case for it.

You are right. Debugging by the administrator was not an issue. Only
users should be prevented from that. It should have been mentioned.


regards,
Nikos
