Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab0FDXAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 19:00:44 -0400
Received: from mail-yw0-f187.google.com ([209.85.211.187]:48824 "EHLO
	mail-yw0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab0FDXAk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 19:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JZT345tJp0YicNCZSA1eiSoxExEhs7Udu7kpOSKrWx/lnorMxL8C3mPePVwAJMk9ie
         cHNxzyBZgiuNgGia/XsVyExZMoKHQlUU9n+AaVj3WVQuA7DEjnoFs9AgmvUYxxkUnvNE
         u/22huW3kL2/5sjyKgQhdUm91sxnDU994zadw=
MIME-Version: 1.0
In-Reply-To: <20100604134853.b6ca10f9.akpm@linux-foundation.org>
References: <20100601185937.5188.77506.stgit@warthog.procyon.org.uk> 
	<20100604134853.b6ca10f9.akpm@linux-foundation.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 4 Jun 2010 19:00:19 -0400
Message-ID: <AANLkTilAeLC6SZVPpy4upQsyoeN0SpqbJ3lwrYPU00I5@mail.gmail.com>
Subject: Re: [Uclinux-dist-devel] [PATCH] NOMMU: Add '[stack]' label to 
	/proc/pid/maps output
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 4, 2010 at 16:48, Andrew Morton wrote:
> On Tue, 01 Jun 2010 19:59:37 +0100 David Howells wrote:
>> From: Mike Frysinger <vapier@gentoo.org>
>>
>> Add support to the NOMMU /proc/pid/maps file to show which mapping is the stack
>> of the original thread after execve.  This is largely based on the MMU code.
>> Subsidiary thread stacks are not indicated.
>>
>> For FDPIC, we now get:
>>
>>       root:/> cat /proc/self/maps
>>       02064000-02067ccc rw-p 0004d000 00:01 22         /bin/busybox
>>       0206e000-0206f35c rw-p 00006000 00:01 295        /lib/ld-uClibc.so.0
>>       025f0000-025f6f0c r-xs 00000000 00:01 295        /lib/ld-uClibc.so.0
>>       02680000-026ba6b0 r-xs 00000000 00:01 297        /lib/libc.so.0
>>       02700000-0274d384 r-xs 00000000 00:01 22         /bin/busybox
>>       02816000-02817000 rw-p 00000000 00:00 0
>>       02848000-0284c0d8 rw-p 00000000 00:00 0
>>       02860000-02880000 rw-p 00000000 00:00 0          [stack]
>>
>> The semi-downside here is that for FLAT, we get:
>>
>>       root:/> cat /proc/155/maps
>>       029f0000-029f9000 rwxp 00000000 00:00 0          [stack]
>>
>> The reason being that FLAT combines a whole lot of stuff into one map
>> (including the stack).  But this isn't any worse than the current output (which
>> is nothing), so screw it.
>
> So it's a non-back-compatible change which can a) break nommu-only
> userspace and b) unbreak mmu-tested userspace which gets run on nommu.

i dont see how it breaks anything really.  any code that parses the
maps file has to account for an optional label in the maps output.

i guess if someone wrote some code that does something special with
"[stack]", then behavior would change with FLAT files, but that's
pretty unlikely i would think.  plus, FLAT is not ELF and as such, its
layout in memory is highly unlike any existing ELF layout.  so someone
would already have to be writing a custom handler for FLAT files which
means they account for the "one blob is everything" layout.
-mike
