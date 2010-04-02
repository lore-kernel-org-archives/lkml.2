Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab0DBSq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:46:56 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60933 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab0DBSqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R+YhcHWqQzIbjyF4kIMs4kYs4VFafnVVwZ+SPn1YLkZult47Ke5bXxn2vhIg3YUMeT
         11gyFUqtjufmzZZMigC14nZgh1dg16Bl2t7kOyNZnn568T/Mv0CVRUWp/r1q4wu8cyoC
         OkX7277S3TBfC6RjY/UK1675J2L85izFl9UWw=
MIME-Version: 1.0
In-Reply-To: <20100402170159.GA11611@elte.hu>
References: <g2g817ecb6f1003311859k505d752pb6f2a5d7a31e392@mail.gmail.com>
	 <20100402170159.GA11611@elte.hu>
Date: Fri, 2 Apr 2010 14:46:48 -0400
Message-ID: <q2o817ecb6f1004021146r1700f12fxdd6bc66de5ad87bc@mail.gmail.com>
Subject: Re: [PATCH 4/4] [tip:x86/mm] RO/NX protection for loadable kernel 
	modules
From: Siarhei Liakh <sliakh.lkml@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> just wondering, is the boot crash related to the earlier version of this patch
> fixed in this version? If yes, what was the root cause?

The crash was related to "[PATCH 3/4] [tip:x86/mm] NX protection for
kernel data" and is fixed by "[PATCH 1/4] [tip:x86/mm] Correcting
improper large page preservation".
The root cause was improper large page split handling in
try_preserve_large_page(): in some circumstances it would erroneously
preserve large page and apply incompatible page attributes to the
memory area outside of the original "change attribute" request.
The crash we found was triggered as follows:
1. kernel is mapped with 2M pages
2. two consecutive large pages (let's call them A and B) map .rodata and .data.
3. page A covers .rodata only, while page B contains part of .rodata
at the beginning, followed by .data (aligned to 4K)
4. when set_memory_nx() called for .rodata+.data,
try_preserve_large_page() would properly apply RO+NX to page A, but
then pick attributes from the first small page of large page B (RO+NX)
and use static_protections() to see if the attributes can be applied
to the rest of the region.
5. Since static_protections() does not actually protect .data and
.bss, try_preserve_large_page() would conclude that it is OK to set
new access permissions (RO+NX) to whole large page.
6. since page B contains rw-data, which in turn contains spin locks
used to serialize page table modifications, setting whole page as RO
would cause a page fault exception while trying to acquire/release the
lock.
7. the page fault exception handler itself would try to "fix" the page
fault and generate a double-fault by attempting to acquire the lock.
8. the end result is the double fault and kernel crash.

let me know if you have any further questions.
