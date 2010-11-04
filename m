Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab0KDEPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 00:15:16 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60115 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab0KDEPO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 00:15:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bEshElrFFyYnUDxMNvAQn9a7zW8Be+X/hhiQuWvA+WYfeDh6XnZ/z0GQq++Ys93av2
         c01wRsbUwdd36C57y3rzvC+jAm5eNVWNj8gFvghTq6TC4nOVJR9zt1m3JdpJcu421aSS
         FMIM36lybI3z+SNtk4mO/xMav8Zd2y9FXjYZU=
MIME-Version: 1.0
In-Reply-To: <4CD22627.2000607@redhat.com>
References: <20101009224041.GA901@sepie.suse.cz>
	<4CD1E232.30406@redhat.com>
	<AANLkTimyh-k8gYwuNi6nZFp3oviQ33+M3fDRzZ+sJN9i@mail.gmail.com>
	<4CD22627.2000607@redhat.com>
Date: Thu, 4 Nov 2010 00:15:13 -0400
Message-ID: <AANLkTi=Eb8k6gmeGqvC=Zbo2mj51oHcbCncZGt00u9Tx@mail.gmail.com>
Subject: Re: REGRESSION: Re: [GIT] kconfig rc fixes
From: Arnaud Lacombe <lacombar@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, kyle@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Nov 3, 2010 at 11:19 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 03-11-2010 22:31, Arnaud Lacombe escreveu:
>> Hi,
>>
>> On Wed, Nov 3, 2010 at 6:29 PM, Mauro Carvalho Chehab
>> <mchehab@redhat.com> wrote:
>>> Em 09-10-2010 18:40, Michal Marek escreveu:
>>>>
>>>> Arnaud Lacombe (1):
>>>>       kconfig: delay symbol direct dependency initialization
>>>
>>> This patch generated a regression with V4L build. After applying it,
>>> some Kconfig dependencies that used to work with V4L Kconfig broke.
>>>
>> of course, but they were all-likely buggy. If a compiler version N
>> outputs a new legitimate warning because of a bug in the code, you do
>> not switch back to the previous version because the warning wasn't
>> there, you fix the code.
>>
>> That said, please point me to a false positive, eventually with a
>> minimal testcase, and I'll be happy to fix the issue.
>
> Arnaud,
>
> In the case of V4L and DVB drivers, what happens is that the same
> USB (or PCI) bridge driver can be attached to lots of
> different chipsets that do analog/digital/audio decoding/encoding.
>
> A normal user won't need to open his USB TV stick just to see TV on it.
> It just needs to select a bridge driver, and all possible options for encoders
> and decoders are auto-selected.
>
> If you're an advanced user (or are developing an embedded hardware), you
> know exactly what are the components inside the board/stick. So, the
> Kconfig allows to disable the automatic auto-selection, doing manual
> selection.
>
> The logic basically implements it, using Kconfig way, on a logic like:
>
>        auto = ask_user_if_ancillary_drivers_should_be_auto_selected();
>        driver_foo = ask_user_if_driver_foo_should_be_selected();
>        if (driver_foo && auto) {
>                select(bar1);
>                select(bar2);
>                select(bar3);
>                select(bar4);
>        }
> ...
>        if (!auto) {
>                open_menu()
>                ask_user_if_bar1_should_be_selected();
>                ask_user_if_bar2_should_be_selected();
>                ask_user_if_bar3_should_be_selected();
>                ask_user_if_bar4_should_be_selected();
> ...
>                close_menu()
>        }
>
no, you are hijacking Kconfig for something "illegal". Note that this
last word is not mine, it is the word used in the language
description:

  Note:
        select should be used with care. select will force
        a symbol to a value without visiting the dependencies.
        By abusing select you are able to select a symbol FOO even
        if FOO depends on BAR that is not set.
        In general use select only for non-visible symbols
        (no prompts anywhere) and for symbols with no dependencies.
        That will limit the usefulness but on the other hand avoid
        the illegal configurations all over.
        kconfig should one day warn about such things.

I guess the last line will need to be dropped, as this day has come.

 - Arnaud
