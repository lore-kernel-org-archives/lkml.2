Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1ERGX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 02:23:28 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52814 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1ERGX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 02:23:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lAUssC2VGApZkj/eXLo2e8u9/m58RqYG7Z7fagR9XC7qgK7wN5UnSrVNomGPsn+OhM
         4FxTLhnVOamXkBooV8NuHYpqb803qzZRfdFeeeeafWUg58OEacNpCDYDFMt6Dsgxspsf
         EketQEx8Qi5W3ehAUAOGchKa63d6WebT4nk+0=
MIME-Version: 1.0
In-Reply-To: <20110517195310.GA17003@merkur.ravnborg.org>
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz>
	<20110517195310.GA17003@merkur.ravnborg.org>
Date: Wed, 18 May 2011 02:23:26 -0400
Message-ID: <BANLkTikmO7D3kUgU62d4_VC2ZPZCnSEqKA@mail.gmail.com>
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and
 tristate options
From: Arnaud Lacombe <lacombar@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Valdis.Kletnieks@vt.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[added Valdis.Kletnieks@vt.edu to CC:]

On Tue, May 17, 2011 at 3:53 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Tue, May 17, 2011 at 05:35:32PM +0200, Michal Marek wrote:
>> For strings and integers, the config_is_xxx macros are useless and
>> sometimes misleading:
>>
>>   #define CONFIG_INITRAMFS_SOURCE ""
>>   #define config_is_initramfs_source() 1
>
> I'm late with this comment....
> Could we introduce "config_is_foo" using a syntax that
> does not break grepability?
>
> Maybe a syntax like this?
>
>    #ifdef CONFIG_FOO
>
> and
>
>    if (KCONFIG_FOO())
>
> Grepping for the use of a symbol is a very typical thing,
> so we should try to keep this.
> And with the suggested syntax above I expect fixdep to
> catch up both usage types.
>
Actually, there is already an issue, on a much smaller scale, in the
current tree with NUMA_BUILD and COMPACTION_BUILD. The real way to fix
this would be to always defines CONFIG_FOO, its value being 1 or 0
depending on whether or not the symbol is selected. This is a
+35k/-35k change.

Also, I find KCONFIG_FOO() is too specific to be in the kernel source,
and redundant with CONFIG_FOO.

I've been playing a bit with the preprocessor, and reached that point:

#define EXPAND(x)       __ ## x
#define CONFIGURED(x)   \
        ({  int __1 __maybe_unused = 1;         \
            int __ ## x __maybe_unused = 0;     \
            EXPAND(x); })

I am not specifically proud of that, use case would be:

extern func(void);
int fn()
{
        if(CONFIGURED(CONFIG_FOO))
                func();
}

The issue I am seeing is that it adds a dependency to the optimizer,
as gcc will not optimize the branch away at -O0.

The advantage is that it is not intrusive at all within kconfig.

 - Arnaud
