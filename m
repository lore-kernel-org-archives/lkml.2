Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0G1GTK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:19:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38696 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0G1GTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oQMkpkV4TISzHf/2j0UM1DC0706yYWQ/MRy30i6hzrFinkYofzHEep8E9PrLYYrXgc
         Gx4jEXFEQ5diOFnsFztaniRmiOS5KeJiNjhK57kv26jCFPCCWv6Pji5rKNSxg4Kec9Jn
         4yaMNpFmSO63QUv7iRmPyhsxnRNytZBdXxfg0=
Date: Wed, 28 Jul 2010 14:23:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Ulf Magnusson <ulfalizer.lkml@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.35-rc6] kconfig: fix MODULES-related bug in case of
 no .config
Message-ID: <20100728062313.GC5161@cr0.nay.redhat.com>
References: <20100727192727.GA17954@ulf>
 <20100727195742.GA18079@ulf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727195742.GA18079@ulf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 09:57:43PM +0200, Ulf Magnusson wrote:
>On Tue, Jul 27, 2010 at 09:27:27PM +0200, Ulf Magnusson wrote:
>> Hi,
>> 
>> There seems to be a kconfig bug due to MODULES not always being evaluated if no
>> .config is found. Take the following Kconfig as an example:
>> 
>> config MODULES
>> 	def_bool y
>> 
>> config FOO
>> 	def_tristate m
>> 
>> With no .config, the following configuration is generated:
>> 
>> CONFIG_MODULES=y
>> CONFIG_FOO=y
>> 
>> With an empty .config, the following:
>> 
>> CONFIG_MODULES=y
>> CONFIG_FOO=m
>> 
>> Tristate choice statements can also exhibit the problem, due to having an
>> implicit rev_dep (select) containing "m".
>> 
>> The problem is that MODULES is never evaluted in conf_read_simple() unless
>> there's a .config. The following patch fixes this.

<snip>

>
>Silly error in the patch. The correct patch follows.
>
>Signed-off-by: Ulf Magnusson <ulfalizer.lkml@gmail.com>
>

Sounds good for me.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>


>diff -uNr linux.vanilla/scripts/kconfig/confdata.c linux.new/scripts/kconfig/confdata.c
>--- linux.vanilla/scripts/kconfig/confdata.c	2010-07-27 16:47:43.443006287 +0200
>+++ linux.new/scripts/kconfig/confdata.c	2010-07-27 21:48:07.471550551 +0200
>@@ -170,8 +170,11 @@
> 		if (in)
> 			goto load;
> 		sym_add_change_count(1);
>-		if (!sym_defconfig_list)
>+		if (!sym_defconfig_list) {
>+			if (modules_sym)
>+				sym_calc_value(modules_sym);
> 			return 1;
>+		}
> 
> 		for_all_defaults(sym_defconfig_list, prop) {
> 			if (expr_calc_value(prop->visible.expr) == no ||
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
