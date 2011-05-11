Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab1EKQYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:24:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47652 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab1EKQYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c9re1J1LQbsOOTP1CGIyCO27DQ+VYRZfJL30pSVH/wiY/zd/ZwUOYI3mYMpga1z4UQ
         y6ercJmEnU4j3kAFv5zb8XL2nZ3BLbg/MtZzJwV7gV/k+ejf3EXcamvEEOc4whkYNQyg
         s7uhYLuK26g8JME3jBqOMN5XCODP8RVfP4Cr0=
MIME-Version: 1.0
In-Reply-To: <BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
	<BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
	<BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
	<BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
Date: Wed, 11 May 2011 15:44:41 +0200
X-Google-Sender-Auth: zvmFneocmv5u6ZkXEPzTMiD6eKk
Message-ID: <BANLkTimxJNOpwQVZDZ8Vv8rqcDh28v9i6Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
From: Alessio Igor Bogani <abogani@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Frysinger,

2011/5/11 Alessio Igor Bogani <abogani@kernel.org>:
[...]
>>> this breaks symbol prefixed arches (like Blackfin):
>>>  CC      kernel/softirq.o
>>> /tmp/ccp3A6LU.s: Assembler messages:
>>> /tmp/ccp3A6LU.s:3734: Error: symbol `___ksymtab__local_bh_enable' is
>>> already defined
[...]
>>> name.  so rather than "__", use "+".
>
> Sorry I don't think that is a good choice from a long term point of
> view. What do you think to add MODULE_SYMBOL_PREFIX to section names
> instead? In this way symbol and section names should always be
> different also on symbol prefixed archs (which are blackfin and
> h8300).

I'm thinking to something like this:

diff --git a/include/linux/module.h b/include/linux/module.h
index 98ddaf0..c4aa266 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -223,7 +223,7 @@ struct module_use {
 	extern void *__crc_##sym __attribute__((weak));		\
 	static const unsigned long __kcrctab_##sym		\
 	__used							\
-	__attribute__((section("___kcrctab" sec "__"#sym), unused))	\
+	__attribute__((section("___kcrctab" sec "___" MODULE_SYMBOL_PREFIX
#sym), unused))	\
 	= (unsigned long) &__crc_##sym;
 #else
 #define __CRC_SYMBOL(sym, sec)
@@ -238,7 +238,7 @@ struct module_use {
 	= MODULE_SYMBOL_PREFIX #sym;                    	\
 	static const struct kernel_symbol __ksymtab_##sym	\
 	__used							\
-	__attribute__((section("___ksymtab" sec "__"#sym), unused))	\

+	__attribute__((section("___ksymtab" sec "___" MODULE_SYMBOL_PREFIX
#sym), unused))	\
 	= { (unsigned long)&sym, __kstrtab_##sym }

 #define EXPORT_SYMBOL(sym)					\

Could you try this, please?

Thank you very much!

Ciao,
Alessio
