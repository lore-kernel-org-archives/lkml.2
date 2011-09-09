Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab1IIJE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 05:04:26 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:36284 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933053Ab1IIJEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 05:04:25 -0400
Message-ID: <4E69D693.6030300@parrot.com>
Date: Fri, 9 Sep 2011 11:04:19 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Arnaud Lacombe <lacombar@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: Re: randconfig broken on choice
References: <4E65DF36.6040507@parrot.com>	<CACqU3MU9nuW+a3AJfY_PRqFH_tgaKtBJrp1pU2xpB_dHYANBXg@mail.gmail.com>	<4E663882.4050404@parrot.com>	<CACqU3MUC-m7AgEPG2C-V2SVKEhHxdYE8tOSFJvqO9Vq+JJEchw@mail.gmail.com> <CACqU3MUL0t6RYDRDQuiyco-ME=ccW6p+_pEkuRm_e=VAZa5HzA@mail.gmail.com>
In-Reply-To: <CACqU3MUL0t6RYDRDQuiyco-ME=ccW6p+_pEkuRm_e=VAZa5HzA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaud,

Arnaud Lacombe a écrit :
> Hi,
> 
> On Tue, Sep 6, 2011 at 11:32 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
>> Hi,
>>
>> On Tue, Sep 6, 2011 at 11:13 AM, Matthieu CASTET
>> <matthieu.castet@parrot.com> wrote:
>>> Hi,
>>>
>>> Arnaud Lacombe a écrit :
>>>> Hi,
>>>>
>> ok, I reproduced it with:
>>
>> while true; do
>>    make randconfig
>>    CONFIG_SLAB=; CONFIG_SLOB=; CONFIG_SLUB=
>>    source .config
>>    if [ "${CONFIG_SLAB}${CONFIG_SLOB}${CONFIG_SLUB}" != "y" ]; then
>>        break
>>    fi
>>    sleep 1
>> done
>>
>> I wonder what set the flags originally...
>>
> This is interesting; I'm always getting the following:
> 
> CONFIG_SLUB=y
> CONFIG_SLOB=y
> 
> never CONFIG_SLAB and another one. Actually, the default of the choice
> ends up being selected along with the random one. Is this what you
> mean by "we don't take "sym->def[S_DEF_USER].tri" but the "default
> sym->cur.tri"" ?
Yes, what I mean is that we don't take the value set by randomize_choice_values,
 but some default values.
I wonder why the other one is random (I don't search who set cur value).

You can see the problem with the attached patch

and do make randconfig | grep -e "SL[UAO]B,"


 However, I do not see this behavior with the
> following reduced testcase:
> 
> 
Yes that's weird.

> Btw, you say that "we don't clean SYMBOL_VALID for choice entry", but
> AFAIU the code, we explicitly set the not-randomly-chosen choice value
> to 'no', so it's value should be valid.
> 
I don't understand what you mean.

What I saw is that randomize_choice_values modify sym->def[S_DEF_USER],
but because it is already marked valid, we never use sym->def[S_DEF_USER] in the
code writing the .config.


Matthieu


diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index b633bdb..eecb7af 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -147,6 +147,9 @@ struct property *sym_get_env_prop(struct symbol *sym);

 static inline tristate sym_get_tristate_value(struct symbol *sym)
 {
+	printf("name %s, cur=%d(%s) user=%d(%s)\n", sym->name,
+			sym->curr.tri, sym->flags & SYMBOL_VALID?"valid":"invalid",
+			sym->def[S_DEF_USER].tri, sym->flags & SYMBOL_DEF_USER?"valid":"invalid");
 	return sym->curr.tri;
 }

