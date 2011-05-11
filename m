Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab1EKDdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 23:33:09 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:34934 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab1EKDdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 23:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=HijT1fIV4jSIzY1PJ/Fnpt/hLzV5Y3/8xtPyuHUBRhpMfaFbs5w124IW2dKtBTnYNj
         XmHfJ5/drnS3tmRmdZ3u1RfBt23MyZIKqq34l4p8F7jQBdEjf7ThOwnjLTgiLODFDbf5
         PeHlS9RAsmQOGzyXl/H4Zzw99D2exH74Fywn4=
MIME-Version: 1.0
In-Reply-To: <1302960373-5309-1-git-send-email-abogani@kernel.org>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Tue, 10 May 2011 23:32:46 -0400
Message-ID: <BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 16, 2011 at 09:26, Alessio Igor Bogani wrote:
> In the first place I changed the code for place every symbol in a different
> section (for example: "___ksymtab" sec "__" #sym) at compile time (this the
> above mentioned trick!). Thus I request to the linker to sort and merge all
> these sections into the appropriate ones (for example: "__ksymtab") at link
> time using the linker scripts. Once all symbols are sorted we can use binary
> search instead of the linear one.

this breaks symbol prefixed arches (like Blackfin):
  CC      kernel/softirq.o
/tmp/ccp3A6LU.s: Assembler messages:
/tmp/ccp3A6LU.s:3734: Error: symbol `___ksymtab__local_bh_enable' is
already defined
make[1]: *** [kernel/softirq.o] Error 1

this is because your new system of section naming happens to overlap
actual symbol names and the gnu assembler does not allow you to
declare a section and a symbol with the same name.

might be better to pick a separator that cannot appear in a symbol
name.  so rather than "__", use "+".  or some other funky char.
-mike
