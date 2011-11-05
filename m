Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1KELss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 07:48:48 -0400
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:48167 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1KELsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 07:48:47 -0400
Subject: Re: [GIT PULL] UML changes for 3.2
From: Paul Bolle <pebolle@tiscali.nl>
To: Michal Marek <mmarek@suse.cz>
Cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org,
        Peter Foley <pefoley2@verizon.net>, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <4EB3C167.3020508@suse.cz>
References: <4EB14F51.1050004@nod.at>
	 <1320348750.14409.249.camel@x61.thuisdomein>
	 <1320352899.14409.260.camel@x61.thuisdomein>
	 <1320354072.14409.265.camel@x61.thuisdomein>  <4EB3045A.6050501@nod.at>
	 <1320355503.14409.269.camel@x61.thuisdomein>  <4EB30994.9050309@nod.at>
	 <1320357369.14409.276.camel@x61.thuisdomein>
	 <1320358228.14409.279.camel@x61.thuisdomein>  <4EB3C167.3020508@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Nov 2011 12:48:28 +0100
Message-ID: <1320493708.14409.336.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Added Sam Ravnborg. Dropped Linus Torvalds and Andrew Morton, who by
now probably prefer not getting this message directly.)

On Fri, 2011-11-04 at 11:41 +0100, Michal Marek wrote:
> I doub't kxgettext needs $SUBARCH at all, it only cares about the
> prompts and help texts, it does not evaluate any kconfig symbols.

0) That seems correct. But the fact is that kxgettext calls conf_parse()
right away, and that somehow triggers
    menu_add_option()
        prop_add_env()

and that last function will print this warning. Mucking about in all
that code to make this warning disappear seems wrong.

1) A straightforward fix could be:
diff --git a/Makefile b/Makefile
index 07bc925..2b8ee64 100644
--- a/Makefile
+++ b/Makefile
@@ -191,7 +191,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 # "make" in the configured kernel build directory always uses that.
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile
-export KBUILD_BUILDHOST := $(SUBARCH)
+export SUBARCH
 ARCH           ?= $(SUBARCH)
 CROSS_COMPILE  ?= $(CONFIG_CROSS_COMPILE:"%"=%)
 
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 08dce14..9e178f6 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -66,7 +66,7 @@ modules   := $(patsubst %.o,%.ko, $(wildcard $(__modules:.ko=.o)))
 # Stop after building .o files if NOFINAL is set. Makes compile tests quicker
 _modpost: $(if $(KBUILD_MODPOST_NOFINAL), $(modules:.ko:.o),$(modules))
 
-ifneq ($(KBUILD_BUILDHOST),$(ARCH))
+ifneq ($(SUBARCH),$(ARCH))
         cross_build := 1
 endif
 

KBUILD_BUILDHOST was introduced in commit 4ce6efed ("kbuild: soften
modpost checks when doing cross builds"). It's an alias of SUBARCH
that's used just once. It's not clear to me why SUBARCH can't be used
directly instead of that alias.

2) Using SUBARCH directly (and dropping KBUILD_BUILDHOST) makes this
warning go away. Could that break anything?


Paul Bolle

