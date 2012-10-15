Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2JOMTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:19:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752910Ab2JOMTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:19:13 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <6862.1350090285@turing-police.cc.vt.edu>
References: <6862.1350090285@turing-police.cc.vt.edu>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
Subject: Re: CONFIG_MODULE_SIG breaks out-of-tree modules in modpost.
Date: Mon, 15 Oct 2012 13:19:07 +0100
Message-ID: <17290.1350303547@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis Kletnieks <Valdis.Kletnieks@vt.edu> wrote:

> /bin/sh: -c: line 0: syntax error near unexpected token `;'
> /bin/sh: -c: line 0: `set -e;  ; echo 'cmd_/usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/nvidia.ko := ' > /usr/src/valdis/NVIDIA-Linux-x86_64-304.51/kernel/.nvidia.ko.cmd'

I would guess that this is from Kbuild.include's 'if_changed' macro:

	if_changed = $(if $(strip $(any-prereq) $(arg-check)),       \
		@set -e;                                             \
		$(echo-cmd) $(cmd_$(1));                             \
		echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)

unless nvidia.ko has its own build rules.

It looks like either $(call if_changed) got invoked with no arguments or
$(cmd_$(1)) didn't exist.

Could you find out what $(1) was by adding a bit:

	if_changed = $(if $(strip $(any-prereq) $(arg-check)),       \
		$(info XXXX $(1))				     \
		@set -e;                                             \
		$(echo-cmd) $(cmd_$(1));                             \
		echo 'cmd_$@ := $(make-cmd)' > $(dot-target).cmd)

You should see a line looking something like:

	XXX link_o_target

emitted by make just before it the error occurs.

David
