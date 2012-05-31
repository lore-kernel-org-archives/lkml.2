Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019Ab2EaRx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 13:53:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54370 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab2EaRx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 13:53:27 -0400
MIME-Version: 1.0
In-Reply-To: <20120516160236.GI22985@linux.intel.com>
References: <20120515133450.GD22985@linux.intel.com> <4FB2E069.7060703@amacapital.net>
 <20120516160236.GI22985@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 31 May 2012 10:53:06 -0700
Message-ID: <CALCETrUmajOtdSKNqQgfJtbMRe9GZBM52vBZ9rHW=swbcbzAaQ@mail.gmail.com>
Subject: Re: NVM Mapping API
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 9:02 AM, Matthew Wilcox <willy@linux.intel.com> wrote:
> On Tue, May 15, 2012 at 04:02:01PM -0700, Andy Lutomirski wrote:
>> I would love to use this from userspace.  If I could carve out a little
>> piece of NVM as a file (or whatever) and mmap it, I could do all kinds
>> of fun things with that.  It would be nice if it had well-defined, or at
>> least configurable or discoverable, caching properties (e.g. WB, WT, WC,
>> UC, etc.).
>
> Yes, usage from userspace is definitely planned; again through a
> filesystem interface.  Treating it like a regular file will work as
> expected; the question is how to expose the interesting properties
> (eg is there a lighter weight mechanism than calling msync()).

clfush?  vdso system call?

If there's a proliferation of different technologies like this, we
could have an opaque struct nvm_mapping and a vdso call like

void __vdso_nvm_flush_writes(struct nvm_mapping *mapping, void
*address, size_t len);

that would read the struct nvm_mapping to figure out whether it should
do a clflush, sfence, mfence, posting read, or whatever else the
particular device needs.  (This would also give a much better chance
of portability to architectures other than x86.)

>
> My hope was that by having a discussion of how to use this stuff within
> the kernel, we might come up with some usage models that would inform
> how we design a user space library.
>
>> (Even better would be a way to make a clone of an fd that only allows
>> mmap, but that's a mostly unrelated issue.)
>
> O_MMAP_ONLY?  And I'm not sure why you'd want to forbid reads and writes.

I don't want to forbid reads and writes; I want to forbid ftruncate.
That way I don't need to worry about malicious / obnoxious programs
sharing the fd causing SIGBUS.

--Andy
