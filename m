Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1IFSzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:55:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59621 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1IFSzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:55:48 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUC-m7AgEPG2C-V2SVKEhHxdYE8tOSFJvqO9Vq+JJEchw@mail.gmail.com>
References: <4E65DF36.6040507@parrot.com>
	<CACqU3MU9nuW+a3AJfY_PRqFH_tgaKtBJrp1pU2xpB_dHYANBXg@mail.gmail.com>
	<4E663882.4050404@parrot.com>
	<CACqU3MUC-m7AgEPG2C-V2SVKEhHxdYE8tOSFJvqO9Vq+JJEchw@mail.gmail.com>
Date: Tue, 6 Sep 2011 14:55:47 -0400
Message-ID: <CACqU3MUL0t6RYDRDQuiyco-ME=ccW6p+_pEkuRm_e=VAZa5HzA@mail.gmail.com>
Subject: Re: randconfig broken on choice
From: Arnaud Lacombe <lacombar@gmail.com>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 6, 2011 at 11:32 AM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,
>
> On Tue, Sep 6, 2011 at 11:13 AM, Matthieu CASTET
> <matthieu.castet@parrot.com> wrote:
>> Hi,
>>
>> Arnaud Lacombe a écrit :
>>> Hi,
>>>
>>> On Tue, Sep 6, 2011 at 4:52 AM, Matthieu CASTET
>>> <matthieu.castet@parrot.com> wrote:
>>>> Hi,
>>>>
>>>> I am using v3.1-rc4 and make randconfig look broken for choice.
>>>> The choice config is always the same or choice entry can have more than one entry.
>>>>
>>> Could you includes testcases showing that behavior, please ?
>> $ make randconfig
>>
>> $ grep -e SLUB -e SLAB -e SLOB .config
>> # CONFIG_SLAB is not set
>> CONFIG_SLUB=y
>> CONFIG_SLOB=y
>> # CONFIG_FAILSLAB is not set
>>
>> We have 2 choice selected (SLUB and SLOB). You may run randconfig (more than one
>> time to get this result).
>>
> ok, I reproduced it with:
>
> while true; do
>    make randconfig
>    CONFIG_SLAB=; CONFIG_SLOB=; CONFIG_SLUB=
>    source .config
>    if [ "${CONFIG_SLAB}${CONFIG_SLOB}${CONFIG_SLUB}" != "y" ]; then
>        break
>    fi
>    sleep 1
> done
>
> I wonder what set the flags originally...
>
This is interesting; I'm always getting the following:

CONFIG_SLUB=y
CONFIG_SLOB=y

never CONFIG_SLAB and another one. Actually, the default of the choice
ends up being selected along with the random one. Is this what you
mean by "we don't take "sym->def[S_DEF_USER].tri" but the "default
sym->cur.tri"" ? However, I do not see this behavior with the
following reduced testcase:

config EXPERT
        bool
        default y

choice
        prompt "Choose SLAB allocator"
        default SLUB

config SLAB
        bool "SLAB"

config SLUB
        bool "SLUB (Unqueued Allocator)"

config SLOB
        depends on EXPERT
        bool "SLOB (Simple Allocator)"

endchoice

Btw, you say that "we don't clean SYMBOL_VALID for choice entry", but
AFAIU the code, we explicitly set the not-randomly-chosen choice value
to 'no', so it's value should be valid.

 - Arnaud
