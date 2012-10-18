Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab2JRKWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:22:52 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50383 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405Ab2JRKWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <17290.1350303547@warthog.procyon.org.uk>
References: <6862.1350090285@turing-police.cc.vt.edu>
	<17290.1350303547@warthog.procyon.org.uk>
Date: Thu, 18 Oct 2012 18:22:48 +0800
Message-ID: <CAPgLHd-9oJhKGfpewf2shxKhGWFOVdcxjhFrvHx4fDc=hxo3Kw@mail.gmail.com>
Subject: Re: CONFIG_MODULE_SIG breaks out-of-tree modules in modpost.
From: Wei Yongjun <weiyj.lk@gmail.com>
To: dhowells@redhat.com
Cc: Valdis.Kletnieks@vt.edu, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 08:19 PM, David Howells wrote:
> Valdis Kletnieks <Valdis.Kletnieks@vt.edu> wrote:
>
>> /bin/sh: -c: line 0: syntax error near unexpected token `;'
>> /bin/sh: -c: line 0: `set -e;  ; echo 'cmd_/usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/nvidia.ko := ' > /usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/.nvidia.ko.cmd'
> I would guess that this is from Kbuild.include's 'if_changed' macro:
>
> 	if_changed = $(if $(strip $(any-prereq) $(arg-check)),       \
> 		@set -e;                                             \
> 		$(echo-cmd) $(cmd_$(1));                             \
> 		echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
>
> unless nvidia.ko has its own build rules.
>
> It looks like either $(call if_changed) got invoked with no arguments or
> $(cmd_$(1)) didn't exist.
>
> Could you find out what $(1) was by adding a bit:
>
> 	if_changed = $(if $(strip $(any-prereq) $(arg-check)),       \
> 		$(info XXXX $(1))				     \
> 		@set -e;                                             \
> 		$(echo-cmd) $(cmd_$(1));                             \
> 		echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)
>
> You should see a line looking something like:
>
> 	XXX link_o_target
>
> emitted by make just before it the error occurs.

I built linux.git tree and hit the same issue.

After change Kbuild.include, I see the $(1) is 'sign_ko_ko_stripped'.

$ grep -nr MODULE_SIG .config
276:CONFIG_MODULE_SIG=y
277:CONFIG_MODULE_SIG_FORCE=y
278:CONFIG_MODULE_SIG_SHA1=y
279:# CONFIG_MODULE_SIG_SHA224 is not set
280:# CONFIG_MODULE_SIG_SHA256 is not set
281:# CONFIG_MODULE_SIG_SHA384 is not set
282:# CONFIG_MODULE_SIG_SHA512 is not set

$ make M=net/sctp
  Building modules, stage 2.
  MODPOST 2 modules
XXXX sign_ko_stripped_ko_unsigned
  STRIP [M] net/sctp/sctp.ko.stripped
XXXX sign_ko_ko_stripped
/bin/sh: -c: line 0: syntax error near unexpected token `;'
/bin/sh: -c: line 0: `set -e;   ; echo 'cmd_net/sctp/sctp.ko := ' > net/sctp/.sctp.ko.cmd'
make[1]: *** [net/sctp/sctp.ko] Error 1
make: *** [modules] Error 2


