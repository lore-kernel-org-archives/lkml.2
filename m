Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751241Ab1GSNpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:45:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45387 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab1GSNpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:45:41 -0400
Message-ID: <4E258A83.3030608@suse.cz>
Date: Tue, 19 Jul 2011 15:45:39 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and tristate
 options
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz> <20110517195310.GA17003@merkur.ravnborg.org> <BANLkTikmO7D3kUgU62d4_VC2ZPZCnSEqKA@mail.gmail.com> <4E1D9C25.8080300@suse.cz> <20110713200813.GA11538@merkur.ravnborg.org>
In-Reply-To: <20110713200813.GA11538@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.7.2011 22:08, Sam Ravnborg wrote:
> On Wed, Jul 13, 2011 at 03:22:45PM +0200, Michal Marek wrote:
>> On 18.5.2011 08:23, Arnaud Lacombe wrote:
>>> I've been playing a bit with the preprocessor, and reached that point:
>>>
>>> #define EXPAND(x)       __ ## x
>>> #define CONFIGURED(x)   \
>>>           ({  int __1 __maybe_unused = 1;         \
>>>               int __ ## x __maybe_unused = 0;     \
>>>               EXPAND(x); })
>>>
>>> I am not specifically proud of that, use case would be:
>>>
>>> extern func(void);
>>> int fn()
>>> {
>>>           if(CONFIGURED(CONFIG_FOO))
>>>                   func();
>>> }
>>
>> I finally got round to revisit this. Your approach inspired me to a much
>> simpler scheme: Instead of generating the config_is_xxx macros for
>> direct use in the code, name them __enabled_CONFIG_XXX or similar and
>> have a macro that expands given CONFIG_XXX symbol to the other form:
>
> But then we clutter the namesapce with another set of variables that will
> be misued. If not in the kernel then by other kconfig users.

Well, no sane person will prefix their variables with 
"__enabled_CONFIG_", so I'm not so worried about the namespace pollution.


> Arnaud approach is nice as it does not require any additional
> symbols to be generated.

Sure, I would also prefer a solution without that doesn't require 
generating new macros. But your's and Arnaud's trick doesn't eliminate 
the configured-out code at -O0, while with the help of the generated 
helper macros, the compiler sees an if(0) or if(1).


> +#include<linux/compiler.h>
> +
> +#define __symbol_value(sym)       __ ## x
> +#define __symbol_module(sym)      __symbol_value(__ ## sym ## _MODULE)
> +
> +/* return 1 if x is defined and not a module */
> +#define KCONFIG_NON_MODULE(sym)					\
> +	({ int __1 __maybe_unused = 1;				\
> +	   int __ ## sym __maybe_unused = 0;			\
> +	   __symbol_value(sym); })
> +
> +/* return 1 if sym is a module symbol */
> +#define KCONFIG_MODULE(sym)					\
> +	({ int __1 __maybe_unused = 1;				\
> +	   int __ ## sym ## _MODULE __maybe_unused = 0;	\
> +	   __symbol_value(sym); })
> +
> +/* return 1 if sym is defined - module or not */
> +#define KCONFIG(sym) (KCONFIG_NON_MODULE(sym) || KCONFIG_MODULE(sym))

With this extra expansion, the passed CONFIG_FOO expands to 1 here and 
the KCONFIG(_NON)_MODULE macros will then only see the 1 and fail.

Michal
