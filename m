Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0FUTHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 15:07:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50106 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268Ab0FUTHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 15:07:02 -0400
Date: Mon, 21 Jun 2010 12:06:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tiago Maluta <tiago.maluta@gmail.com>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Fix CONFIG_CROSS_COMPILE issue in .config
Message-Id: <20100621120613.86cad1a4.akpm@linux-foundation.org>
In-Reply-To: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
References: <AANLkTim2mi0wbJJl17OkbCJbRt-s5phR4sumn5GsJKUp@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 12:50:52 +0000
Tiago Maluta <tiago.maluta@gmail.com> wrote:

> Linux has an recent option to define CROSS_COMPILE in menuconfig.
> 
> Typically, one of the options when building for another target is
> ('arm' is just an example):
> 
> # make ARCH=arm CROSS_COMPILE=arm-cc O=../build
> 
> If I omit CROSS_COMPILE and use the new way in .config:
> CONFIG_CROSS_COMPILE="arm-cc"
> 
> I got:
> 
>    cc1: error: unrecognized command line option "-mlittle-endian"
>    cc1: error: unrecognized command line option "-mabi=aapcs-linux"
>    cc1: error: unrecognized command line option "-mno-thumb-interwork"
>    /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for
> -march= switch
>    /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for
> -mtune= switch
>    make[2]: *** [kernel/bounds.s] Error 1
>    make[1]: *** [prepare0] Error 2
>    make: *** [sub-make] Error 2
> 
> Verbose output clearly says that I'm using the host compiler instead
> cross compiler.
> This patch fixed my problem:
> 
> ---
> __Makefile |______ 2 +-
> __1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index d49d96c..5a6c7d5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/
> -e s/sun4u/sparc64/ \
> __export KBUILD_BUILDHOST := $(SUBARCH)
> __ARCH____________________ ?= $(SUBARCH)
> __CROSS_COMPILE__ ?=
> -CROSS_COMPILE__ ?= $(CONFIG_CROSS_COMPILE:"%"=%)
> +CROSS_COMPILE__ := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> 
> __# Architecture as present in compile.h
> __UTS_MACHINE______ := $(ARCH)
> --

Perhaps the "%"=% thing isn't supported with your version of make(1). 
Which version are you using?

Directly grepping .config probably isn't the right thing to do. 
Maybe `patsubst' can be used here.



Administrivia:

Your email client wordwraps the patches and replaces tabs with weird
non-ascii characters.  

Please include a Signed-off-by: with patches, as described in
Documentation/SubmittingPatches, thanks.
