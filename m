Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1AIAQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 19:16:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:51926 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1AIAQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 19:16:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] kbuild: generic support for asm-generic
Date: Sun, 9 Jan 2011 01:15:58 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-kbuild" <linux-kbuild@vger.kernel.org>,
        linux arch <linux-arch@vger.kernel.org>,
        Guan Xuetao <guanxuetao@mprc.pku.edu.cn>,
        Michal Marek <mmarek@suse.cz>
References: <20110108130302.GA21698@merkur.ravnborg.org> <201101082153.31837.arnd@arndb.de> <20110108213353.GA24666@merkur.ravnborg.org>
In-Reply-To: <20110108213353.GA24666@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101090115.59234.arnd@arndb.de>
X-Provags-ID: V02:K0:KlSR/xCkVihsCuxZFqJHeRqNvFA0Qg2lfYxdqnaEipm
 zQ3L2tlzgxKeoZZ87ScAtuEPvq16zcC6f/KxrqQqBTbxrXC24T
 QJAtIgSpFOiRmtG4bgeexCFCLIBPfUrscPHOE5mth2aXwvoLSf
 uyaF0OAE7bvOsowxUBjxJan9abIlYA31h6ZjH1jyF/PwYXTyq2
 Ndkuz3mJZ/K5zbOsHcPpg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 08 January 2011, Sam Ravnborg wrote:
> We need a variables to express:
> In include/asm-generic/Kbuild.asm
> - This file exists in a generic variant and it is exported.
>   The arch may use it verbatim or may have a local variant

Actually, this is not how we traditionally use Kbuild.asm:
This file is only included from the other asm/Kbuild files to
get the list of common files that should be exported from the
architectures. Originally, this included even files that had
no asm-generic counterpart, but that has probably changed now.

The naming of that file may have been a bit confusing.

We already have the list of exported files in
include/asm-generic/Kbuild that sort of does what you describe.

> In arch/$(ARCH)/include/Kbuild.asm-generic
> - This file is provided verbatim by asm-generic

I would just put this information into the 
arch/$(ARCH)/include/Kbuild file, with a different variable
name.

The other complication is that not all the files that an
architecture may take verbatim from asm-generic are also
exported.

> Something like:
> 
> export-y - for files listed in Kbuild.asm
> generic-y - for files listed in Kbuild.asm-generic
> 
> I will try to come up with a patch that uses this - or something
> similar.

Ok.

Would it be enough to have this?:

"generic-y" in arch/$(ARCH)/include/asm/Kbuild:
  The architecture does not provide this header, the kernel should use
  the asm-generic version through a generated file.

"header-y" in arch/$(ARCH)/include/asm/Kbuild and include/asm-generic/Kbuild.asm:
  This file gets exported to user space (as before), and may come from either
  arch/$(ARCH)/include/asm or include/asm-generic (if listed as generic-y).

"header-y" in include/asm-generic/Kbuild: The asm-generic version of the header
 gets installed. We always do this, because there might be reasons to install
 headers for multiple architectures (with a symlink or similar).

We could either install the generated file or a copy of the asm-generic file
for any exported header that the architecture does not have itself.

	Arnd
