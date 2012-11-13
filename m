Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab2KMP00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 10:26:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab2KMP0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 10:26:24 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com>
References: <CA+5PVA5vMyNmQYCLX315Jc+kN9zQuZo_h0Devpjfr43TezE-qA@mail.gmail.com> <1378.1352379110@warthog.procyon.org.uk>
To: acme@ghostprotocols.net, Josh Boyer <jwboyer@gmail.com>,
        xiaoguangrong@linux.vnet.ibm.com
Cc: dhowells@redhat.com, mingo@kernel.org, haodong@linux.vnet.ibm.com,
        runzhen@linux.vnet.ibm.com, dsahern@gmail.com, tglx@linutronix.de,
        bp@alien8.de, namhyung@gmail.com, torvalds@linux-foundation.org,
        paulus@samba.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [GIT PULL] UAPI: perf fixes
Date: Tue, 13 Nov 2012 15:24:31 +0000
Message-ID: <18065.1352820271@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@gmail.com> wrote:

> This patch seems to break building perf on ppc64.  It fails with:
> 
> + make -j16 -C tools/perf -s V=1 WERROR=0 HAVE_CPLUS_DEMANGLE=1 prefix=/usr all
> 
> <snip>
> 
> builtin-kvm.c:25:21: fatal error: asm/svm.h: No such file or directory

tools/perf/builtin-kvm.c became x86-only with the following commit:

	commit bcf6edcd6fdb8965290f0b635a530fa3c6c212e1
	Author: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
	Date:   Mon Sep 17 16:31:15 2012 +0800
	Subject: perf kvm: Events analysis tool

when it added:

	+#include "../../arch/x86/include/asm/svm.h"
	+#include "../../arch/x86/include/asm/vmx.h"
	+#include "../../arch/x86/include/asm/kvm.h"

and my changing these to <asm/foo.h> doesn't matter because of this in the
same file:

	+struct exit_reasons_table vmx_exit_reasons[] = {
	+       VMX_EXIT_REASONS
	+};
	+
	+struct exit_reasons_table svm_exit_reasons[] = {
	+       SVM_EXIT_REASONS
	+};

which use macros only x86 defines.

Should the exported parts of these files be moved to asm-generic?

David
