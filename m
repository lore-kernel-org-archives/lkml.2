Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0HWGlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:41:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63193 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0HWGlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H80HnP2BLSHAxRVUUPoKTND2Rlm46Ak+S9VHsObv9IzVO5cn8ZfBJn/ISFGt1QFMzP
         bBwbugwZf8A3lpLxmOvUtUG2sq91MxTcXTEXrpXXm/Z0INY5+qmHru4ctm+qA6O8Z47K
         G0+04HyqguRe5m5pZyUNRKKo/wtBaCXNjOLlU=
Date: Mon, 23 Aug 2010 14:45:30 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH -mm V3] kbuild: fix reading CROSS_COMPILE from .config
Message-ID: <20100823064530.GL5168@cr0.nay.redhat.com>
References: <20100821130749.GA22280@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821130749.GA22280@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 09:07:49PM +0800, Wu Fengguang wrote:
>Fix compile error
>
>        $ ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- make
>        ...
>        cc1: error: unrecognized command line option "-m64"
>        cc1: error: unrecognized command line option "-mno-red-zone"
>        cc1: error: unrecognized command line option "-mcmodel=kernel"
>        cc1: error: unrecognized command line option "-maccumulate-outgoing-args"
>
>The error was introduced by patch
>kbuild-fix-config_cross_compile-issue-in-config.patch:
>
>  -CROSS_COMPILE  ?= $(CONFIG_CROSS_COMPILE:"%"=%)
>  +CROSS_COMPILE  := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
>
>That patch does two things:
>1) It grep for CONFIG_CROSS_COMPILE because we may not have incldued .config
>2) It no longer pick up CROSS_COMPILE from the environment.
>
>Traditionally we have picked up ARCH and CROSS_COMPILE from the environment,
>hence the use of "?=".
>"?=" says - perform this assignment unless lhs is already defined.
>And lhs may be already defined is we have the symbol defined in the
>environment.
>
>I think the original submitter changed from ?= to := without realizing this.
>So the patch should be adjusted to use ?= again before it is applied.
>
>Cc: Tiago Maluta <tiago.maluta@gmail.com>
>Cc: Michal Marek <mmarek@suse.cz>
>Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>


I think the line right above the chunk can be removed too, anyway,

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks.

>---
>
>Andrew: it's an -mm tree only bug for now
>Sam: I copied so many of your nice comments to the changelog, so that I added
>your Signed-off-by :)
>
>diff --git a/Makefile b/Makefile
>index d646d69..af8864e 100644
>--- a/Makefile
>+++ b/Makefile
>@@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> export KBUILD_BUILDHOST := $(SUBARCH)
> ARCH		?= $(SUBARCH)
> CROSS_COMPILE	?=
>-CROSS_COMPILE	:= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
>+CROSS_COMPILE	?= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> 
> # Architecture as present in compile.h
> UTS_MACHINE 	:= $(ARCH)
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
