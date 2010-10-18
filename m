Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab0JRNXD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:23:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61199 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0JRNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:23:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=d2dVn73a771tHl8dVP29VxTC9A0ugSnWDr7j299eLofJOW8PVj7SkxmO75lMujaaD5
         TPyciAJAKR+L90JwdrHYit2B+a1krbhKuF3QAe+i6okwb1Wm/A0GrOPe68js3oq7/3To
         5HyJexFQbbqS8rJof+bj2wqlxjTLoD/J+fEnY=
MIME-Version: 1.0
In-Reply-To: <20101018092650.GC26183@n2100.arm.linux.org.uk>
References: <1287135981-17604-1-git-send-email-akinobu.mita@gmail.com>
	<1287135981-17604-5-git-send-email-akinobu.mita@gmail.com>
	<20101018092650.GC26183@n2100.arm.linux.org.uk>
Date: Mon, 18 Oct 2010 22:22:59 +0900
Message-ID: <AANLkTi=1w9uV81CagrE53xEYkMaFh_3cM_+ybctT2ng4@mail.gmail.com>
Subject: Re: [PATCH 04/22] arm: introduce little endian bitops
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/18 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Fri, Oct 15, 2010 at 06:46:03PM +0900, Akinobu Mita wrote:
>> Introduce little endian bit operations by renaming native ext2 bit
>> operations. The ext2 bit operations are kept by using little endian
>> bit operations until the conversions are finished.
>
> Can you explain why we need another level of indirection rather than
> using asm-generic/bitops/le.h, asm-generic/bitops/minix.h and
> asm-generic/bitops/ext2-non-atomic.h ?

Sorry for not CCing the cover letter of this patch series.

Currently there are no common little-endian bit operations for all
architectures, although some architectures implicitly include
asm-generic/bitops/le.h through asm-generic/bitops/minix-le.h or
asm-generic/bitops/ext2-non-atomic.h.

So some drivers (net/rds/cong.c and virt/kvm/kvm_main.c) need to
include asm/bitops/le.h directly. When I tried to remove the
direct inclusion of asm-generic/bitops/le.h by using ext2_*(),
several people prefer another solution like this patch series does.

This patch series introduces little-endian bit operations for
all architectures and convert all ext2 non-atomic bit operations
and minix bit operations to use little-endian bit operations.
it enables to remove ext2 non-atomic and minix bit operations
from asm/bitops.h. The reason they should be removed from
asm/bitops.h is as follows:

For ext2 non-atomic bit operations, they are used for little-endian
byte order bitmap access by some filesystems and modules.
But using ext2_*() functions on a module other than ext2 filesystem
makes someone feel strange.

For minix bit operations, they are only used by minix filesystem
and useless by other modules. Because byte order of inode and block
bitmap is defferent on each architectures.

There are several issues including arm part. So I'm now fixing them.
